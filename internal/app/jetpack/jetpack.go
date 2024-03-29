package jetpack

import (
	"fmt"
	"image"
	"image/png"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var sidHeader = SidHeader{}
var data []byte
var loadAddress uint16
var pc uint16                           // 6502 program counter
var ramStart uint16                     // offset at which ram block starts
var ramLen uint16                       // length of ram block
var zeroPageLen uint16                  // often only the lower bit of zero page is used, so we track the highest read or write
var totalInstructions = 0               // count total instructions translated
var totalOpcodes = make(map[uint8]bool) // track op codes we've translated
var opCodeMap = buildOpCodeMap()
var codeMap [0x10000]bool   // code at this address
var accessMap [0x10000]bool // absolute or indexed access to this address
var voidMap [0x10000]bool   // potentially eliminated code (if not in codeMap) but could have been kept on an alternate search.
var jumpPoints = make(map[uint16]bool)
var allowSelfModifying bool // set to false to ignore self modifying code
var printAllLabels bool     // print a label for each instruction, not just those needed for jumps and branches
var motr bool               // handle special cases for Monty_on_the_Run.sid

func BlastOff(path string, allowSelfMod bool, printAllLab bool, writeBin bool, writeMemoryMap bool, ramBase uint16) {
	allowSelfModifying = allowSelfMod
	printAllLabels = printAllLab

	motr = filepath.Base(path) == "Monty_on_the_Run.sid" // special handing for Monty yaa!
	if motr {
		ramBase = 0x8400 // for Monty On The Run we know we can load ram from 8400
	}

	file, err := os.Open(path)
	if err != nil {
		log.Fatalf("%s\n", err)
	}
	defer file.Close()

	readSidHeader(file)
	data = loadData(file)
	if writeBin {
		saveBinary(path + ".bin")
	}

	loadAddress = sidHeader.LoadAddress
	ramStart = loadAddress
	if ramBase != 0 {
		ramStart = ramBase
	}
	ramLen = uint16(len(data)) - (ramStart - loadAddress)
	searchCodeBlocks(sidHeader.InitAddress)
	searchCodeBlocks(sidHeader.PlayAddress)

	writePrefix()
	writeSidInfo(filepath.Base(path))
	transcodeBlocks()
	writeMontyFunctions()
	writeRamSpaces()
	writeSuffix()

	if writeMemoryMap {
		saveMemoryMap(strings.TrimSuffix(path, filepath.Ext(path)) + ".png")
	}
}

func writePrefix() {
	fmt.Printf("\n\n        .section .text\n\n")

	fmt.Printf(";    Generated by Jetpack\n")
	fmt.Printf(";    https://github.com/slipperyseal/jetpack\n\n")
}

func writeWordValue(name string, value uint16) {
	fmt.Printf(".global  %s\n", name)
	fmt.Printf("        .data\n")
	fmt.Printf("        .type %s, @object\n", name)
	fmt.Printf("        .size %s, 2\n", name)
	fmt.Printf("%s:\n", name)
	fmt.Printf("        .word %d\n\n", value)
}

func writeRamSpaces() {
	fmt.Printf("\n")

	fmt.Printf(".global  zero\n")
	fmt.Printf("        .section .bss\n")
	fmt.Printf("        .type zero, @object\n")
	fmt.Printf("        .size zero, %d\n", zeroPageLen)
	fmt.Printf("zero:\n")
	fmt.Printf("        .zero %d\n\n", zeroPageLen)

	writeWordValue("songcount", sidHeader.Songs)
	writeWordValue("songstart", sidHeader.StartSong)

	fmt.Printf(".global  ram\n")
	fmt.Printf("        .data\n")
	fmt.Printf("        .type ram, @object\n")
	fmt.Printf("        .size ram, %d\n", ramLen)
	fmt.Printf("ram:\n")
	writeBinary()
}

func loadData(file *os.File) []byte {
	readData, err := io.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}
	return readData
}

func lowestRAMAccess() uint16 {
	for index := uint32(ramStart); index < 0x10000; index++ {
		if accessMap[index] {
			return uint16(index)
		}
	}
	return ramStart
}

func highestRAMAccess() uint16 {
	for index := 0xffff; index >= int(ramStart); index-- {
		if accessMap[index] {
			return uint16(index)
		}
	}
	return ramStart
}

func writeSuffix() {
	fmt.Printf(".global __do_copy_data\n")
	fmt.Printf(".global __do_clear_bss\n\n")

	fmt.Printf(";   6502 opcodes translated: %d of %d\n", len(totalOpcodes), len(opCodeMap))
	fmt.Printf(";   instructions translated: %d\n", totalInstructions)
	fmt.Printf(";          zero page length: %d\n", zeroPageLen)
	fmt.Printf(";          RAM block length: %d\n", ramLen)
	fmt.Printf(";          RAM access range: $%04x - $%04x\n", lowestRAMAccess(), highestRAMAccess())
	fmt.Printf(";   Thank you for your cooperation.\n\n")

	fmt.Printf("        .end\n\n")
}

func writeBinary() {
	dataOff := ramStart - loadAddress
	l := int(ramLen) & 0xffff
	col := 0
	for b := 0; b < l; b++ {
		if col == 0 {
			fmt.Printf("        .ascii \"")
		}
		col++
		fmt.Printf("\\%03o", data[int(dataOff)+b])
		if col == 24 {
			fmt.Printf("\"\n")
			col = 0
		}
	}
	if col != 0 {
		fmt.Printf("\"\n\n")
	}
}

// save the binary of the tune without the header, so it can be loaded into a disassembler or whatevs rofl yolo idk
func saveBinary(filename string) {
	outFile, err := os.OpenFile(filename, os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666)
	if err != nil {
		log.Fatal(err)
	}
	defer outFile.Close()
	_, err2 := outFile.Write(data)
	if err2 != nil {
		log.Fatal(err)
	}
}

// 6502 load instructions will perform N and Z tests while AVR load instructions do not.
// while we can add tst instructions, we can also check the next instruction to see if the flags are overwritten,
// making any tst on the current instruction obsolete.
func nextSetsNZ() bool {
	code := data[pc-loadAddress]
	return getOpcode(code, pc).flags&(FLAG_N|FLAG_Z) == (FLAG_N | FLAG_Z)
}

// fetches the next byte and returns the calculated PC relative address. for branch instructions.
// increment the program counter and mark the code map
func nextByteRelativeAddress() uint16 {
	return uint16(int32(pc&0xffff) + int32(int8(nextByte())))
}

// what is that? velvet?
func byteAt(addr uint16) uint8 {
	return data[addr-loadAddress]
}

// get the next byte and increment the program counter and mark the code map
func nextByte() uint8 {
	v := byteAt(pc)
	codeMap[pc] = true
	pc++
	return v
}

func wordAt(addr uint16) uint16 {
	return (uint16)(data[addr-loadAddress+1])<<8 | (uint16)(data[addr-loadAddress])
}

// get the next word and increment the program counter and mark the code map
func nextWord() uint16 {
	v := wordAt(pc)
	codeMap[pc] = true
	codeMap[pc+1] = true
	pc += 2
	return v
}

// if the address contains a jump instruction, follow all jumps to their final address.
// this helps eliminate jump tables and indirect jumps used by shorter range branch instructions.
func flattenJumpAddress(addr uint16) uint16 {
	var visited = make(map[uint16]bool)
	for byteAt(addr) == JMP_A {
		voidMap[addr] = true   // mark potential elimination of this instruction
		voidMap[addr+1] = true // if not required on other paths
		voidMap[addr+2] = true
		if visited[addr] { // infinite loop detection
			return addr
		}
		visited[addr] = true
		addr = wordAt(addr + 1)
	}
	return addr
}

func transcode(address uint16, stop uint16) {
	pc = address

	carryInverted := false // 6502 carry is inverted for subtractive instructions
	for pc <= stop {
		if printAllLabels || jumpPoints[pc] {
			fmt.Printf("L%04x:  ", pc)
		} else {
			fmt.Printf("        ")
		}

		ins := nextByte()
		opcode := getOpcode(ins, pc-1)
		totalInstructions++
		totalOpcodes[ins] = true
		switch ins {
		case ADC:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; ADC #$%02x\n", REGT, value, value)
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ADC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			accessMap[addr] = true
			carryInverted = false
		case ADC_AX:
			loadIndexed(REGT, REGX, "ADC", "X")
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_AY:
			loadIndexed(REGT, REGY, "ADC", "Y")
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_IX:
			loadZeroIndirectX(REGT, "ADC")
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_IY:
			loadZeroIndirectY(REGT, "ADC")
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; ADC ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			accessMap[addr] = true
			carryInverted = false
		case ADC_ZX:
			loadZeroIndexed(REGT, REGX, "ADC", "X")
			fmt.Printf("        adc %s, %s\n", REGA, REGT)
			checkTest(REGA)
		case AND:
			immediate("andi", REGA, "AND")
		case AND_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; AND $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        and %s, %s\n", REGA, REGT)
			accessMap[addr] = true
		case AND_AX:
			loadIndexed(REGT, REGX, "AND", "X")
			fmt.Printf("        and %s, %s\n", REGA, REGT)
		case AND_AY:
			loadIndexed(REGT, REGY, "AND", "Y")
			fmt.Printf("        and %s, %s\n", REGA, REGT)
		case AND_IX:
			loadZeroIndirectX(REGT, "AND")
			fmt.Printf("        and %s, %s\n", REGA, REGT)
		case AND_IY:
			loadZeroIndirectY(REGT, "AND")
			fmt.Printf("        and %s, %s\n", REGA, REGT)
		case AND_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; AND ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        and %s, %s\n", REGA, REGT)
		case AND_ZX:
			loadZeroIndexed(REGT, REGX, "AND", "X")
			fmt.Printf("        and %s, %s\n", REGA, REGT)
			checkTest(REGA)
		case ASL:
			fmt.Printf("lsl %s                       ; ASL\n", REGA)
		case ASL_A:
			absoluteUpdate("lsl", "ASL")
		case ASL_AX:
			loadIndexed(REGT, REGX, "ASL", "X")
			fmt.Printf("        lsl %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case ASL_Z:
			zeroPageUpdate("lsl", "ASL")
		case ASL_ZX:
			loadZeroIndexed(REGT, REGX, "ASL", "X")
			fmt.Printf("        lsl %s, %s\n", REGA, REGT)
		case BCC:
			if carryInverted {
				branch("brcs", "BCC")
			} else {
				branch("brcc", "BCC")
			}
		case BCS:
			if carryInverted {
				branch("brcc", "BCS")
			} else {
				branch("brcs", "BCS")
			}
		case BEQ:
			branch("breq", "BEQ")
		case BIT_A, BIT_Z:
			// BIT sets the Z flag as though the value in the address tested were ANDed with the accumulator.
			// The N and V flags are set to match bits 7 and 6 respectively in the value stored at the tested address.
			if ins == BIT_A {
				addr := nextWord()
				fmt.Printf("lds %s, ram+0x%04x           ; BIT $%04x\n", REGT, addr-ramStart, addr)
			} else {
				addr := nextByte()
				fmt.Printf("lds %s, zero+0x%02x           ; BIT ($%02x)\n", REGT, addr, addr)
			}
			fmt.Printf("        mov %s, %s\n", REGU, REGT)
			fmt.Printf("        and %s, %s\n", REGU, REGA) // A and M -> Z
			fmt.Printf("        cln\n")
			fmt.Printf("        clv\n")
			fmt.Printf("        sbrc %s, 7\n", REGT) // M bit 7 -> N
			fmt.Printf("        sen\n")
			fmt.Printf("        sbrc %s, 6\n", REGT) // M bit 6 -> V
			fmt.Printf("        sev\n")
		case BMI:
			branch("brmi", "BMI")
		case BNE:
			branch("brne", "BNE")
		case BPL:
			branch("brpl", "BPL")
		case BVC:
			branch("brvc", "BVC")
		case BVS:
			branch("brvs", "BVS")
		case CLC:
			fmt.Printf("clc                           ; CLC\n")
			carryInverted = false
		case CLV:
			fmt.Printf("clv                           ; CLV\n")
		case CMP:
			immediate("cpi", REGA, "CMP")
			carryInverted = true
		case CMP_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CMP $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			accessMap[addr] = true
			carryInverted = true
		case CMP_AX:
			loadIndexed(REGT, REGX, "CMP", "X")
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			carryInverted = true
		case CMP_AY:
			loadIndexed(REGT, REGY, "CMP", "Y")
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			carryInverted = true
		case CMP_IX:
			loadZeroIndirectX(REGT, "CMP")
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			carryInverted = false
		case CMP_IY:
			loadZeroIndirectY(REGT, "CMP")
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			carryInverted = false
		case CMP_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; CMP ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			accessMap[addr] = true
			carryInverted = true
		case CMP_ZX:
			loadZeroIndexed(REGT, REGX, "CMP", "X")
			fmt.Printf("        cp %s, %s\n", REGA, REGT)
			carryInverted = true
		case CPX:
			immediate("cpi", REGX, "CPX")
			carryInverted = true
		case CPX_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CPX $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        cp %s, %s\n", REGX, REGT)
			accessMap[addr] = true
			carryInverted = true
		case CPX_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; CPX ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        cp %s, %s\n", REGX, REGT)
			accessMap[addr] = true
			carryInverted = true
		case CPY:
			immediate("cpi", REGY, "CPY")
			carryInverted = true
		case CPY_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CPY $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        cp %s, %s\n", REGY, REGT)
			accessMap[addr] = true
			carryInverted = true
		case CPY_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; CPY ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        cp %s, %s\n", REGY, REGT)
			accessMap[addr] = true
			carryInverted = true
		case DEC_A:
			if motr && pc-1 == 0x83b6 {
				addr := nextWord()
				// DEC at $83b6 is known to be updated to INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("lds %s, ram+0x%04x           ; DEC $%04x (SELF MODIFYING)\n", REGT, addr-ramStart, addr)
				fmt.Printf("        lds %s, zero+0x%02x\n", REGU, 0)
				fmt.Printf("        cpi %s, 0x%02x\n", REGU, DEC_A)
				fmt.Printf("        breq 1f\n")
				fmt.Printf("        inc %s\n", REGT)
				fmt.Printf("        sbrc %s, 0\n", REGZ)
				fmt.Printf("1:      dec %s\n", REGT)
				fmt.Printf("        sts ram+0x%04x, %s\n", addr-ramStart, REGT)
				accessMap[addr] = true
			} else {
				absoluteUpdate("dec", "DEC")
			}
		case DEC_AX:
			loadIndexed(REGT, REGX, "DEC", "X")
			fmt.Printf("        dec %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case DEC_Z:
			zeroPageUpdate("dec", "DEC")
		case DEC_ZX:
			loadZeroIndexed(REGT, REGX, "DEC", "X")
			fmt.Printf("        dec %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case DEX:
			fmt.Printf("dec %s                       ; DEX\n", REGX)
		case DEY:
			fmt.Printf("dec %s                       ; DEY\n", REGY)
		case EOR:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; EOR #$%02x\n", REGT, value, value)
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; EOR $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
			accessMap[addr] = true
		case EOR_AX:
			loadIndexed(REGT, REGX, "EOR", "X")
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_AY:
			loadIndexed(REGT, REGY, "EOR", "Y")
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_IX:
			loadZeroIndirectX(REGT, "EOR")
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_IY:
			loadZeroIndirectY(REGT, "EOR")
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; EOR ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case EOR_ZX:
			loadZeroIndexed(REGT, REGX, "EOR", "X")
			fmt.Printf("        eor %s, %s\n", REGA, REGT)
		case INC_A:
			absoluteUpdate("inc", "INC")
		case INC_AX:
			loadIndexed(REGT, REGX, "INC", "X")
			fmt.Printf("        inc %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case INC_Z:
			zeroPageUpdate("inc", "INC")
		case INC_ZX:
			loadZeroIndexed(REGT, REGX, "INC", "X")
			fmt.Printf("        inc %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case INX:
			fmt.Printf("inc %s                       ; INX\n", REGX)
		case INY:
			fmt.Printf("inc %s                       ; INY\n", REGY)
		case JMP_A:
			addr := flattenJumpAddress(nextWord())
			fmt.Printf("jmp L%04x                     ; JMP $%04x\n", addr, addr)
		case JSR_A:
			addr := flattenJumpAddress(nextWord())
			fmt.Printf("call L%04x                    ; JSR $%04x\n", addr, addr)
		case LDA:
			immediate("ldi", REGA, "LDA")
			checkTest(REGA)
		case LDA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDA $%04x\n", REGA, addr-ramStart, addr)
			checkTest(REGA)
			accessMap[addr] = true
		case LDA_AX:
			loadIndexed(REGA, REGX, "LDA", "X")
			checkTest(REGA)
		case LDA_AY:
			loadIndexed(REGA, REGY, "LDA", "Y")
			checkTest(REGA)
		case LDA_IX:
			loadZeroIndirectX(REGA, "LDA")
			checkTest(REGA)
		case LDA_IY:
			loadZeroIndirectY(REGA, "LDA")
			checkTest(REGA)
		case LDA_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x           ; LDA ($%02x)\n", REGA, addr, addr)
			checkTest(REGA)
			accessMap[addr] = true
		case LDA_ZX:
			loadZeroIndexed(REGA, REGX, "LDA", "X")
			checkTest(REGA)
		case LDX:
			immediate("ldi", REGX, "LDX")
			checkTest(REGX)
		case LDX_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDX $%04x\n", REGX, addr-ramStart, addr)
			checkTest(REGX)
			accessMap[addr] = true
		case LDX_AY:
			loadIndexed(REGX, REGY, "LDX", "Y")
			checkTest(REGX)
		case LDX_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x           ; LDX ($%02x)\n", REGX, addr, addr)
			checkTest(REGX)
			accessMap[addr] = true
		case LDX_ZY:
			loadZeroIndexed(REGX, REGY, "LDX", "Y")
		case LDY:
			immediate("ldi", REGY, "LDY")
			checkTest(REGY)
		case LDY_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDY $%04x\n", REGY, addr-ramStart, addr)
			checkTest(REGY)
			accessMap[addr] = true
		case LDY_AX:
			loadIndexed(REGY, REGX, "LDY", "X")
			checkTest(REGY)
		case LDY_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x           ; LDY ($%02x)\n", REGY, addr, addr)
			checkTest(REGY)
			accessMap[addr] = true
		case LDY_ZX:
			loadZeroIndexed(REGY, REGX, "LDY", "X")
		case LSR:
			fmt.Printf("lsr %s                       ; LSR\n", REGA)
		case LSR_A:
			absoluteUpdate("lsr", "LSR")
		case LSR_AX:
			loadIndexed(REGT, REGX, "LSR", "X")
			fmt.Printf("        lsr %s, %s\n", REGA, REGT)
		case LSR_Z:
			zeroPageUpdate("lsr", "LSR")
		case LSR_ZX:
			loadZeroIndexed(REGT, REGX, "LSR", "X")
			fmt.Printf("        lsr %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case NOP, BRK, SEI, CLI:
			// 6502 NOPs were either for padding or timing, neither of which apply here
			fmt.Printf("                              ; %s\n", opcode.ins)
			voidMap[pc-1] = true
		case ORA:
			immediate("ori", REGA, "ORA")
		case ORA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ORA $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        or %s, %s\n", REGA, REGT)
			accessMap[addr] = true
		case ORA_AX:
			loadIndexed(REGT, REGX, "ORA", "X")
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case ORA_AY:
			loadIndexed(REGT, REGY, "ORA", "Y")
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case ORA_IX:
			loadZeroIndirectX(REGT, "ORA")
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case ORA_IY:
			loadZeroIndirectY(REGT, "ORA")
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case ORA_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; ORA ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case ORA_ZX:
			loadZeroIndexed(REGT, REGX, "ORA", "X")
			fmt.Printf("        or %s, %s\n", REGA, REGT)
		case PHA:
			fmt.Printf("push %s                      ; PHA\n", REGA)
		case PHP:
			fmt.Printf("in %s, 0x3f                  ; PHP\n", REGS)
			fmt.Printf("        push %s\n", REGS)
		case PLA:
			fmt.Printf("pop %s                       ; PLA\n", REGA)
			checkTest(REGA)
		case PLP:
			fmt.Printf("pop %s                       ; PLP\n", REGS)
			fmt.Printf("        out 0x3f, %s\n", REGS)
		case ROL:
			fmt.Printf("rol %s                       ; ROL\n", REGA)
		case ROL_A:
			absoluteUpdate("rol", "ROL")
		case ROL_AX:
			loadIndexed(REGT, REGX, "ROL", "X")
			fmt.Printf("        rol %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case ROL_Z:
			zeroPageUpdate("rol", "ROL")
		case ROL_ZX:
			loadZeroIndexed(REGT, REGX, "ROL", "X")
			fmt.Printf("        rol %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case ROR:
			fmt.Printf("ror %s                       ; ROR\n", REGA)
		case ROR_A:
			absoluteUpdate("ror", "ROR")
		case ROR_AX:
			loadIndexed(REGT, REGX, "ROR", "X")
			fmt.Printf("        ror %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case ROR_Z:
			zeroPageUpdate("ror", "ROR")
		case ROR_ZX:
			loadZeroIndexed(REGT, REGX, "ROR", "X")
			fmt.Printf("        ror %s\n", REGT)
			fmt.Printf("        st X, %s\n", REGT)
		case RTI, RTS:
			fmt.Printf("ret                           ; %s\n", opcode.ins)
		case SBC:
			value := nextByte()
			fmt.Printf("sbci %s, 0x%02x                ; SBC #$%02x\n", REGA, value, value)
			carryInverted = true
		case SBC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; SBC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
			accessMap[addr] = true
			carryInverted = true
		case SBC_AX:
			loadIndexed(REGT, REGX, "SBC", "X")
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case SBC_AY:
			loadIndexed(REGT, REGY, "SBC", "Y")
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case SBC_IX:
			loadZeroIndirectX(REGT, "SBC")
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case SBC_IY:
			loadZeroIndirectY(REGT, "SBC")
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case SBC_Z:
			addr := nextByte()
			fmt.Printf("lds %s, zero+0x%02x             ; SBC ($%02x)\n", REGT, addr, addr)
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
		case SBC_ZX:
			loadZeroIndexed(REGT, REGX, "SBC", "X")
			fmt.Printf("        sbc %s, %s\n", REGA, REGT)
		case SEC:
			fmt.Printf("sec                           ; SEC\n")
			carryInverted = false
		case STA_A:
			if byteAt(pc+1) == 0xd4 {
				addr := nextWord()
				fmt.Printf("mov %s, %s                  ; STA $%04x (SID)\n", REGT, REGA, addr)
				fmt.Printf("        ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("        call sid_write\n")
			} else {
				addr := nextWord()
				fmt.Printf("sts ram+0x%04x, %s           ; STA $%04x\n", addr-ramStart, REGA, addr)
				checkSelfMod(addr)
				accessMap[addr] = true
			}
		case STA_AX:
			storeIndexed(REGA, REGX, "STA", "X")
		case STA_AY:
			storeIndexed(REGA, REGY, "STA", "Y")
		case STA_IX:
			storeZeroIndirectX(REGA, "STA")
		case STA_IY:
			storeZeroIndirectY(REGA, "STA")
		case STA_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STA $%02x\n", addr, REGA, addr)
			accessMap[addr] = true
		case STA_ZX:
			storeZeroIndexed(REGA, REGX, "STA", "X")
		case STX_A:
			if byteAt(pc+1) == 0xd4 {
				addr := nextWord()
				fmt.Printf("mov %s, %s                  ; STX $%04x (SID)\n", REGT, REGX, addr)
				fmt.Printf("        ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("        call sid_write\n")
			} else {
				addr := nextWord()
				fmt.Printf("sts ram+0x%04x, %s           ; STX $%04x\n", addr-ramStart, REGX, addr)
				checkSelfMod(addr)
				accessMap[addr] = true
			}
		case STX_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STX $%02x\n", addr, REGX, addr)
			accessMap[addr] = true
		case STX_ZY:
			storeZeroIndexed(REGX, REGY, "STX", "Y")
		case STY_A:
			if byteAt(pc+1) == 0xd4 {
				addr := nextWord()
				fmt.Printf("mov %s, %s                  ; STY $%04x (SID)\n", REGT, REGY, addr)
				fmt.Printf("        ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("        call sid_write\n")
			} else if motr && wordAt(pc) == 0x83b6 {
				addr := nextWord()
				// STY $83b6 is known to update INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("sts zero+0x%02x, %s            ; STY $%04x (SELF MODIFYING)\n", 0, REGY, addr)
			} else {
				addr := nextWord()
				fmt.Printf("sts ram+0x%04x, %s           ; STY $%04x\n", addr-ramStart, REGY, addr)
				checkSelfMod(addr)
				accessMap[addr] = true
			}
		case STY_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STY $%02x\n", addr, REGY, addr)
			accessMap[addr] = true
		case STY_ZX:
			storeZeroIndexed(REGY, REGX, "STY", "X")
		case TAX:
			fmt.Printf("mov %s, %s                  ; TAX\n", REGX, REGA)
			checkTest(REGX)
		case TAY:
			fmt.Printf("mov %s, %s                  ; TAY\n", REGY, REGA)
			checkTest(REGY)
		case TXA:
			fmt.Printf("mov %s, %s                  ; TXA\n", REGA, REGX)
			checkTest(REGA)
		case TYA:
			fmt.Printf("mov %s, %s                  ; TYA\n", REGA, REGY)
			checkTest(REGA)
		default:
			log.Fatalf("UNMAPPED OPCODE at %04x: %v\n", pc-1, opcode)
		}
	}
	fmt.Printf("\n")
}

func checkTest(reg string) {
	if !nextSetsNZ() {
		fmt.Printf("        tst %s\n", reg)
	}
}

func branch(branchIns string, ins string) {
	addr := flattenJumpAddress(nextByteRelativeAddress())
	// branching too far may require a longer range jmp.
	// the range of 16 isn't very scientific as our instructions are variable length.
	if addr > pc+16 || addr < pc-16 {
		fmt.Printf("%s 1f                       ; %s $%04x\n", branchIns, ins, addr)
		fmt.Printf("        sbrc %s, 0\n", REGZ) // branch not taken so always skip next instruction (bit 0 in REGZ is clear)
		fmt.Printf("1:      jmp L%04x\n", addr)
	} else {
		fmt.Printf("%s L%04x                    ; %s $%04x\n", branchIns, addr, ins, addr)
	}
}

func indexed(indexReg string, ins string, insIndex string) {
	addr := nextWord()
	fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; %s $%04x,%s\n", addr-ramStart, ins, addr, insIndex)
	fmt.Printf("        ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
	fmt.Printf("        in %s, 0x3f\n", REGS)
	fmt.Printf("        add r26,%s\n", indexReg)
	fmt.Printf("        adc r27,%s\n", REGZ)
	fmt.Printf("        out 0x3f, %s\n", REGS)
	accessMap[addr] = true
}

func loadIndexed(reg string, indexReg string, ins string, insIndex string) {
	indexed(indexReg, ins, insIndex)
	fmt.Printf("        ld %s, X\n", reg)
}

func storeIndexed(reg string, indexReg string, ins string, insIndex string) {
	if byteAt(pc+1) == 0xd4 {
		addr := nextWord()
		fmt.Printf("mov %s, %s                  ; %s $%04x,%s (SID)\n", REGT, reg, ins, addr, insIndex)
		fmt.Printf("        ldi %s, 0x%02x\n", REGU, addr&0xff)
		fmt.Printf("        in %s, 0x3f\n", REGS)
		fmt.Printf("        add %s, %s\n", REGU, indexReg)
		fmt.Printf("        out 0x3f, %s\n", REGS)
		fmt.Printf("        call sid_write\n")
		return
	}
	indexed(indexReg, ins, insIndex)
	fmt.Printf("        st X, %s\n", reg)
}

func zeroIndexed(indexReg string, ins string, insIndex string) {
	addr := nextByte()
	fmt.Printf("ldi r26,lo8(zero+0x%02x)        ; %s $%02x,%s\n", addr, ins, addr, insIndex)
	fmt.Printf("        ldi r27,hi8(zero+0x%02x)\n", addr)
	fmt.Printf("        in %s, 0x3f\n", REGS)
	fmt.Printf("        add r26,%s\n", indexReg)
	fmt.Printf("        adc r27,%s\n", REGZ)
	fmt.Printf("        out 0x3f, %s\n", REGS)
	accessMap[addr] = true
}

func storeZeroIndexed(reg string, indexReg string, ins string, insIndex string) {
	zeroIndexed(indexReg, ins, insIndex)
	fmt.Printf("        st X, %s\n", reg)
}

func loadZeroIndexed(reg string, indexReg string, ins string, insIndex string) {
	zeroIndexed(indexReg, ins, insIndex)
	fmt.Printf("        ld %s, X\n", reg)
}

func zeroIndirectX(ins string) {
	addr := nextByte()
	fmt.Printf("ldi r28,0x%02x                  ; %s ($%02x,X)\n", addr, ins, addr)
	fmt.Printf("        mov r29,%s\n", REGZ)
	fmt.Printf("        in %s, 0x3f\n", REGS)
	fmt.Printf("        add r28,%s\n", REGX)      // add X index with zero page wrap
	fmt.Printf("        subi r28,lo8(-(zero))\n") // add zero page offset
	fmt.Printf("        sbci r29,hi8(-(zero))\n")
	fmt.Printf("        ld r26, Y+\n") // get indirect pointer to X
	fmt.Printf("        ld r27, Y\n")
	fmt.Printf("        subi r26,lo8(-(ram-0x%04x))\n", ramStart) // add ram offset
	fmt.Printf("        sbci r27,hi8(-(ram-0x%04x))\n", ramStart)
	fmt.Printf("        out 0x3f, %s\n", REGS)
	// indexed in zero page, so we might need the whole page
	for index := int(addr); index < 0x100; index++ {
		accessMap[index] = true
	}
}

func loadZeroIndirectX(reg string, ins string) {
	zeroIndirectX(ins)
	fmt.Printf("        ld %s, X\n", reg)
}

func storeZeroIndirectX(reg string, ins string) {
	zeroIndirectX(ins)
	fmt.Printf("        st X, %s\n", reg)
}

func zeroIndirectY(ins string) {
	addr := nextByte()
	fmt.Printf("lds r26,zero+0x%02x             ; %s ($%02x),Y\n", addr, ins, addr)
	fmt.Printf("        lds r27,zero+0x%02x+1\n", addr)
	fmt.Printf("        in %s, 0x3f\n", REGS)
	fmt.Printf("        subi r26,lo8(-(ram-0x%04x))\n", ramStart) // add ram offset
	fmt.Printf("        sbci r27,hi8(-(ram-0x%04x))\n", ramStart)
	fmt.Printf("        add r26,%s\n", REGY) // add Y index
	fmt.Printf("        adc r27,%s\n", REGZ)
	fmt.Printf("        out 0x3f, %s\n", REGS)
	accessMap[addr] = true
	accessMap[addr+1] = true
}

func loadZeroIndirectY(reg string, ins string) {
	zeroIndirectY(ins)
	fmt.Printf("        ld %s, X\n", reg)
}

func storeZeroIndirectY(reg string, ins string) {
	zeroIndirectY(ins)
	fmt.Printf("        st X, %s\n", reg)
}

func absoluteUpdate(asm string, code string) {
	addr := nextWord()
	fmt.Printf("lds %s, ram+0x%04x           ; %s $%04x\n", REGT, addr-ramStart, code, addr)
	fmt.Printf("        %s %s\n", asm, REGT)
	fmt.Printf("        sts ram+0x%04x, %s\n", addr-ramStart, REGT)
	accessMap[addr] = true
}

func zeroPageUpdate(asm string, code string) {
	addr := nextByte()
	fmt.Printf("lds %s, zero+0x%02x             ; %s ($%02x)\n", REGT, addr, code, addr)
	fmt.Printf("        %s %s\n", asm, REGT)
	fmt.Printf("        sts zero+0x%02x, %s\n", addr, REGT)
	accessMap[addr] = true
}

func immediate(immediateIns string, reg string, ins string) {
	value := nextByte()
	fmt.Printf("%-4s %s, 0x%02x                ; %s #$%02x\n", immediateIns, reg, value, ins, value)
}

func checkSelfMod(addr uint16) {
	if !allowSelfModifying && codeMap[addr] {
		log.Fatalf("SELF-MODIFYING CODE TO $%04x - PC $%04x\n", addr, pc)
	}
}

// follows the code path, taking branches and jumps, marking memory which contains code and their jump points
func searchCodeBlocks(start uint16) {
	start = flattenJumpAddress(start)
	jumpPoints[start] = true // may have been visited but may not have been a jump point
	if codeMap[start] {      // already been down this road
		return
	}
	savePc := pc
	pc = start
	for {
		ins := nextByte()
		opcode := getOpcode(ins, pc-1)
		switch ins {
		case JMP_A:
			searchCodeBlocks(nextWord())
			pc = savePc
			return
		case JSR_A:
			searchCodeBlocks(nextWord())
		case BCS, BCC, BVS, BVC, BPL, BMI, BNE, BEQ:
			searchCodeBlocks(nextByteRelativeAddress())
		case RTS:
			pc = savePc
			return
		case JMP_I, TSX, TXS, SED, CLD:
			log.Fatalf("UNSUPPORTED INSTRUCTION at $%04x %v\n", pc-1, opcode)
		default:
			for c := uint8(1); c < opcode.bytes; c++ {
				nextByte()
			}
		}
	}
}

func printCodeBlocks() {
	change := codeMap[0]
	for index := 0; index < 0x10000; index++ {
		code := codeMap[index]
		if code != change {
			if code {
				fmt.Printf(" $%04x-", index)
			} else {
				fmt.Printf("$%04x", index-1)
			}
			change = code
		}
	}
	fmt.Println()
}

func transcodeBlocks() {
	change := codeMap[0]
	var start uint16
	for index := 0; index < 0x10000; index++ {
		code := codeMap[index]
		if code != change {
			if code {
				start = uint16(index)
			} else {
				transcode(start, uint16(index-1))
			}
			change = code
		}
	}
	for index := 0; index < 0x100; index++ {
		if accessMap[index] {
			zeroPageLen = uint16(index) + 1
		}
	}
}

func saveMemoryMap(path string) {
	rgba := image.NewRGBA(image.Rect(0, 0, 256, 256))
	for c := 0; c < 0x10000; c++ {
		i := c * 4
		rgba.Pix[i+3] = 0xff // alpha channel

		if c&0x0f == 0 || c&0xf00 == 0 {
			rgba.Pix[i+2] = 0x60 // draw grid
		}
		if codeMap[c] { // confirmed code path
			rgba.Pix[i+0] = 0xa0
			rgba.Pix[i+2] = 0
		} else if voidMap[c] { // eliminated code
			rgba.Pix[i+0] = 0x20
			rgba.Pix[i+1] = 0x20
			rgba.Pix[i+2] = 0
		} else if c >= int(loadAddress) && c <= int(loadAddress)+len(data) {
			rgba.Pix[i+1] = 0x60 // assume data
		}
		if accessMap[c] {
			rgba.Pix[i+1] = 0xd0
		}
		if jumpPoints[uint16(c)] {
			rgba.Pix[i+0] = 0xff
			rgba.Pix[i+1] = 0xff
			rgba.Pix[i+2] = 0xff
		}
	}

	outputFile, err := os.Create(path)
	if err != nil {
		return
	}
	png.Encode(outputFile, rgba)
	outputFile.Close()
}
