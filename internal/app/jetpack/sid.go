package jetpack

import (
	"bytes"
	"encoding/binary"
	"fmt"
	"os"
)

type SidHeader struct {
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

func readSidHeader(file *os.File)  {
	binary.Read(file, binary.BigEndian, &sidHeader.MagicID)
	binary.Read(file, binary.BigEndian, &sidHeader.Version)
	binary.Read(file, binary.BigEndian, &sidHeader.DataOffset)
	binary.Read(file, binary.BigEndian, &sidHeader.LoadAddress)
	binary.Read(file, binary.BigEndian, &sidHeader.InitAddress)
	binary.Read(file, binary.BigEndian, &sidHeader.PlayAddress)
	binary.Read(file, binary.BigEndian, &sidHeader.Songs)
	binary.Read(file, binary.BigEndian, &sidHeader.StartSong)
	binary.Read(file, binary.BigEndian, &sidHeader.Speed)
	binary.Read(file, binary.BigEndian, &sidHeader.Name)
	binary.Read(file, binary.BigEndian, &sidHeader.Author)
	binary.Read(file, binary.BigEndian, &sidHeader.Released)
	binary.Read(file, binary.BigEndian, &sidHeader.Flags)
	binary.Read(file, binary.BigEndian, &sidHeader.StartPage)
	binary.Read(file, binary.BigEndian, &sidHeader.PageLength)
	binary.Read(file, binary.BigEndian, &sidHeader.SecondSIDAddress)
	binary.Read(file, binary.BigEndian, &sidHeader.ThirdSIDAddress)

	// if load address is zero, the load address is found at the start of the data block
	if sidHeader.LoadAddress == 0 {
		binary.Read(file, binary.LittleEndian, &sidHeader.FirstData)
		sidHeader.LoadAddress = sidHeader.FirstData
	}
}

func writeSidInfo(path string) {
	fmt.Printf(";      SID file: %s\n", path)
	fmt.Printf(";          Name: %s\n", string(sidHeader.Name[:bytes.Index(sidHeader.Name[:], []byte{0})]))
	fmt.Printf(";        Author: %s\n", string(sidHeader.Author[:bytes.Index(sidHeader.Author[:], []byte{0})]))
	fmt.Printf(";      Released: %s\n", string(sidHeader.Released[:bytes.Index(sidHeader.Released[:], []byte{0})]))
	fmt.Printf(";         Songs: %d\n", sidHeader.Songs)
	fmt.Printf(";     StartSong: %d\n", sidHeader.StartSong)
	fmt.Printf(";   LoadAddress: $%04x\n", sidHeader.LoadAddress)
	fmt.Printf(";   InitAddress: $%04x\n", sidHeader.InitAddress)
	fmt.Printf(";   PlayAddress: $%04x\n", sidHeader.PlayAddress)
	fmt.Printf(";  Total Binary: %d bytes\n", len(data))
	fmt.Printf(";           RAM: %d bytes\n\n", ramLen)
}

// for use with Monty Stereo SID Synth
// https://github.com/slipperyseal/monty
// sid_init() and sid_play() are expected to be called from an ISR where avr-gcc has saved registers
func writeMontyFunctions()  {
	fmt.Printf(".global sid_init\n")
	fmt.Printf("    .type sid_init, @function\n")
	fmt.Printf("sid_init:\n")
	fmt.Printf("    mov %s, r24\n", REGA) // tune
	fmt.Printf("    clr %s\n", REGX)
	fmt.Printf("    clr %s\n", REGY)
	fmt.Printf("    clr %s\n", REGZ)
	fmt.Printf("    rjmp L%04x\n\n", flattenJumpAddress(sidHeader.InitAddress))

	fmt.Printf(".global sid_play\n")
	fmt.Printf("    .type sid_play, @function\n")
	fmt.Printf("sid_play:\n")
	fmt.Printf("    clr %s\n", REGA)
	fmt.Printf("    clr %s\n", REGX)
	fmt.Printf("    clr %s\n", REGY)
	fmt.Printf("    clr %s\n", REGZ)
	fmt.Printf("    rjmp L%04x\n\n", flattenJumpAddress(sidHeader.PlayAddress))

	fmt.Printf("sid_write:\n")				// REGU = address, REGT = value
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
}