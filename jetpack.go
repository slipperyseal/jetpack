
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
const ADC_X = 0x7D
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
const LDA_X = 0xbd
const LDA_Y = 0xB9
const LDA_A = 0xAD
const LDA_IY = 0xB1
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
const PHP = 0x08
const PLA = 0x68
const PLP = 0x28
const RTI = 0x40
const RTS = 0x60
const ROR_A = 0x6e
const SEC = 0x38
const SBC_A = 0xed
const SBC = 0xe9
const SBC_X = 0xfd
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

var instructionBytes = map[uint8]int{
	0x69: 2,0x65: 2,0x75: 2,0x6D: 3,0x7D: 3,0x79: 3,0x61: 2,0x71: 2,0x29: 2,0x25: 2,0x35: 2,0x2D: 3,0x3D: 3,0x39: 3,
	0x21: 2,0x31: 2,0x0A: 1,0x06: 2,0x16: 2,0x0E: 3,0x1E: 3,0x90: 2,0xB0: 2,0xF0: 2,0x24: 2,0x2C: 3,0x30: 2,0xD0: 2,
	0x10: 2,0x00: 1,0x50: 2,0x70: 2,0x18: 1,0xD8: 1,0x58: 1,0xB8: 1,0xC9: 2,0xC5: 2,0xD5: 2,0xCD: 3,0xDD: 3,0xD9: 3,
	0xC1: 2,0xD1: 2,0xE0: 2,0xE4: 2,0xEC: 3,0xC0: 2,0xC4: 2,0xCC: 3,0xC6: 2,0xD6: 2,0xCE: 3,0xDE: 3,0xCA: 1,0x88: 1,
	0x49: 2,0x45: 2,0x55: 2,0x4D: 3,0x5D: 3,0x59: 3,0x41: 2,0x51: 2,0xE6: 2,0xF6: 2,0xEE: 3,0xFE: 3,0xE8: 1,0xC8: 1,
	0x4C: 3,0x6C: 3,0x20: 3,0xA9: 2,0xA5: 2,0xB5: 2,0xAD: 3,0xBD: 3,0xB9: 3,0xA1: 2,0xB1: 2,0xA2: 2,0xA6: 2,0xB6: 2,
	0xAE: 3,0xBE: 3,0xA0: 2,0xA4: 2,0xB4: 2,0xAC: 3,0xBC: 3,0x4A: 1,0x46: 2,0x56: 2,0x4E: 3,0x5E: 3,0xEA: 1,0x09: 2,
	0x05: 2,0x15: 2,0x0D: 3,0x1D: 3,0x19: 3,0x01: 2,0x11: 2,0x48: 1,0x08: 1,0x68: 1,0x28: 1,0x2A: 1,0x26: 2,0x36: 2,
	0x2E: 3,0x3E: 3,0x6A: 1,0x66: 2,0x76: 2,0x6E: 3,0x7E: 3,0x40: 1,0x60: 1,0xE9: 2,0xE5: 2,0xF5: 2,0xED: 3,0xFD: 3,
	0xF9: 3,0xE1: 2,0xF1: 2,0x38: 1,0xF8: 1,0x78: 1,0x85: 2,0x95: 2,0x8D: 3,0x9D: 3,0x99: 3,0x86: 2,0x96: 2,0x8E: 3,
	0x84: 2,0x94: 2,0x8C: 3,0xAA: 1,0xA8: 1,0xBA: 1,0x8A: 1,0x9A: 1,0x98: 1}

var header = Header{}
var data []byte
var pc uint16			// 6502 program counter
var ramStart uint16		// offset at which ram block starts
var ramLen uint16		// length of ram block
var maxZero uint8 = 0   // often only the lower bit of zero page are used so we track the highest read or write
var totalInstructions = 0
var totalOpcodes = make(map[byte]byte)
var codeMap [0xffff]bool
var codeBlocks = make(map[uint16]uint16)
var jumpPoints = make(map[uint16]bool)
var printAllLabels = false
var motr bool          // handle special cases for Monty_on_the_Run.sid

func main() {
	path := os.Args[1]
	// special handing for Monty yaa!
	motr = path == "Monty_on_the_Run.sid"

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

	// if you want to disassemble the raw data block
	saveDataBlock(path + ".bin")

	ramStart = header.LoadAddress
	if motr {
		ramStart = 0x8400
	}
	ramLen = uint16(len(data)) - (ramStart - header.LoadAddress)

	fmt.Printf("\n\n    .section .text\n\n")

	fmt.Printf(";    Generated by Jetpack\n")
	fmt.Printf(";    https://github.com/slipperyseal/jetpack\n\n")

	fmt.Printf(";      SID file: %s\n", path)
	fmt.Printf(";          Name: %s\n", string(header.Name[:bytes.Index(header.Name[:], []byte{0})]))
	fmt.Printf(";        Author: %s\n", string(header.Author[:bytes.Index(header.Author[:], []byte{0})]))
	fmt.Printf(";      Released: %s\n", string(header.Released[:bytes.Index(header.Released[:], []byte{0})]))
	fmt.Printf(";         Songs: %d\n", header.Songs)
	fmt.Printf(";     StartSong: %d\n", header.StartSong)
	fmt.Printf(";   LoadAddress: $%04x\n", header.LoadAddress)
	fmt.Printf(";   InitAddress: $%04x\n", header.InitAddress)
	fmt.Printf(";   PlayAddress: $%04x\n", header.PlayAddress)
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

	searchCodeBlocks(header.InitAddress)
	searchCodeBlocks(header.PlayAddress)
	listCodeBlocks()
	transcodeBlocks()

	fmt.Printf("\n")
	fmt.Printf(".global	zero\n")
	fmt.Printf("    .section .bss\n")
	fmt.Printf("    .type zero, @object\n")
	fmt.Printf("    .size zero, %d\n", maxZero+1)
	fmt.Printf("zero:\n")
	fmt.Printf("    .zero %d\n", maxZero+1)

	fmt.Printf("\n")
	fmt.Printf(".global	ram\n")
	fmt.Printf("    .data\n")
	fmt.Printf("    .type ram, @object\n")
	fmt.Printf("    .size ram, %d\n", ramLen)
	fmt.Printf("ram:\n")

	writeBinary()

	fmt.Printf("\n\n")
	fmt.Printf(".global __do_copy_data\n")
	fmt.Printf(".global __do_clear_bss\n\n")

	fmt.Printf(";        6502 opcodes translated: %d of 151\n", len(totalOpcodes))
	fmt.Printf(";        instructions translated: %d\n", totalInstructions)
	fmt.Printf("; Thank you for your cooperation\n")
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

// fetches the the next byte and returns the calculated PC relative address. for branch instructions.
// increments the program counter and marking the code map
func relative8() uint16 {
	return uint16( int32(pc & 0xffff) + int32(int8(nextByte())) )
}

// get the next byte and increment the program counter and marking the code map
func nextByte() uint8 {
	v := data[pc-header.LoadAddress]
	codeMap[pc] = true
	pc++
	return v
}

// get the next word and increment the program counter and marking the code map
func nextWord() uint16 {
	v := (uint16)(data[pc-header.LoadAddress + 1]) << 8 | (uint16)(data[pc-header.LoadAddress])
	codeMap[pc] = true
	codeMap[pc+1] = true
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

func saveDataBlock(filename string) {
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

func transcode(address uint16, stop uint16) {
	pc = address

	fmt.Printf("\n          ; transcode %04x - %04x\n", address, stop)
	for pc <= stop {
		if printAllLabels || jumpPoints[pc] {
			fmt.Printf("L%04x:    ", pc)
		} else {
			fmt.Printf("          ")
		}

		ins := nextByte()
		totalInstructions++
		totalOpcodes[ins] = ins
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
				checkSelfMod(addr)
			}
		case STA_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STA $%02x\n", addr, REGA, addr)
			pushMaxZero(addr)
		case STX:
			addr := nextWord()
			if addr&0xff00 == 0xd400 {
				fmt.Printf("mov %s, %s                  ; STX $%04x (SID)\n", REGT, REGX, addr)
				fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
				fmt.Printf("          rcall sid_write\n")
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STX $%04x\n", addr-ramStart, REGX, addr)
				checkSelfMod(addr)
			}
		case STY:
			addr := nextWord()
			if motr && addr == 0x83b6 {
				// STY $83b6 is known to update INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("sts zero+0x%02x, %s            ; STY $%04x (SELF MODIFYING)\n", 0, REGY, addr)
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STY $%04x\n", addr-ramStart, REGY, addr)
				checkSelfMod(addr)
			}
		case AND:
			immediate("andi", REGA, "AND")
		case ORA:
			immediate("ori", REGA, "ORA")
		case EOR:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; EOR #$%02x\n", REGT, value, value)
			fmt.Printf("          eor %s, %s\n", REGA, REGT)
		case CMP:
			immediate("cpi", REGA, "CMP")
			invertCarry()
		case CMP_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CMP $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
		case CMP_X:
			loadIndexed(REGT, REGX, "CMP", "X")
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
			invertCarry()
		case CPX:
			immediate("cpi", REGX, "CPX")
			invertCarry()
		case CPY:
			immediate("cpi", REGY, "CPY")
			invertCarry()
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
			branch("brcs", "BCS")
		case BCC:
			branch("brcc", "BCC")
		case BVS:
			branch("brvs", "BVS")
		case BVC:
			branch("brvc", "BVC")
		case BPL:
			branch("brpl", "BPL")
		case BMI:
			branch("brmi", "BMI")
		case BNE:
			branch("brne", "BNE")
		case BEQ:
			branch("breq", "BEQ")
		case LDA:
			immediate("ldi", REGA, "LDA")
			checkTest(REGA)
		case LDA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDA $%04x\n", REGA, addr-ramStart, addr)
			checkTest(REGA)
		case LDA_X:
			loadIndexed(REGA, REGX, "LDA", "X")
			checkTest(REGA)
		case LDA_Y:
			loadIndexed(REGA, REGY, "LDA", "Y")
			checkTest(REGA)
		case LDX:
			immediate("ldi", REGX, "LDX")
			checkTest(REGX)
		case LDY:
			immediate("ldi", REGY, "LDY")
			checkTest(REGY)
		case LDX_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDX $%04x\n", REGX, addr-ramStart, addr)
			checkTest(REGX)
		case LDY_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDY $%04x\n", REGY, addr-ramStart, addr)
			checkTest(REGY)
		case LDY_X:
			loadIndexed(REGY, REGX, "LDY", "X")
			checkTest(REGY)
		case INC_X:
			loadIndexed(REGT, REGX, "INC", "X")
			fmt.Printf("          inc %s\n", REGT)
			fmt.Printf("          st X, %s\n", REGT)
		case DEC_X:
			loadIndexed(REGT, REGX, "DEC", "X")
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
			checkTest(REGA)
			pushMaxZero(addr+1) // address will be 2 byte pointer
		case STA_X:
			storeIndexed(REGA, REGX, "STA", "X")
		case STA_Y:
			storeIndexed(REGA, REGY, "STA", "Y")
		case ADC:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; ADC #$%02x\n", REGT, value, value)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case ADC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ADC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case ADC_X:
			loadIndexed(REGT, REGX, "ADC", "X")
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case ADC_Y:
			loadIndexed(REGT, REGY, "ADC", "Y")
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
		case AND_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; AND $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          and %s, %s\n", REGA, REGT)
		case SBC:
			value := nextByte()
			fmt.Printf("sbci %s, 0x%02x                ; SBC #$%02x\n", REGA, value, value)
		case SBC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; SBC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
		case SBC_X:
			loadIndexed(REGT, REGX, "SBC", "X")
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
		case SBC_Y:
			loadIndexed(REGT, REGY, "SBC", "Y")
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
			if motr && pc-3 == 0x83b6 {
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
		case RTI:
			fmt.Printf("ret                           ; RTI\n") // assume ISR has been wrapped by JSR
		case RTS:
			fmt.Printf("ret                           ; RTS\n")
		case BRK:
			fmt.Printf("                              ; BRK\n")
		case PHA:
			fmt.Printf("push %s                      ; PHA\n", REGA)
		case PLA:
			fmt.Printf("pop %s                       ; PLA\n", REGA)
			checkTest(REGA)
		case PHP:
			fmt.Printf("in %s, 0x3f                  ; PHP\n", REGS)
			fmt.Printf("          push %s\n", REGS)
		case PLP:
			fmt.Printf("pop %s                       ; PLP\n", REGS)
			fmt.Printf("          out 0x3f, %s\n", REGS)
		default:
			fmt.Printf("; UNKNOWN INSTRUCTION %02x\n", ins)
			log.Fatal(fmt.Sprintf("UNKNOWN INSTRUCTION %02x\n", ins))
  			return
		}
	}
}

func checkTest(reg string) {
	if !nextSetsNZ() {
		fmt.Printf("          tst %s\n", reg)
	}
}

func branch(branchIns string, ins string) {
	addr := relative8()
	// this isn't very scientific as our instructions are variable length, but branching too far may require rjmp
	if addr > pc+16 || addr < pc-16 {
		fmt.Printf("%s 1f                       ; %s $%04x\n", branchIns, ins, addr)
		fmt.Printf("          sbrc %s, 0\n", REGZ) // always skip next instruction. bit 0 in REGZ is clear
		fmt.Printf("1:        rjmp L%04x\n", addr)
	} else {
		fmt.Printf("%s L%04x                    ; %s $%04x\n", branchIns, addr, ins, addr)
	}
}

func loadIndexed(reg string, indexReg string, ins string, insIndex string) {
	addr := nextWord()
	fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; %s $%04x,%s\n", addr-ramStart, ins, addr, insIndex)
	fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
	fmt.Printf("          in %s, 0x3f\n", REGS)
	fmt.Printf("          add r26,%s\n", indexReg)
	fmt.Printf("          adc r27,%s\n", REGZ)
	fmt.Printf("          out 0x3f, %s\n", REGS)
	fmt.Printf("          ld %s, X\n", reg)
}

func storeIndexed(reg string, indexReg string, ins string, insIndex string) {
	addr := nextWord()
	if addr & 0xff00 == 0xd400 {
		fmt.Printf("mov %s, %s                  ; %s $%04x,%s (SID)\n", REGT, REGA, ins, addr, insIndex)
		fmt.Printf("          ldi %s, 0x%02x\n", REGU, addr&0xff)
		fmt.Printf("          in %s, 0x3f\n", REGS)
		fmt.Printf("          add %s, %s\n", REGU, indexReg)
		fmt.Printf("          out 0x3f, %s\n", REGS)
		fmt.Printf("          rcall sid_write\n")
		return
	}
	fmt.Printf("ldi r26,lo8(ram+0x%04x)       ; %s $%04x,%s\n", addr-ramStart, ins, addr, insIndex)
	fmt.Printf("          ldi r27,hi8(ram+0x%04x)\n", addr-ramStart)
	fmt.Printf("          in %s, 0x3f\n", REGS)
	fmt.Printf("          add r26,%s\n", indexReg)
	fmt.Printf("          adc r27,%s\n", REGZ)
	fmt.Printf("          out 0x3f, %s\n", REGS)
	fmt.Printf("          st X, %s\n", reg)
}

func invertCarry() {
	fmt.Printf("          in %s, 0x3f\n", REGS)
	fmt.Printf("          eor %s, %s\n", REGS, REGW)
	fmt.Printf("          out 0x3f, %s\n", REGS)
}

func immediate(immediateIns string, reg string, ins string) {
	value := nextByte()
	fmt.Printf("%-4s %s, 0x%02x                ; %s #$%02x\n", immediateIns, reg, value, ins, value)
}

func pushMaxZero(val uint8) {
	if maxZero < val {
		maxZero = val
	}
}

func checkSelfMod(addr uint16) {
	if codeMap[addr] {
		//log.Fatal(fmt.Sprintf("WRITE TO CODE SECTION $%04x - PC $%04x\n", addr, pc))
	}
}


// follows the code path, taking branches and jumps, marking memory which contains code and their jump points
func searchCodeBlocks(start uint16) {
	jumpPoints[start] = true // may have been visited but may not have been a jump point
	if codeMap[start] { // already been down this road
		return
	}
	savePc := pc
	pc = start
	for {
		ins := nextByte()
		switch ins {
		case JMP:
			searchCodeBlocks(nextWord())
			pc = savePc
			return
		case JSR:
			searchCodeBlocks(nextWord())
		case BCS, BCC, BVS, BVC, BPL, BMI, BNE, BEQ:
			searchCodeBlocks(relative8())
		case RTS:
			pc = savePc
			return
		default:
			size, exists := instructionBytes[ins]
			if !exists {
				log.Fatal(fmt.Sprintf("INSTRUCTION SIZE UNKOWN %02x\n", ins))
			}
			for c := 1; c < size; c++ {
				codeMap[pc+uint16(c-1)] = true
			}
			pc += uint16(size-1)
		}
	}
}

func listCodeBlocks() {
	s := codeMap[0]
	for c := 0; c < 0xffff; c++ {
		cd := codeMap[c]
		if cd != s {
			if cd {
				fmt.Printf(";    code block $%04x - ", c)
			} else {
				fmt.Printf("$%04x\n", c-1)
			}
			s = cd
		}
	}
}

func transcodeBlocks() {
	var start uint16
	s := codeMap[0]
	for c := 0; c < 0xffff; c++ {
		cd := codeMap[c]
		if cd != s {
			if cd {
				start = uint16(c)
			} else {
				codeBlocks[start] = uint16(c-1)
				transcode(start, uint16(c-1))
			}
			s = cd
		}
	}
}