package jetpack

import (
	"log"
)

type OpCode struct {
	ins    string
	mode   string
	desc   string
	action string
	flags  uint8
	code   uint8
	bytes  uint8
	cycles uint8
	extra  uint8
}

const FLAG_N = 1
const FLAG_Z = 2
const FLAG_C = 4
const FLAG_I = 8
const FLAG_D = 16
const FLAG_V = 32

const REGA = "r16" // 6502 Accumulator
const REGX = "r17" // 6502 X
const REGY = "r18" // 6502 Y
const REGZ = "r19" // Zero
const REGT = "r20" // Temp
const REGU = "r21" // Another Temp
const REGS = "r22" // AVR status register storage. for protecting the carry bit while we use it for pointer calculations.

func buildOpCodeMap() map[uint8]OpCode {
	m := make(map[uint8]OpCode)
	for _, o := range opcodes {
		m[o.code] = o
	}
	return m
}

func getOpcode(code uint8) OpCode {
	opcode, exists := opCodeMap[code]
	if !exists {
		log.Fatalf("UNKNOWN OPCODE %02x\n", code)
	}
	return opcode
}
