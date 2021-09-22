
package main

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

const ADC_A = 0x6D
const ADC_Y = 0x79
const ADC = 0x69
const AND = 0x29
const AND_A = 0x2d
const ASL = 0x0A
const BCC = 0x90
const BCS = 0xB0
const BEQ = 0xF0
const BIT = 0x2C
const BMI = 0x30
const BNE = 0xD0
const BPL = 0x10
const BRK = 0x00
const BVC = 0x50
const BVS = 0x70
const CLC = 0x18
const CLV = 0xB8
const CMP = 0xC9
const CMP_A = 0xCD
const CMP_X = 0xDD
const CPX = 0xE0
const CPY = 0xC0
const DEC_A = 0xce
const DEC_X = 0xde
const DEX = 0xCA
const DEY = 0x88
const EOR = 0x49
const INC_A = 0xee
const INC_X = 0xfe
const INX = 0xE8
const INY = 0xC8
const JMP = 0x4C
const JSR = 0x20
const LDA = 0xA9
const LDA_Y = 0xB9
const LDA_A = 0xAD
const LDA_IY = 0xB1
const LDA_X = 0xbd
const LDX = 0xA2
const LDX_A = 0xAE
const LDY = 0xA0
const LDY_A = 0xAC
const LDY_X = 0xBC
const LSR = 0x4a
const NOP = 0xea
const ORA = 0x09
const ORA_A = 0x0d
const PHA = 0x48
const PLA = 0x68
const RTS = 0x60
const ROR_A = 0x6e
const SEC = 0x38
const SBC_A = 0xed
const SBC = 0xe9
const SBC_Y = 0xf9
const STA = 0x8D
const STX = 0x8E
const STY = 0x8C
const STA_X = 0x9D
const STA_Y = 0x99
const STA_Z = 0x85
const TAX = 0xAA
const TAY = 0xA8
const TYA = 0x98
const TXA = 0x8a

type Header struct {
	MagicID uint32 		   // 0
	Version uint16		   // 4
	DataOffset uint16	   // 6
	LoadAddress uint16     // 8
	InitAddress uint16     // A
	PlayAddress uint16     // c
	Songs uint16		   // e
	StartSong uint16	   // 10
	Speed uint32		   // 12
	Name [32]byte	       // 16
	Author [32]byte        // 36
	Released [32]byte      // 56
	Flags uint16		   // 76
	StartPage uint8  	   // 78
	PageLength uint8       // 79
	SecondSIDAddress uint8 // 7a
	ThirdSIDAddress uint8  // 7b
	FirstData uint16       // 7c
}

const REGA = "r16" // 6502 Accumulator
const REGX = "r17" // 6502 X
const REGY = "r18" // 6502 Y
const REGZ = "r19" // Zero
const REGT = "r20" // Temp
const REGU = "r21" // Another Temp
const REGS = "r22" // AVR status register storage. for protecting the carry bit while we use it for pointer calculations.
const REGW = "r23" // One

var header = Header{}
var data []byte
var pc uint16			// 6502 program counter
var ramStart uint16		// offset at which ram block starts
var ramLen uint16		// length of ram block

func main() {
	path := "Monty_on_the_Run.sid"
	file, _ := os.Open(path)
	defer file.Close()

	binary.Read(file, binary.BigEndian, &header.MagicID)
	binary.Read(file, binary.BigEndian, &header.Version)
	binary.Read(file, binary.BigEndian, &header.DataOffset)
	binary.Read(file, binary.BigEndian, &header.LoadAddress)
	binary.Read(file, binary.BigEndian, &header.InitAddress)
	binary.Read(file, binary.BigEndian, &header.PlayAddress)
	binary.Read(file, binary.BigEndian, &header.Songs)
	binary.Read(file, binary.BigEndian, &header.StartSong)
	binary.Read(file, binary.BigEndian, &header.Speed)
	binary.Read(file, binary.BigEndian, &header.Name)
	binary.Read(file, binary.BigEndian, &header.Author)
	binary.Read(file, binary.BigEndian, &header.Released)
	binary.Read(file, binary.BigEndian, &header.Flags)
	binary.Read(file, binary.BigEndian, &header.StartPage)
	binary.Read(file, binary.BigEndian, &header.PageLength)
	binary.Read(file, binary.BigEndian, &header.SecondSIDAddress)
	binary.Read(file, binary.BigEndian, &header.ThirdSIDAddress)

	// if load address is zero, the load address is found at the start of the data block
	if header.LoadAddress == 0 {
		binary.Read(file, binary.LittleEndian, &header.FirstData)
		header.LoadAddress = header.FirstData
	}

	readData, err := ioutil.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}
	data = readData

	// MOTR specific config
	ramStart = 0x8400
	ramLen = uint16(len(data)) - (ramStart - header.LoadAddress)

	fmt.Printf("\n\n    .section .text\n\n")

	fmt.Printf(";    DataOffset: $%x\n", header.DataOffset)
	fmt.Printf(";   LoadAddress: $%x\n", header.LoadAddress)
	fmt.Printf(";   InitAddress: $%x\n", header.InitAddress)
	fmt.Printf(";   PlayAddress: $%x\n", header.PlayAddress)
	fmt.Printf(";     FirstData: $%x\n", header.FirstData)
	fmt.Printf(";         Songs: %d\n", header.Songs)
	fmt.Printf(";     StartSong: %d\n", header.StartSong)
	fmt.Printf(";          Name: %s\n", string(header.Name[:bytes.Index(header.Name[:], []byte{0})]))
	fmt.Printf(";        Author: %s\n", string(header.Author[:bytes.Index(header.Author[:], []byte{0})]))
	fmt.Printf(";      Released: %s\n", string(header.Released[:bytes.Index(header.Released[:], []byte{0})]))
	fmt.Printf(";  Total Binary: %d bytes\n", len(data))
	fmt.Printf(";           RAM: %d bytes\n\n", ramLen)

	fmt.Printf(".global sid_init\n")
	fmt.Printf("    .type sid_init, @function\n")
	fmt.Printf("sid_init:\n")
	fmt.Printf("    mov %s, r24\n", REGA) // tune
	fmt.Printf("    clr %s\n", REGX)
	fmt.Printf("    clr %s\n", REGY)
	fmt.Printf("    clr %s\n", REGZ)
	fmt.Printf("    ldi %s, 0x01\n", REGW)
	fmt.Printf("    rjmp L%04x\n\n", header.InitAddress)

	fmt.Printf(".global sid_play\n")
	fmt.Printf("    .type sid_play, @function\n")
	fmt.Printf("sid_play:\n")
	fmt.Printf("    clr %s\n", REGA)
	fmt.Printf("    clr %s\n", REGX)
	fmt.Printf("    clr %s\n", REGY)
	fmt.Printf("    clr %s\n", REGZ)
	fmt.Printf("    ldi %s, 0x01\n", REGW)
	fmt.Printf("    rjmp L%04x\n\n", header.PlayAddress)

	fmt.Printf("sid_write:\n")
	fmt.Printf("    out 0x5,%s\n", REGT)     // PORTB 7 segment LED
	fmt.Printf("    out 0x8,%s\n", REGT)     // PORTC = val
	fmt.Printf("    andi %s, 0x1f\n", REGU)
	fmt.Printf("    out 0x2,%s\n", REGU)     // PORTA = reg | sidSelect; (0 = both)
	for nop := 0; nop < 16; nop++ {
		fmt.Printf("    nop\n")
	}
	fmt.Printf("    ori %s,lo8(-64)\n", REGU) // PORTA = reg | SID_CS_CLEAR;
	fmt.Printf("    out 0x2, %s\n", REGU)
	for nop := 0; nop < 16; nop++ {
		fmt.Printf("    nop\n")
	}
	fmt.Printf("    ret\n\n")

	transcode(header.InitAddress, 0x8400)
	transcode(0x8506, 0x8566)
	transcode(0x9554, 0x95B6)

	fmt.Printf("\n")
	fmt.Printf(".global	zero\n")
	fmt.Printf("    .section .bss\n")
	fmt.Printf("    .type zero, @object\n")
	fmt.Printf("    .size zero, %d\n", 6) // would be 256 but we know MOTR only uses $02-$05
	fmt.Printf("zero:\n")
	fmt.Printf("    .zero %d\n", 6)

	fmt.Printf("\n")
	fmt.Printf(".global	ram\n")
	fmt.Printf("    .data\n")
	fmt.Printf("    .type ram, @object\n")
	fmt.Printf("    .size ram, %d\n", ramLen)
	fmt.Printf("ram:\n")

	writeBinary()

	fmt.Printf("\n\n")
	fmt.Printf(".global __do_copy_data\n")
	fmt.Printf(".global __do_clear_bss\n")
	fmt.Printf("\n\n    .end\n\n")
}

// 6502 load instructions will perform N and Z tests while AVR load instructions do not.
// while we can add tst instructions, we can also check the next instruction to see if the flags are overwritten,
// making any tst on the current instruction obsolete.
func nextSetsNZ() bool {
	v := data[pc-header.LoadAddress]
	return v == LDA || v == LDA_A || v == LDA_Y || v == LDA_IY || v == LDA_X || v == LDX || v == LDX_A ||
		v == LDY_X  || v == TAX || v == TAY || v == TXA || v == TYA || v == ADC || v == ADC_A || v == ADC_Y ||
		v == AND || v == AND_A || v == ORA || v == ORA_A || v == ASL || v == ROR_A || v == LSR ||
		v == SBC || v == SBC_A || v == SBC_Y
}

// fetches the the next byte and returns the calculated PC relative address. for branch instructions
func relative8() uint16 {
	return uint16( int32(pc & 0xffff) + int32(int8(nextByte())) )
}

// get the next byte and increment the program counter
func nextByte() uint8 {
	v := data[pc-header.LoadAddress]
	pc++
	return v
}

// get the next word and increment the program counter
func nextWord() uint16 {
	v := (uint16)(data[pc-header.LoadAddress + 1]) << 8 | (uint16)(data[pc-header.LoadAddress])
	pc+=2
	return v
}

func writeBinary() {
	dataOff := int((ramStart - header.LoadAddress)) & 0xffff
	l := int(ramLen) & 0xffff
	col := 0
	for b := 0; b < l; b++ {
		if col == 0 {
			fmt.Printf("    .ascii \"")
		}
		col++
		fmt.Printf("\\%03o", data[dataOff+b])
		if col == 24 {
			fmt.Printf("\"\n")
			col = 0
		}
	}
	if col != 0 {
		fmt.Printf("\"\n")
	}
}

func saveDataBlock() {
	outFile, err := os.OpenFile("output.bin", os.O_WRONLY|os.O_TRUNC|os.O_CREATE, 0666)
	if err != nil {
		log.Fatal(err)
	}
	defer outFile.Close()
	_, err2 := outFile.Write(data)
	if err2 != nil {
		log.Fatal(err)
	}
}

func transcode(address uint16, stop uint16) {
	pc = address

	fmt.Printf("\n          ; transcode %04x - %04x\n\n", address, stop)
	for {
		if pc == stop {
			return
		}
		fmt.Printf("L%04x:    ", pc)

		ins := nextByte()
		switch ins {
		case JMP:
			addr := nextWord()
			if addr < header.LoadAddress {
				fmt.Printf(";") // disable illegal jump
			}
			fmt.Printf("rjmp L%04x                    ; JMP $%04x\n", addr, addr)
		case JSR:
			addr := nextWord()
			fmt.Printf("rcall L%04x                   ; JSR $%04x\n", addr, addr)
		case STA:
			addr := nextWord()
			if addr&0xff00 == 0xd400 {
				fmt.Printf("mov %s, %s                  ; STA $%04x (SID)\n", REGT, REGA, addr)
				fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("          rcall sid_write\n")
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STA $%04x\n", addr-ramStart, REGA, addr)
			}
		case STA_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STA $%02x\n", addr, REGA, addr)
		case STX:
			addr := nextWord()
			if addr&0xff00 == 0xd400 {
				fmt.Printf("mov %s, %s                  ; STX $%04x (SID)\n", REGT, REGX, addr)
				fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("          rcall sid_write\n")
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STX $%04x\n", addr-ramStart, REGX, addr)
			}
		case STY:
			addr := nextWord()
			if addr == 0x83b6 {
				// STY $83b6 is known to update INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("sts zero+0x%02x, %s            ; STY $%04x (SELF MODIFYING)\n", 0, REGY, addr)
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STY $%04x\n", addr-ramStart, REGY, addr)
			}
		case AND:
			value := nextByte()
			fmt.Printf("andi %s, 0x%02x                ; AND #$%02x\n", REGA, value, value)
		case ORA:
			value := nextByte()
			fmt.Printf("ori %s, 0x%02x                 ; ORA #$%02x\n", REGA, value, value)
		case EOR:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; EOR #$%02x\n", REGT, value, value)
			fmt.Printf("          eor %s, %s\n", REGA, REGT)
		case CMP:
			value := nextByte()
			fmt.Printf("cpi %s, 0x%02x                 ; CMP #$%02x\n", REGA, value, value)
			fmt.Printf("          in %s, 0x3f\n", REGS) // invert carry bit
			fmt.Printf("          eor %s, %s\n", REGS, REGW)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		case CMP_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CMP $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
			fmt.Printf("          in %s, 0x3f\n", REGS) // invert carry bit
			fmt.Printf("          eor %s, %s\n", REGS, REGW)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		case CMP_X:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; CMP $%04x,X\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGX)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGT)
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
			fmt.Printf("          in %s, 0x3f\n", REGS) // invert carry bit
			fmt.Printf("          eor %s, %s\n", REGS, REGW)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		case CPX:
			value := nextByte()
			fmt.Printf("cpi %s, 0x%02x                 ; CPX #$%02x\n", REGX, value, value)
			fmt.Printf("          in %s, 0x3f\n", REGS) // invert carry bit
			fmt.Printf("          eor %s, %s\n", REGS, REGW)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		case CPY:
			value := nextByte()
			fmt.Printf("cpi %s, 0x%02x                 ; CPY #$%02x\n", REGY, value, value)
			fmt.Printf("          in %s, 0x3f\n", REGS) // invert carry bit
			fmt.Printf("          eor %s, %s\n", REGS, REGW)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		case BIT:
			// BIT sets the Z flag as though the value in the address tested were ANDed with the accumulator.
			// The N and V flags are set to match bits 7 and 6 respectively in the value stored at the tested address.
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; BIT $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          mov %s, %s\n", REGU, REGT)
			fmt.Printf("          and %s, %s\n", REGU, REGA) // A and M -> Z
			fmt.Printf("          cln\n")
			fmt.Printf("          clv\n")
			fmt.Printf("          sbrc %s, 7\n", REGT)       // M bit 7 -> N
			fmt.Printf("          sen\n")
			fmt.Printf("          sbrc %s, 6\n", REGT)       // M bit 6 -> V
			fmt.Printf("          sev\n")
		case BCS:
			addr := relative8()
			// this isnt very scientific as our instructions are variable length, but branching too far may require rjmp
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brcs 1f                       ; BCS $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ) // always skip next instruction. bit 0 in REGZ is clear
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brcs L%04x                    ; BCS $%04x\n", addr, addr)
			}
		case BCC:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brcc 1f                       ; BCC $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brcc L%04x                    ; BCS $%04x\n", addr, addr)
			}
		case BVS:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brvs 1f                       ; BVS $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brvs L%04x                    ; BVS $%04x\n", addr, addr)
			}
		case BVC:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brvc 1f                       ; BVC $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brvc L%04x                    ; BVC $%04x\n", addr, addr)
			}
		case BPL:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brpl 1f                       ; BPL $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brpl L%04x                    ; BPL $%04x\n", addr, addr)
			}
		case BMI:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brmi 1f                       ; BMI $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brmi L%04x                    ; BMI $%04x\n", addr, addr)
			}
		case BNE:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("brne 1f                       ; BNE $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("brne L%04x                    ; BNE $%04x\n", addr, addr)
			}
		case BEQ:
			addr := relative8()
			if addr > pc+16 || addr < pc-16 {
				fmt.Printf("breq 1f                       ; BEQ $%04x\n", addr)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        rjmp L%04x\n", addr)
			} else {
				fmt.Printf("breq L%04x                    ; BEQ $%04x\n", addr, addr)
			}
		case LDA:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; LDA #$%02x\n", REGA, value, value)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case LDA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDA $%04x\n", REGA, addr-ramStart, addr)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case LDA_X:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; LDA $%04x,X\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGX)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case LDX:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; LDX #$%02x\n", REGX, value, value)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGX)
			}
		case LDY:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; LDY #$%02x\n", REGY, value, value)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGY)
			}
		case LDX_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDX $%04x\n", REGX, addr-ramStart, addr)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGX)
			}
		case LDY_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDY $%04x\n", REGY, addr-ramStart, addr)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGY)
			}
		case LDA_Y:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; LDA $%04x,Y\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGY)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case LDY_X:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; LDY $%04x,X\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGX)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGY)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGY)
			}
		case INC_X:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; INC $%04x,X\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGX)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGT)
			fmt.Printf("          inc %s\n", REGT)
			fmt.Printf("          st X, %s\n", REGT)
		case DEC_X:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; DEC $%04x,X\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGX)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGT)
			fmt.Printf("          dec %s\n", REGT)
			fmt.Printf("          st X, %s\n", REGT)
		case LDA_IY:
			addr := nextByte()
			fmt.Printf("lds r26,zero+0x%02x             ; LDA ($%02x),Y\n", addr, addr)
			fmt.Printf("          lds r27,zero+0x%02x+1\n", addr)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          subi r26,lo8(0x%04x)\n", ramStart)   // subtract data start
			fmt.Printf("          sbci r27,hi8(0x%04x)\n", ramStart)
			fmt.Printf("          subi r26,lo8(-(ram))\n")           // add ram offset
			fmt.Printf("          sbci r27,hi8(-(ram))\n")
			fmt.Printf("          add r26,%s\n", REGY)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case STA_X:
			addr := nextWord()
			if addr & 0xff00 == 0xd400 {
				fmt.Printf("mov %s, %s                  ; STA $%04x,X (SID)\n", REGT, REGA, addr)
				fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("          in %s, 0x3f\n", REGS)
				fmt.Printf("          add %s, %s\n", REGU, REGX)
				fmt.Printf("          out 0x3f, %s\n", REGS)
				fmt.Printf("          rcall sid_write\n")
			} else {
				fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; STA $%04x,X\n", addr-ramStart, addr)
				fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
				fmt.Printf("          in %s, 0x3f\n", REGS)
				fmt.Printf("          add r26,%s\n", REGX)
				fmt.Printf("          adc r27,%s\n", REGZ)
				fmt.Printf("          out 0x3f, %s\n", REGS)
				fmt.Printf("          st X, %s\n", REGA)
			}
		case STA_Y:
			addr := nextWord()
			if addr & 0xff00 == 0xd400 {
				fmt.Printf("mov %s, %s                  ; STA $%04x,Y (SID)\n", REGT, REGA, addr)
				fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("          in %s, 0x3f\n", REGS)
				fmt.Printf("          add %s, %s\n", REGU, REGY)
				fmt.Printf("          out 0x3f, %s\n", REGS)
				fmt.Printf("          rcall sid_write\n")
			} else {
				fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; STA $%04x,Y\n", addr-ramStart, addr)
				fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
				fmt.Printf("          in %s, 0x3f\n", REGS)
				fmt.Printf("          add r26,%s\n", REGY)
				fmt.Printf("          adc r27,%s\n", REGZ)
				fmt.Printf("          out 0x3f, %s\n", REGS)
				fmt.Printf("          st X, %s\n", REGA)
			}
		case ADC:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; ADC #$%02x\n", REGT, value, value)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case ADC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ADC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case ADC_Y:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; ADC $%04x,Y\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGY)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          ld %s, X\n", REGT)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case AND_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; AND $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          and %s, %s\n", REGA, REGT)
		case SBC:
			value := nextByte()
			fmt.Printf("sbci %s, 0x%02x                ; SBC #$%02x\n", REGA, value, value)
			//fmt.Printf("ldi %s, 0x%02x          ; SBC #$%02x\n", REGT, value, value)
			//fmt.Printf("          sbc %s, %s\n", REGA, REGT)
		case SBC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; SBC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
		case SBC_Y:
			addr := nextWord()
			fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; SBC $%04x,Y\n", addr-ramStart, addr)
			fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
			fmt.Printf("          in %s, 0x3f\n", REGS)
			fmt.Printf("          add r26,%s\n", REGY)
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          ld %s, X\n", REGT)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
		case ROR_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ROR $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          ror %s\n", REGT)
			fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
		case ORA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ORA $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          or %s, %s\n", REGA, REGT)
		case INC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; INC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          inc %s\n", REGT)
			fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
		case DEC_A:
			addr := nextWord()
			if pc-3 == 0x83b6 {
				// DEC at $83b6 is known to be updated to INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("lds %s, ram+0x%04x           ; DEC $%04x (SELF MODIFYING)\n", REGT, addr-ramStart, addr)
				fmt.Printf("          lds %s, zero+0x%02x\n", REGU, 0)
				fmt.Printf("          cpi %s, 0x%02x\n", REGU, DEC_A)
				fmt.Printf("          breq 1f\n")
				fmt.Printf("          inc %s\n", REGT)
				fmt.Printf("          sbrc %s, 0\n", REGZ)
				fmt.Printf("1:        dec %s\n", REGT)
				fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
			} else {
				fmt.Printf("lds %s, ram+0x%04x           ; DEC $%04x\n", REGT, addr-ramStart, addr)
				fmt.Printf("          dec %s\n", REGT)
				fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
			}
		case ASL:
			fmt.Printf("lsl %s                       ; ASL\n", REGA)
		case LSR:
			fmt.Printf("lsr %s                       ; LSR\n", REGA)
		case TAX:
			fmt.Printf("mov %s, %s                  ; TAX\n", REGX, REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGX)
			}
		case TAY:
			fmt.Printf("mov %s, %s                  ; TAY\n", REGY, REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGY)
			}
		case TXA:
			fmt.Printf("mov %s, %s                  ; TXA\n", REGA, REGX)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case TYA:
			fmt.Printf("mov %s, %s                  ; TYA\n", REGA, REGY)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		case NOP:
			fmt.Printf("                              ; NOP\n")
		case CLC:
			fmt.Printf("clc                           ; CLC\n")
		case SEC:
			fmt.Printf("sec                           ; SEC\n")
		case CLV:
			fmt.Printf("clv                           ; CLV\n")
		case INX:
			fmt.Printf("inc %s                       ; INX\n", REGX)
		case DEX:
			fmt.Printf("dec %s                       ; DEX\n", REGX)
		case INY:
			fmt.Printf("inc %s                       ; INY\n", REGY)
		case DEY:
			fmt.Printf("dec %s                       ; DEY\n", REGY)
		case RTS:
			fmt.Printf("ret                           ; RTS\n")
		case BRK:
			fmt.Printf("                              ; BRK\n")
		case PHA:
			fmt.Printf("push %s                      ; PHA\n", REGA)
		case PLA:
			fmt.Printf("pop %s                       ; PLA\n", REGA)
			if !nextSetsNZ() {
				fmt.Printf("          tst %s\n", REGA)
			}
		default:
			fmt.Printf("; UNKNOWN INSTRUCTION %02x\n", ins)
			log.Fatal("UNKNOWN INSTRUCTION")
  			return
		}
	}
}