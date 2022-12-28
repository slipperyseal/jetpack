package jetpack

import (
	"fmt"
	"image"
	"image/png"
	"io/ioutil"
	"log"
	"os"
)

var sidHeader = SidHeader{}
var data []byte
var loadAddress uint16
var pc uint16                            // 6502 program counter
var ramStart uint16                      // offset at which ram block starts
var ramLen uint16                        // length of ram block
var maxZero uint8 = 0                    // often only the lower bit of zero page are used, so we track the highest read or write
var totalInstructions = 0                // count total instructions translated
var totalOpcodes = make(map[byte]byte)   // track op codes we've translated
var codeMap [0x10000]bool                // code at this address
var storeMap [0x10000]bool               // absolute or indexed store to this address
var loadMap [0x10000]bool                // absolute or indexed load from this address
var voidMap [0x10000]bool                // potentially eliminated code (if not in codeMap) but could have been kept on an alternate search.
var codeBlocks = make(map[uint16]uint16) // blocks of contiguous instructions
var jumpPoints = make(map[uint16]bool)
var failOnSelfModifying bool // set to false to ignore self modifying code
var printAllLabels bool      // print a label for each instruction, not just those needed for jumps and branches
var motr bool                // handle special cases for Monty_on_the_Run.sid

func BlastOff(path string, failOnSelfMod bool, printAllLab bool) {
	failOnSelfModifying = failOnSelfMod
	printAllLabels = printAllLab
	// special handing for Monty yaa!
	motr = path == "Monty_on_the_Run.sid"

	file, _ := os.Open(path)
	defer file.Close()

	readSidHeader(file)
	data = loadData(file)
	saveBinary(path + ".bin")

	loadAddress = sidHeader.LoadAddress
	ramStart = loadAddress
	if motr {
		ramStart = 0x8400
	}
	ramLen = uint16(len(data)) - (ramStart - loadAddress)

	writePrefix()
	writeSidInfo(path)
	writeMontyFunctions()

	searchCodeBlocks(sidHeader.InitAddress)
	searchCodeBlocks(sidHeader.PlayAddress)
	printCodeBlocks()
	transcodeBlocks()

	writeRamSpaces()
	writeSuffix()

	saveMemoryMap(path + ".memory.png")
}

func writePrefix() {
	fmt.Printf("\n\n    .section .text\n\n")

	fmt.Printf(";    Generated by Jetpack\n")
	fmt.Printf(";    https://github.com/slipperyseal/jetpack\n\n")
}

func writeRamSpaces() {
	fmt.Printf("\n")
	fmt.Printf(".global	zero\n")
	fmt.Printf("    .section .bss\n")
	fmt.Printf("    .type zero, @object\n")
	fmt.Printf("    .size zero, %d\n", maxZero+1)
	fmt.Printf("zero:\n")
	fmt.Printf("    .zero %d\n\n", maxZero+1)

	fmt.Printf(".global	ram\n")
	fmt.Printf("    .data\n")
	fmt.Printf("    .type ram, @object\n")
	fmt.Printf("    .size ram, %d\n", ramLen)
	fmt.Printf("ram:\n")

	writeBinary()
}

func loadData(file *os.File) []byte {
	readData, err := ioutil.ReadAll(file)
	if err != nil {
		log.Fatal(err)
	}
	return readData
}

func writeSuffix() {
	fmt.Printf(".global __do_copy_data\n")
	fmt.Printf(".global __do_clear_bss\n\n")

	fmt.Printf(";        6502 opcodes translated: %d of 151\n", len(totalOpcodes))
	fmt.Printf(";        instructions translated: %d\n", totalInstructions)
	fmt.Printf(";        Thank you for your cooperation.\n\n")

	fmt.Printf("    .end\n\n")
}

func writeBinary() {
	dataOff := ramStart - loadAddress
	l := int(ramLen) & 0xffff
	col := 0
	for b := 0; b < l; b++ {
		if col == 0 {
			fmt.Printf("    .ascii \"")
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

// save the binary of the tune without the header, so it can be loaded into a disassembler or whatevs
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
	return InstructionsSetNV[data[pc-loadAddress]]
}

// fetches the next byte and returns the calculated PC relative address. for branch instructions.
// increment the program counter and mark the code map
func nextByteRelativeAddress() uint16 {
	return uint16(int32(pc&0xffff) + int32(int8(nextByte())))
}

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
	for byteAt(addr) == JMP {
		voidMap[addr] = true   // mark potential elimination of this instruction
		voidMap[addr+1] = true // if not required on other paths
		voidMap[addr+2] = true
		addr = wordAt(addr + 1)
	}
	return addr
}

func transcode(address uint16, stop uint16) {
	pc = address

	fmt.Printf("\n          ; transcode $%04x - $%04x\n", address, stop)

	// 6502 carry is inverted for subtractive instructions
	carryInverted := false
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
			addr := flattenJumpAddress(nextWord())
			fmt.Printf("rjmp L%04x                    ; JMP $%04x\n", addr, addr)
		case JSR:
			addr := flattenJumpAddress(nextWord())
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
				storeMap[addr] = true
			}
		case STA_Z:
			addr := nextByte()
			fmt.Printf("sts zero+0x%02x, %s            ; STA $%02x\n", addr, REGA, addr)
			storeMap[addr] = true
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
				storeMap[addr] = true
			}
		case STY:
			addr := nextWord()
			if motr && addr == 0x83b6 {
				// STY $83b6 is known to update INC / DEC instructions - we will store this value at zero[0]
				fmt.Printf("sts zero+0x%02x, %s            ; STY $%04x (SELF MODIFYING)\n", 0, REGY, addr)
			} else {
				fmt.Printf("sts ram+0x%04x, %s           ; STY $%04x\n", addr-ramStart, REGY, addr)
				checkSelfMod(addr)
				storeMap[addr] = true
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
			carryInverted = true
		case CMP_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; CMP $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
			loadMap[addr] = true
			carryInverted = true
		case CMP_X:
			loadIndexed(REGT, REGX, "CMP", "X")
			fmt.Printf("          cp %s, %s\n", REGA, REGT)
			carryInverted = true
		case CPX:
			immediate("cpi", REGX, "CPX")
			carryInverted = true
		case CPY:
			immediate("cpi", REGY, "CPY")
			carryInverted = true
		case BIT:
			// BIT sets the Z flag as though the value in the address tested were ANDed with the accumulator.
			// The N and V flags are set to match bits 7 and 6 respectively in the value stored at the tested address.
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; BIT $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          mov %s, %s\n", REGU, REGT)
			fmt.Printf("          and %s, %s\n", REGU, REGA) // A and M -> Z
			fmt.Printf("          cln\n")
			fmt.Printf("          clv\n")
			fmt.Printf("          sbrc %s, 7\n", REGT) // M bit 7 -> N
			fmt.Printf("          sen\n")
			fmt.Printf("          sbrc %s, 6\n", REGT) // M bit 6 -> V
			fmt.Printf("          sev\n")
		case BCS:
			if carryInverted {
				branch("brcc", "BCS")
			} else {
				branch("brcs", "BCS")
			}
		case BCC:
			if carryInverted {
				branch("brcs", "BCC")
			} else {
				branch("brcc", "BCC")
			}
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
			loadMap[addr] = true
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
			loadMap[addr] = true
		case LDY_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; LDY $%04x\n", REGY, addr-ramStart, addr)
			checkTest(REGY)
			loadMap[addr] = true
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
			fmt.Printf("          subi r26,lo8(0x%04x)\n", ramStart) // subtract data start
			fmt.Printf("          sbci r27,hi8(0x%04x)\n", ramStart)
			fmt.Printf("          subi r26,lo8(-(ram))\n") // add ram offset
			fmt.Printf("          sbci r27,hi8(-(ram))\n")
			fmt.Printf("          add r26,%s\n", REGY) // add Y index
			fmt.Printf("          adc r27,%s\n", REGZ)
			fmt.Printf("          out 0x3f, %s\n", REGS)
			fmt.Printf("          ld %s, X\n", REGA)
			checkTest(REGA)
			pushMaxZero(addr + 1) // address will be 2 byte pointer
			loadMap[addr] = true
			loadMap[addr+1] = true
		case STA_X:
			storeIndexed(REGA, REGX, "STA", "X")
		case STA_Y:
			storeIndexed(REGA, REGY, "STA", "Y")
		case ADC:
			value := nextByte()
			fmt.Printf("ldi %s, 0x%02x                 ; ADC #$%02x\n", REGT, value, value)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ADC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
			loadMap[addr] = true
			carryInverted = false
		case ADC_X:
			loadIndexed(REGT, REGX, "ADC", "X")
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case ADC_Y:
			loadIndexed(REGT, REGY, "ADC", "Y")
			fmt.Printf("          adc %s, %s\n", REGA, REGT)
			carryInverted = false
		case AND_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; AND $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          and %s, %s\n", REGA, REGT)
			loadMap[addr] = true
		case SBC:
			value := nextByte()
			fmt.Printf("sbci %s, 0x%02x                ; SBC #$%02x\n", REGA, value, value)
			carryInverted = true
		case SBC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; SBC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
			loadMap[addr] = true
			carryInverted = true
		case SBC_X:
			loadIndexed(REGT, REGX, "SBC", "X")
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case SBC_Y:
			loadIndexed(REGT, REGY, "SBC", "Y")
			fmt.Printf("          sbc %s, %s\n", REGA, REGT)
			carryInverted = true
		case ROR_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ROR $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          ror %s\n", REGT)
			fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
			loadMap[addr] = true
			storeMap[addr] = true
		case ORA_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; ORA $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          or %s, %s\n", REGA, REGT)
			loadMap[addr] = true
		case INC_A:
			addr := nextWord()
			fmt.Printf("lds %s, ram+0x%04x           ; INC $%04x\n", REGT, addr-ramStart, addr)
			fmt.Printf("          inc %s\n", REGT)
			fmt.Printf("          sts ram+0x%04x, %s\n", addr-ramStart, REGT)
			loadMap[addr] = true
			storeMap[addr] = true
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
				loadMap[addr] = true
				storeMap[addr] = true
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
			// 6502 NOPs were either for padding or timing, neither of which apply here
			fmt.Printf("                              ; NOP\n")
		case BRK:
			// ¯\_(ツ)_/¯
			fmt.Printf("                              ; BRK\n")
		case CLC:
			fmt.Printf("clc                           ; CLC\n")
			carryInverted = false
		case SEC:
			fmt.Printf("sec                           ; SEC\n")
			carryInverted = false
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
	addr := flattenJumpAddress(nextByteRelativeAddress())
	// branching too far may require a longer range rjmp.
	// the range of 16 isn't very scientific as our instructions are variable length.
	if addr > pc+16 || addr < pc-16 {
		fmt.Printf("%s 1f                       ; %s $%04x\n", branchIns, ins, addr)
		fmt.Printf("          sbrc %s, 0\n", REGZ) // branch not taken so always skip next instruction (bit 0 in REGZ is clear)
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
	loadMap[addr] = true
}

func storeIndexed(reg string, indexReg string, ins string, insIndex string) {
	addr := nextWord()
	if addr&0xff00 == 0xd400 {
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
	storeMap[addr] = true
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
	if failOnSelfModifying && codeMap[addr] {
		log.Fatal(fmt.Sprintf("SELF-MODIFYING CODE TO $%04x - PC $%04x\n", addr, pc))
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
		switch ins {
		case JMP:
			searchCodeBlocks(nextWord())
			pc = savePc
			return
		case JSR:
			searchCodeBlocks(nextWord())
		case BCS, BCC, BVS, BVC, BPL, BMI, BNE, BEQ:
			searchCodeBlocks(nextByteRelativeAddress())
		case RTS:
			pc = savePc
			return
		default:
			size, exists := InstructionBytes[ins]
			if !exists {
				log.Fatal(fmt.Sprintf("INSTRUCTION SIZE UNKOWN %02x\n", ins))
			}
			for c := 1; c < size; c++ {
				codeMap[pc+uint16(c-1)] = true
			}
			pc += uint16(size - 1)
		}
	}
}

func printCodeBlocks() {
	change := codeMap[0]
	for index := 0; index < 0x10000; index++ {
		code := codeMap[index]
		if code != change {
			if code {
				fmt.Printf(";    code block $%04x - ", index)
			} else {
				fmt.Printf("$%04x\n", index-1)
			}
			change = code
		}
	}
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
				codeBlocks[start] = uint16(index - 1)
				transcode(start, uint16(index-1))
			}
			change = code
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
		if loadMap[c] || storeMap[c] {
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
