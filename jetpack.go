
package main

import (
	"os"
	"slipperyseal.net/jetpack/internal/app/jetpack"
)

func main() {
	jetpack.BlastOff(os.Args[1], true, false)
}