# Jetpack

### 6502 to AVR cross assembler

SID chip tunes are 6502 processor code and binary data which actually ran on the Commodore 64.
But rather than try to squeeze a 6502 emulator on the AVR, I cross assembled the play routine and data.
I mapped 65 of the 6502s 151 instructions to AVR assembler, intercepted write the SID chip at $d4xx and
handled one piece of self modifying code.

Monty playing the Monty On The Run chip tune by Rob Hubbard.

[![Monty](https://img.youtube.com/vi/i0d1r9NZg9I/0.jpg)](https://www.youtube.com/watch?v=i0d1r9NZg9I)

https://www.youtube.com/watch?v=i0d1r9NZg9I

#### Status

The current implemention was written specifically (or at least initially) to cross-compile the
Monty On The Run SID tune, to the AVR to run on the Monty Stereo SID Synth.

https://github.com/slipperyseal/monty

The plan is to make Jetpack more generic, self-configuring (in detecting data and code boundaries etc) and
implement all the remaining 6502 instructions.

#### Run

Jetpak is written in `go`.  If you don't have that, get it hyair...

https://golang.org/doc/install

The current implementation loads `Monty_on_the_Run.sid` and write the output AVR assembler to standard out.
This assembler is compatible with `AVR-GCC`.

    go run jetpack.go >mort.avr.s

While Jetpack sources the binary from `Monty_on_the_Run.sid`, the repo also contains the disassembled 6502 binary as
`motr.6502.asm`.  This is handy when developing Jetpack and when comparing the cross-assembled output.

The last version of the output is included in the repo as `mort.avr.s`

#### Pros and cons of cross-assembly vs emulation

##### Pros

- Speed. Many instructions have a single instruction equivalent. For those that don't, the 6502 instruction often
consumes several processor cycles anyway. While the AVR equivalent sometimes uses more instructions,
each typically execute in 1 or 2 cycles. On average, it's probably faster than emulation.

- Statically compiled simplicity. Assuming the cross-assemble was successful, no need not worry about dealing with an emulator.
Emulation on AVRs with limited memory would still need to deal with a partial memory block, rather than the full 64K.
This was the main driver for the project. Emulation might be more accurate, but I was just targeting one piece of code.
Not to mention it being a cool challenge.

- Call functions direct from C etc.

##### Cons

- Statically compiled. Unable to execute arbitrary code from SRAM.

- Code density. 6502 code is much denser than the cross compile. For large code blocks emulation is perhaps preferred.

- Can't cover all corner cases or self-modifying code that emulation can.

#### Example cross assembly

##### 6502 input

    8367   A0 FF      L8367     LDY #$FF
    8369   AD FB 84             LDA $84FB
    836C   D0 06                BNE L8374
    836E   AD FC 84             LDA $84FC
    8371   30 01                BMI L8374
    8373   C8                   INY
    8374   8C FD 84   L8374     STY $84FD
    8377   CA                   DEX
    8378   30 03                BMI L837D
    837A   4C 5F 80             JMP L805F
    837D   A9 FF      L837D     LDA #$FF
    837F   8D FD 84             STA $84FD
    8382   AD FB 84             LDA $84FB
    8385   D0 05                BNE L838C
    8387   2C FC 84             BIT $84FC

##### AVR output

    L8367:    ldi r18, 0xff                 ; LDY #$ff
    L8369:    lds r16, ram+0x00fb           ; LDA $84fb
              tst r16
    L836c:    brne L8374                    ; BNE $8374
    L836e:    lds r16, ram+0x00fc           ; LDA $84fc
              tst r16
    L8371:    brmi L8374                    ; BMI $8374
    L8373:    inc r18                       ; INY
    L8374:    sts ram+0x00fd, r18           ; STY $84fd
    L8377:    dec r17                       ; DEX
    L8378:    brmi L837d                    ; BMI $837d
    L837a:    rjmp L805f                    ; JMP $805f
    L837d:    ldi r16, 0xff                 ; LDA #$ff
              tst r16
    L837f:    sts ram+0x00fd, r16           ; STA $84fd
    L8382:    lds r16, ram+0x00fb           ; LDA $84fb
              tst r16
    L8385:    brne L838c                    ; BNE $838c
    L8387:    lds r20, ram+0x00fc           ; BIT $84fc
              mov r21, r20
              and r21, r16
              cln
              clv
              sbrc r20, 7
              sen
              sbrc r20, 6
              sev
              