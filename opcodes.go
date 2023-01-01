package main

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"os"
	"strings"
)

// generates OpCode structs and consts from the 6502 specification
// usage:
//    go run opcodes.go > internal/app/jetpack/opcodes.go

type OpCode struct {
	ins    string
	mode   string
	desc   string
	action string
	flags  uint8
	code   string
	bytes  string
	cycles string
	extra  uint8
}

var modeMap = map[string]string{
	"immediate":    "",
	"implied":      "",
	"zeropage":     "_Z",
	"zeropage,X":   "_ZX",
	"zeropage,Y":   "_ZY",
	"absolute":     "_A",
	"absolute,X":   "_AX",
	"absolute,Y":   "_AY",
	"indirect":     "_I",
	"(indirect,X)": "_IX",
	"(indirect),Y": "_IY",
}

func print(op OpCode) {
	fmt.Printf("    {\n        ins:    \"%s\",\n        mode:   \"%s\",\n        desc:   \"%s\",\n        action: \"%s\",\n        flags:  0x%02x,\n        code:   0x%s,\n        bytes:  %s,\n        cycles: %s,\n        extra:  %d,\n    },\n",
		op.ins, op.mode, op.desc, op.action, op.flags, op.code, op.bytes, op.cycles, op.extra)
}

func main() {
	file, err := os.Open("opcodes.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	fmt.Println("package jetpack\n\nvar opcodes = []OpCode {")

	var enum bytes.Buffer

	op := OpCode{}

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if len(line) == 3 {
			op.ins = line

			scanner.Scan()
			op.desc = scanner.Text()

			scanner.Scan()
			if len(scanner.Text()) != 0 {
				log.Fatalf("Expected blank line")
			}

			scanner.Scan()
			op.action = scanner.Text()

			scanner.Scan()
			if scanner.Text() != "N\tZ\tC\tI\tD\tV" {
				log.Fatalf("Expected N\tZ\tC\tI\tD\tV")
			}

			scanner.Scan()
			f := scanner.Text()
			flags := strings.Split(f, "\t")
			if len(flags) != 6 {
				log.Fatalf("Flags not len 6: %s", f)
			}
			for i := 0; i < 5; i++ {
				if flags[i] != "-" {
					op.flags |= 1 << i
				}
			}

			scanner.Scan()
			if !strings.HasPrefix(scanner.Text(), "addressing") {
				log.Fatalf("Expected addressing prefix")
			}

			for scanner.Scan() {
				mode := scanner.Text()
				if len(mode) == 0 {
					break
				}
				row := strings.Split(mode, "\t")
				if len(row) != 5 {
					log.Fatalf("Mode row not len 5: %s", row)
				}

				op.mode = row[0]
				op.code = row[2]
				op.bytes = row[3]
				op.extra = uint8(strings.Count(row[4], "*"))
				op.cycles = strings.ReplaceAll(row[4], "*", "")

				print(op)

				enum.WriteString(fmt.Sprintf("const %s%s = 0x%s\n", op.ins, modeMap[op.mode], op.code))
			}
			op = OpCode{}
		}
	}

	fmt.Println("}\n")
	fmt.Println(enum.String())

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
