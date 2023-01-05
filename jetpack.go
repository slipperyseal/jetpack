package main

import (
	"fmt"
	"os"
	"slipperyseal.net/jetpack/internal/app/jetpack"
	"strings"
)

func sidArg() string {
	for _, v := range os.Args[1:] {
		if strings.HasSuffix(v, ".sid") {
			return v
		}
	}

	fmt.Errorf("No .sid specified")
	return ""
}

func arg(option string) bool {
	for _, v := range os.Args[1:] {
		if v == option {
			return true
		}
	}

	return false
}

func main() {
	jetpack.BlastOff(sidArg(),
		arg("-allowselfmodify"), // don't fail if we notice unhandled writes into the code space
		arg("-printalllabels"),  // print labels for every instruction, not just jump and branch points
		arg("-writesidbinary"),  // write the sid binary which can be loaded into 6502 tools
		arg("-writememorymap"),  // write the memory map as a png which can be looked at with your eyeballs
		0)                       // try using the lower value of "RAM access range" reported in the output source
}
