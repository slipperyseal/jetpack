

    .section .text

;    DataOffset: $7c
;   LoadAddress: $8000
;   InitAddress: $8000
;   PlayAddress: $8012
;     FirstData: $8000
;         Songs: 19
;     StartSong: 1
;          Name: Monty on the Run
;        Author: Rob Hubbard
;      Released: 1985 Gremlin Graphics
;  Total Binary: 5568 bytes
;           RAM: 4544 bytes

.global sid_init
    .type sid_init, @function
sid_init:
    mov r16, r24
    clr r17
    clr r18
    clr r19
    ldi r23, 0x01
    rjmp L8000

.global sid_play
    .type sid_play, @function
sid_play:
    clr r16
    clr r17
    clr r18
    clr r19
    ldi r23, 0x01
    rjmp L8012

sid_write:
    out 0x5,r20
    out 0x8,r20
    andi r21, 0x1f
    out 0x2,r21
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ori r21,lo8(-64)
    out 0x2, r21
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret


          ; transcode 8000 - 8400

L8000:    rjmp L95a0                    ; JMP $95a0
L8003:    rjmp L8012                    ; JMP $8012
L8006:    ret                           ; RTS
L8007:    ret                           ; RTS
L8008:                                  ; BRK
L8009:    ;rjmp L0089                    ; JMP $0089
L800c:                                  ; BRK
L800d:                                  ; BRK
L800e:                                  ; BRK
L800f:                                  ; BRK
L8010:                                  ; BRK
L8011:                                  ; BRK
L8012:    ldi r16, 0x0f                 ; LDA #$0f
          tst r16
L8014:    mov r20, r16                  ; STA $d418 (SID)
          ldi r21, 0x18
          rcall sid_write
L8017:    lds r20, ram+0x00fa           ; INC $84fa
          inc r20
          sts ram+0x00fa, r20
L801a:    lds r20, ram+0x00ee           ; BIT $84ee
          mov r21, r20
          and r21, r16
          cln
          clv
          sbrc r20, 7
          sen
          sbrc r20, 6
          sev
L801d:    brmi 1f                       ; BMI $803d
          sbrc r19, 0
1:        rjmp L803d
L801f:    brvc 1f                       ; BVC $8052
          sbrc r19, 0
1:        rjmp L8052
L8021:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L8023:    sts ram+0x00fa, r16           ; STA $84fa
L8026:    ldi r17, 0x02                 ; LDX #$02
          tst r17
L8028:    ldi r26,lo8(ram+0x00c4)       ; STA $84c4,X
          ldi r27,hi8(ram+0x00c4)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L802b:    ldi r26,lo8(ram+0x00c7)       ; STA $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L802e:    ldi r26,lo8(ram+0x00ca)       ; STA $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L8031:    ldi r26,lo8(ram+0x00d3)       ; STA $84d3,X
          ldi r27,hi8(ram+0x00d3)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L8034:    dec r17                       ; DEX
L8035:    brpl L8028                    ; BPL $8028
L8037:    sts ram+0x00ee, r16           ; STA $84ee
L803a:    rjmp L8052                    ; JMP $8052
L803d:    brvc L804f                    ; BVC $804f
L803f:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L8041:    mov r20, r16                  ; STA $d404 (SID)
          ldi r21, 0x04
          rcall sid_write
L8044:    mov r20, r16                  ; STA $d40b (SID)
          ldi r21, 0x0b
          rcall sid_write
L8047:    mov r20, r16                  ; STA $d412 (SID)
          ldi r21, 0x12
          rcall sid_write
L804a:    ldi r16, 0x80                 ; LDA #$80
          tst r16
L804c:    sts ram+0x00ee, r16           ; STA $84ee
L804f:    rjmp L837d                    ; JMP $837d
L8052:    ldi r17, 0x02                 ; LDX #$02
          tst r17
L8054:    lds r20, ram+0x00eb           ; DEC $84eb
          dec r20
          sts ram+0x00eb, r20
L8057:    brpl L805f                    ; BPL $805f
L8059:    lds r16, ram+0x00ec           ; LDA $84ec
          tst r16
L805c:    sts ram+0x00eb, r16           ; STA $84eb
L805f:    ldi r26,lo8(ram+0x00c0)       ; LDA $84c0,X
          ldi r27,hi8(ram+0x00c0)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8062:    sts ram+0x00c3, r16           ; STA $84c3
L8065:    mov r18, r16                  ; TAY
L8066:    lds r16, ram+0x00eb           ; LDA $84eb
          tst r16
L8069:    lds r20, ram+0x00ec           ; CMP $84ec
          cp r16, r20
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L806c:    brne 1f                       ; BNE $8083
          sbrc r19, 0
1:        rjmp L8083
L806e:    ldi r26,lo8(ram+0x0166)       ; LDA $8566,X
          ldi r27,hi8(ram+0x0166)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8071:    sts zero+0x02, r16            ; STA $02
L8073:    ldi r26,lo8(ram+0x0169)       ; LDA $8569,X
          ldi r27,hi8(ram+0x0169)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8076:    sts zero+0x03, r16            ; STA $03
L8078:    ldi r26,lo8(ram+0x00ca)       ; DEC $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          dec r20
          st X, r20
L807b:    brmi L8086                    ; BMI $8086
L807d:    rjmp L8174                    ; JMP $8174
L8080:    rjmp L8367                    ; JMP $8367
L8083:    rjmp L819b                    ; JMP $819b
L8086:    ldi r26,lo8(ram+0x00c4)       ; LDY $84c4,X
          ldi r27,hi8(ram+0x00c4)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r18, X
L8089:    lds r26,zero+0x02             ; LDA ($02),Y
          lds r27,zero+0x02+1
          in r22, 0x3f
          subi r26,lo8(0x8400)
          sbci r27,hi8(0x8400)
          subi r26,lo8(-(ram))
          sbci r27,hi8(-(ram))
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L808b:    cpi r16, 0xff                 ; CMP #$ff
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L808d:    breq L8099                    ; BEQ $8099
L808f:    cpi r16, 0xfe                 ; CMP #$fe
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L8091:    brne 1f                       ; BNE $80aa
          sbrc r19, 0
1:        rjmp L80aa
L8093:                                  ; NOP
L8094:                                  ; NOP
L8095:                                  ; NOP
L8096:    rjmp L837d                    ; JMP $837d
L8099:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L809b:    ldi r26,lo8(ram+0x00ca)       ; STA $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L809e:    ldi r26,lo8(ram+0x00c4)       ; STA $84c4,X
          ldi r27,hi8(ram+0x00c4)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80a1:    ldi r26,lo8(ram+0x00c7)       ; STA $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80a4:    rjmp L8086                    ; JMP $8086
L80a7:    rjmp L8367                    ; JMP $8367
L80aa:    mov r18, r16                  ; TAY
L80ab:    ldi r26,lo8(ram+0x017e)       ; LDA $857e,Y
          ldi r27,hi8(ram+0x017e)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80ae:    sts zero+0x04, r16            ; STA $04
L80b0:    ldi r26,lo8(ram+0x01cb)       ; LDA $85cb,Y
          ldi r27,hi8(ram+0x01cb)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80b3:    sts zero+0x05, r16            ; STA $05
L80b5:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L80b7:    ldi r26,lo8(ram+0x00f5)       ; STA $84f5,X
          ldi r27,hi8(ram+0x00f5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80ba:    ldi r26,lo8(ram+0x00c7)       ; LDY $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r18, X
L80bd:    ldi r16, 0xff                 ; LDA #$ff
          tst r16
L80bf:    sts ram+0x00d9, r16           ; STA $84d9
L80c2:    lds r26,zero+0x04             ; LDA ($04),Y
          lds r27,zero+0x04+1
          in r22, 0x3f
          subi r26,lo8(0x8400)
          sbci r27,hi8(0x8400)
          subi r26,lo8(-(ram))
          sbci r27,hi8(-(ram))
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80c4:    ldi r26,lo8(ram+0x00cd)       ; STA $84cd,X
          ldi r27,hi8(ram+0x00cd)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80c7:    sts ram+0x00da, r16           ; STA $84da
L80ca:    andi r16, 0x1f                ; AND #$1f
L80cc:    ldi r26,lo8(ram+0x00ca)       ; STA $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80cf:    lds r20, ram+0x00da           ; BIT $84da
          mov r21, r20
          and r21, r16
          cln
          clv
          sbrc r20, 7
          sen
          sbrc r20, 6
          sev
L80d2:    brvs 1f                       ; BVS $8118
          sbrc r19, 0
1:        rjmp L8118
L80d4:    ldi r26,lo8(ram+0x00c7)       ; INC $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          inc r20
          st X, r20
L80d7:    lds r16, ram+0x00da           ; LDA $84da
          tst r16
L80da:    brpl 1f                       ; BPL $80ed
          sbrc r19, 0
1:        rjmp L80ed
L80dc:    inc r18                       ; INY
L80dd:    lds r26,zero+0x04             ; LDA ($04),Y
          lds r27,zero+0x04+1
          in r22, 0x3f
          subi r26,lo8(0x8400)
          sbci r27,hi8(0x8400)
          subi r26,lo8(-(ram))
          sbci r27,hi8(-(ram))
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80df:    brpl L80e7                    ; BPL $80e7
L80e1:    ldi r26,lo8(ram+0x00f5)       ; STA $84f5,X
          ldi r27,hi8(ram+0x00f5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80e4:    rjmp L80ea                    ; JMP $80ea
L80e7:    ldi r26,lo8(ram+0x00d6)       ; STA $84d6,X
          ldi r27,hi8(ram+0x00d6)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80ea:    ldi r26,lo8(ram+0x00c7)       ; INC $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          inc r20
          st X, r20
L80ed:    inc r18                       ; INY
L80ee:    lds r26,zero+0x04             ; LDA ($04),Y
          lds r27,zero+0x04+1
          in r22, 0x3f
          subi r26,lo8(0x8400)
          sbci r27,hi8(0x8400)
          subi r26,lo8(-(ram))
          sbci r27,hi8(-(ram))
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80f0:    ldi r26,lo8(ram+0x00d3)       ; STA $84d3,X
          ldi r27,hi8(ram+0x00d3)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L80f3:    lsl r16                       ; ASL
L80f4:    mov r18, r16                  ; TAY
L80f5:    lds r16, ram+0x00fd           ; LDA $84fd
          tst r16
L80f8:    brpl 1f                       ; BPL $811b
          sbrc r19, 0
1:        rjmp L811b
L80fa:    ldi r26,lo8(ram+0x0000)       ; LDA $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L80fd:    sts ram+0x00db, r16           ; STA $84db
L8100:    ldi r26,lo8(ram+0x0001)       ; LDA $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8103:    lds r18, ram+0x00c3           ; LDY $84c3
          tst r18
L8106:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8109:    ldi r26,lo8(ram+0x00ef)       ; STA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L810c:    lds r16, ram+0x00db           ; LDA $84db
          tst r16
L810f:    mov r20, r16                  ; STA $d400,Y (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8112:    ldi r26,lo8(ram+0x00f2)       ; STA $84f2,X
          ldi r27,hi8(ram+0x00f2)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L8115:    rjmp L811b                    ; JMP $811b
L8118:    lds r20, ram+0x00d9           ; DEC $84d9
          dec r20
          sts ram+0x00d9, r20
L811b:    lds r18, ram+0x00c3           ; LDY $84c3
L811e:    ldi r26,lo8(ram+0x00d6)       ; LDA $84d6,X
          ldi r27,hi8(ram+0x00d6)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8121:    sts ram+0x00dc, r17           ; STX $84dc
L8124:    lsl r16                       ; ASL
L8125:    lsl r16                       ; ASL
L8126:    lsl r16                       ; ASL
L8127:    mov r17, r16                  ; TAX
L8128:    ldi r26,lo8(ram+0x0fb6)       ; LDA $93b6,X
          ldi r27,hi8(ram+0x0fb6)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L812b:    sts ram+0x00dd, r16           ; STA $84dd
L812e:    lds r16, ram+0x00fd           ; LDA $84fd
          tst r16
L8131:    brpl 1f                       ; BPL $8154
          sbrc r19, 0
1:        rjmp L8154
L8133:    ldi r26,lo8(ram+0x0fb6)       ; LDA $93b6,X
          ldi r27,hi8(ram+0x0fb6)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L8136:    lds r20, ram+0x00d9           ; AND $84d9
          and r16, r20
L8139:    mov r20, r16                  ; STA $d404,Y (SID)
          ldi r21, 0x04
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L813c:    ldi r26,lo8(ram+0x0fb4)       ; LDA $93b4,X
          ldi r27,hi8(ram+0x0fb4)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L813f:    mov r20, r16                  ; STA $d402,Y (SID)
          ldi r21, 0x02
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8142:    ldi r26,lo8(ram+0x0fb5)       ; LDA $93b5,X
          ldi r27,hi8(ram+0x0fb5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8145:    mov r20, r16                  ; STA $d403,Y (SID)
          ldi r21, 0x03
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8148:    ldi r26,lo8(ram+0x0fb7)       ; LDA $93b7,X
          ldi r27,hi8(ram+0x0fb7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L814b:    mov r20, r16                  ; STA $d405,Y (SID)
          ldi r21, 0x05
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L814e:    ldi r26,lo8(ram+0x0fb8)       ; LDA $93b8,X
          ldi r27,hi8(ram+0x0fb8)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8151:    mov r20, r16                  ; STA $d406,Y (SID)
          ldi r21, 0x06
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8154:    lds r17, ram+0x00dc           ; LDX $84dc
L8157:    lds r16, ram+0x00dd           ; LDA $84dd
          tst r16
L815a:    ldi r26,lo8(ram+0x00d0)       ; STA $84d0,X
          ldi r27,hi8(ram+0x00d0)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L815d:    ldi r26,lo8(ram+0x00c7)       ; INC $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          inc r20
          st X, r20
L8160:    ldi r26,lo8(ram+0x00c7)       ; LDY $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r18, X
L8163:    lds r26,zero+0x04             ; LDA ($04),Y
          lds r27,zero+0x04+1
          in r22, 0x3f
          subi r26,lo8(0x8400)
          sbci r27,hi8(0x8400)
          subi r26,lo8(-(ram))
          sbci r27,hi8(-(ram))
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8165:    cpi r16, 0xff                 ; CMP #$ff
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L8167:    brne L8171                    ; BNE $8171
L8169:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L816b:    ldi r26,lo8(ram+0x00c7)       ; STA $84c7,X
          ldi r27,hi8(ram+0x00c7)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L816e:    ldi r26,lo8(ram+0x00c4)       ; INC $84c4,X
          ldi r27,hi8(ram+0x00c4)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          inc r20
          st X, r20
L8171:    rjmp L8367                    ; JMP $8367
L8174:    lds r16, ram+0x00fd           ; LDA $84fd
          tst r16
L8177:    brmi L817c                    ; BMI $817c
L8179:    rjmp L8367                    ; JMP $8367
L817c:    lds r18, ram+0x00c3           ; LDY $84c3
L817f:    ldi r26,lo8(ram+0x00cd)       ; LDA $84cd,X
          ldi r27,hi8(ram+0x00cd)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L8182:    andi r16, 0x20                ; AND #$20
L8184:    brne 1f                       ; BNE $819b
          sbrc r19, 0
1:        rjmp L819b
L8186:    ldi r26,lo8(ram+0x00ca)       ; LDA $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8189:    brne L819b                    ; BNE $819b
L818b:    ldi r26,lo8(ram+0x00d0)       ; LDA $84d0,X
          ldi r27,hi8(ram+0x00d0)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L818e:    andi r16, 0xfe                ; AND #$fe
L8190:    mov r20, r16                  ; STA $d404,Y (SID)
          ldi r21, 0x04
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8193:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L8195:    mov r20, r16                  ; STA $d405,Y (SID)
          ldi r21, 0x05
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8198:    mov r20, r16                  ; STA $d406,Y (SID)
          ldi r21, 0x06
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L819b:    lds r16, ram+0x00fd           ; LDA $84fd
          tst r16
L819e:    brmi L81a3                    ; BMI $81a3
L81a0:    rjmp L8367                    ; JMP $8367
L81a3:    ldi r26,lo8(ram+0x00d6)       ; LDA $84d6,X
          ldi r27,hi8(ram+0x00d6)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L81a6:    lsl r16                       ; ASL
L81a7:    lsl r16                       ; ASL
L81a8:    lsl r16                       ; ASL
L81a9:    mov r18, r16                  ; TAY
          tst r18
L81aa:    sts ram+0x00ed, r18           ; STY $84ed
L81ad:    ldi r26,lo8(ram+0x0fbb)       ; LDA $93bb,Y
          ldi r27,hi8(ram+0x0fbb)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L81b0:    sts ram+0x00f8, r16           ; STA $84f8
L81b3:    ldi r26,lo8(ram+0x0fba)       ; LDA $93ba,Y
          ldi r27,hi8(ram+0x0fba)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L81b6:    sts ram+0x00df, r16           ; STA $84df
L81b9:    ldi r26,lo8(ram+0x0fb9)       ; LDA $93b9,Y
          ldi r27,hi8(ram+0x0fb9)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L81bc:    sts ram+0x00de, r16           ; STA $84de
L81bf:    breq 1f                       ; BEQ $8230
          sbrc r19, 0
1:        rjmp L8230
L81c1:    lds r16, ram+0x00fa           ; LDA $84fa
L81c4:    andi r16, 0x07                ; AND #$07
L81c6:    cpi r16, 0x04                 ; CMP #$04
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L81c8:    brcc L81cc                    ; BCS $81cc
L81ca:    ldi r20, 0x07                 ; EOR #$07
          eor r16, r20
L81cc:    sts ram+0x00e4, r16           ; STA $84e4
L81cf:    ldi r26,lo8(ram+0x00d3)       ; LDA $84d3,X
          ldi r27,hi8(ram+0x00d3)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L81d2:    lsl r16                       ; ASL
L81d3:    mov r18, r16                  ; TAY
          tst r18
L81d4:    sec                           ; SEC
L81d5:    ldi r26,lo8(ram+0x0002)       ; LDA $8402,Y
          ldi r27,hi8(ram+0x0002)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L81d8:    ldi r26,lo8(ram+0x0000)       ; SBC $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          ld r20, X
          out 0x3f, r22
          sbc r16, r20
L81db:    sts ram+0x00e0, r16           ; STA $84e0
L81de:    ldi r26,lo8(ram+0x0003)       ; LDA $8403,Y
          ldi r27,hi8(ram+0x0003)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L81e1:    ldi r26,lo8(ram+0x0001)       ; SBC $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          ld r20, X
          out 0x3f, r22
          sbc r16, r20
L81e4:    lsr r16                       ; LSR
L81e5:    lds r20, ram+0x00e0           ; ROR $84e0
          ror r20
          sts ram+0x00e0, r20
L81e8:    lds r20, ram+0x00de           ; DEC $84de
          dec r20
          sts ram+0x00de, r20
L81eb:    brpl L81e4                    ; BPL $81e4
L81ed:    sts ram+0x00e1, r16           ; STA $84e1
L81f0:    ldi r26,lo8(ram+0x0000)       ; LDA $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L81f3:    sts ram+0x00e2, r16           ; STA $84e2
L81f6:    ldi r26,lo8(ram+0x0001)       ; LDA $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L81f9:    sts ram+0x00e3, r16           ; STA $84e3
L81fc:    ldi r26,lo8(ram+0x00cd)       ; LDA $84cd,X
          ldi r27,hi8(ram+0x00cd)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L81ff:    andi r16, 0x1f                ; AND #$1f
L8201:    cpi r16, 0x08                 ; CMP #$08
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L8203:    brcc 1f                       ; BCC $8221
          sbrc r19, 0
1:        rjmp L8221
L8205:    lds r18, ram+0x00e4           ; LDY $84e4
          tst r18
L8208:    dec r18                       ; DEY
L8209:    brmi 1f                       ; BMI $8221
          sbrc r19, 0
1:        rjmp L8221
L820b:    clc                           ; CLC
L820c:    lds r16, ram+0x00e2           ; LDA $84e2
L820f:    lds r20, ram+0x00e0           ; ADC $84e0
          adc r16, r20
L8212:    sts ram+0x00e2, r16           ; STA $84e2
L8215:    lds r16, ram+0x00e3           ; LDA $84e3
L8218:    lds r20, ram+0x00e1           ; ADC $84e1
          adc r16, r20
L821b:    sts ram+0x00e3, r16           ; STA $84e3
L821e:    rjmp L8208                    ; JMP $8208
L8221:    lds r18, ram+0x00c3           ; LDY $84c3
L8224:    lds r16, ram+0x00e2           ; LDA $84e2
          tst r16
L8227:    mov r20, r16                  ; STA $d400,Y (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L822a:    lds r16, ram+0x00e3           ; LDA $84e3
          tst r16
L822d:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8230:    lds r16, ram+0x00df           ; LDA $84df
          tst r16
L8233:    breq 1f                       ; BEQ $8297
          sbrc r19, 0
1:        rjmp L8297
L8235:    lds r18, ram+0x00ed           ; LDY $84ed
L8238:    andi r16, 0x1f                ; AND #$1f
L823a:    ldi r26,lo8(ram+0x00e5)       ; DEC $84e5,X
          ldi r27,hi8(ram+0x00e5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          dec r20
          st X, r20
L823d:    brpl 1f                       ; BPL $8297
          sbrc r19, 0
1:        rjmp L8297
L823f:    ldi r26,lo8(ram+0x00e5)       ; STA $84e5,X
          ldi r27,hi8(ram+0x00e5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L8242:    lds r16, ram+0x00df           ; LDA $84df
L8245:    andi r16, 0xe0                ; AND #$e0
L8247:    sts ram+0x00f9, r16           ; STA $84f9
L824a:    ldi r26,lo8(ram+0x00e8)       ; LDA $84e8,X
          ldi r27,hi8(ram+0x00e8)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L824d:    brne 1f                       ; BNE $8269
          sbrc r19, 0
1:        rjmp L8269
L824f:    lds r16, ram+0x00f9           ; LDA $84f9
          tst r16
L8252:    clc                           ; CLC
L8253:    ldi r26,lo8(ram+0x0fb4)       ; ADC $93b4,Y
          ldi r27,hi8(ram+0x0fb4)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          ld r20, X
          out 0x3f, r22
          adc r16, r20
L8256:    push r16                      ; PHA
L8257:    ldi r26,lo8(ram+0x0fb5)       ; LDA $93b5,Y
          ldi r27,hi8(ram+0x0fb5)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L825a:    ldi r20, 0x00                 ; ADC #$00
          adc r16, r20
L825c:    andi r16, 0x0f                ; AND #$0f
L825e:    push r16                      ; PHA
L825f:    cpi r16, 0x0e                 ; CMP #$0e
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L8261:    brne 1f                       ; BNE $8280
          sbrc r19, 0
1:        rjmp L8280
L8263:    ldi r26,lo8(ram+0x00e8)       ; INC $84e8,X
          ldi r27,hi8(ram+0x00e8)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          inc r20
          st X, r20
L8266:    rjmp L8280                    ; JMP $8280
L8269:    sec                           ; SEC
L826a:    ldi r26,lo8(ram+0x0fb4)       ; LDA $93b4,Y
          ldi r27,hi8(ram+0x0fb4)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L826d:    lds r20, ram+0x00f9           ; SBC $84f9
          sbc r16, r20
L8270:    push r16                      ; PHA
L8271:    ldi r26,lo8(ram+0x0fb5)       ; LDA $93b5,Y
          ldi r27,hi8(ram+0x0fb5)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L8274:    sbci r16, 0x00                ; SBC #$00
L8276:    andi r16, 0x0f                ; AND #$0f
L8278:    push r16                      ; PHA
L8279:    cpi r16, 0x08                 ; CMP #$08
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L827b:    brne L8280                    ; BNE $8280
L827d:    ldi r26,lo8(ram+0x00e8)       ; DEC $84e8,X
          ldi r27,hi8(ram+0x00e8)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          dec r20
          st X, r20
L8280:    sts ram+0x00dc, r17           ; STX $84dc
L8283:    lds r17, ram+0x00c3           ; LDX $84c3
          tst r17
L8286:    pop r16                       ; PLA
          tst r16
L8287:    ldi r26,lo8(ram+0x0fb5)       ; STA $93b5,Y
          ldi r27,hi8(ram+0x0fb5)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          st X, r16
L828a:    mov r20, r16                  ; STA $d403,X (SID)
          ldi r21, 0x03
          in r22, 0x3f
          add r21, r17
          out 0x3f, r22
          rcall sid_write
L828d:    pop r16                       ; PLA
          tst r16
L828e:    ldi r26,lo8(ram+0x0fb4)       ; STA $93b4,Y
          ldi r27,hi8(ram+0x0fb4)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          st X, r16
L8291:    mov r20, r16                  ; STA $d402,X (SID)
          ldi r21, 0x02
          in r22, 0x3f
          add r21, r17
          out 0x3f, r22
          rcall sid_write
L8294:    lds r17, ram+0x00dc           ; LDX $84dc
          tst r17
L8297:    lds r18, ram+0x00c3           ; LDY $84c3
L829a:    ldi r26,lo8(ram+0x00f5)       ; LDA $84f5,X
          ldi r27,hi8(ram+0x00f5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L829d:    breq 1f                       ; BEQ $82de
          sbrc r19, 0
1:        rjmp L82de
L829f:    andi r16, 0x7e                ; AND #$7e
L82a1:    sts ram+0x00dc, r16           ; STA $84dc
L82a4:    ldi r26,lo8(ram+0x00f5)       ; LDA $84f5,X
          ldi r27,hi8(ram+0x00f5)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82a7:    andi r16, 0x01                ; AND #$01
L82a9:    breq 1f                       ; BEQ $82c6
          sbrc r19, 0
1:        rjmp L82c6
L82ab:    sec                           ; SEC
L82ac:    ldi r26,lo8(ram+0x00f2)       ; LDA $84f2,X
          ldi r27,hi8(ram+0x00f2)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82af:    lds r20, ram+0x00dc           ; SBC $84dc
          sbc r16, r20
L82b2:    ldi r26,lo8(ram+0x00f2)       ; STA $84f2,X
          ldi r27,hi8(ram+0x00f2)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L82b5:    mov r20, r16                  ; STA $d400,Y (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L82b8:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82bb:    sbci r16, 0x00                ; SBC #$00
L82bd:    ldi r26,lo8(ram+0x00ef)       ; STA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L82c0:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L82c3:    rjmp L82de                    ; JMP $82de
L82c6:    clc                           ; CLC
L82c7:    ldi r26,lo8(ram+0x00f2)       ; LDA $84f2,X
          ldi r27,hi8(ram+0x00f2)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82ca:    lds r20, ram+0x00dc           ; ADC $84dc
          adc r16, r20
L82cd:    ldi r26,lo8(ram+0x00f2)       ; STA $84f2,X
          ldi r27,hi8(ram+0x00f2)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L82d0:    mov r20, r16                  ; STA $d400,Y (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L82d3:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82d6:    ldi r20, 0x00                 ; ADC #$00
          adc r16, r20
L82d8:    ldi r26,lo8(ram+0x00ef)       ; STA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          st X, r16
L82db:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L82de:    lds r16, ram+0x00f8           ; LDA $84f8
L82e1:    andi r16, 0x01                ; AND #$01
L82e3:    breq 1f                       ; BEQ $831a
          sbrc r19, 0
1:        rjmp L831a
L82e5:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L82e8:    breq 1f                       ; BEQ $831a
          sbrc r19, 0
1:        rjmp L831a
L82ea:    ldi r26,lo8(ram+0x00ca)       ; LDA $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L82ed:    breq 1f                       ; BEQ $831a
          sbrc r19, 0
1:        rjmp L831a
L82ef:    ldi r26,lo8(ram+0x00cd)       ; LDA $84cd,X
          ldi r27,hi8(ram+0x00cd)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L82f2:    andi r16, 0x1f                ; AND #$1f
L82f4:    sec                           ; SEC
L82f5:    sbci r16, 0x01                ; SBC #$01
L82f7:    ldi r26,lo8(ram+0x00ca)       ; CMP $84ca,X
          ldi r27,hi8(ram+0x00ca)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          cp r16, r20
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L82fa:    lds r18, ram+0x00c3           ; LDY $84c3
          tst r18
L82fd:    brcc L830f                    ; BCS $830f
L82ff:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8302:    ldi r26,lo8(ram+0x00ef)       ; DEC $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          dec r20
          st X, r20
L8305:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8308:    ldi r26,lo8(ram+0x00d0)       ; LDA $84d0,X
          ldi r27,hi8(ram+0x00d0)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L830b:    andi r16, 0xfe                ; AND #$fe
L830d:    brne L8317                    ; BNE $8317
L830f:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8312:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8315:    ldi r16, 0x80                 ; LDA #$80
          tst r16
L8317:    mov r20, r16                  ; STA $d404,Y (SID)
          ldi r21, 0x04
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L831a:    lds r16, ram+0x00f8           ; LDA $84f8
L831d:    andi r16, 0x02                ; AND #$02
L831f:    breq 1f                       ; BEQ $8336
          sbrc r19, 0
1:        rjmp L8336
L8321:    lds r16, ram+0x00fa           ; LDA $84fa
L8324:    andi r16, 0x01                ; AND #$01
L8326:    breq L8336                    ; BEQ $8336
L8328:    ldi r26,lo8(ram+0x00ef)       ; LDA $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L832b:    breq L8336                    ; BEQ $8336
L832d:    ldi r26,lo8(ram+0x00ef)       ; DEC $84ef,X
          ldi r27,hi8(ram+0x00ef)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r20, X
          dec r20
          st X, r20
L8330:    lds r18, ram+0x00c3           ; LDY $84c3
          tst r18
L8333:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8336:    lds r16, ram+0x00f8           ; LDA $84f8
L8339:    andi r16, 0x04                ; AND #$04
L833b:    breq 1f                       ; BEQ $8367
          sbrc r19, 0
1:        rjmp L8367
L833d:    lds r16, ram+0x00fa           ; LDA $84fa
L8340:    andi r16, 0x01                ; AND #$01
L8342:    breq L834d                    ; BEQ $834d
L8344:    ldi r26,lo8(ram+0x00d3)       ; LDA $84d3,X
          ldi r27,hi8(ram+0x00d3)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8347:    clc                           ; CLC
L8348:    ldi r20, 0x0c                 ; ADC #$0c
          adc r16, r20
L834a:    rjmp L8350                    ; JMP $8350
L834d:    ldi r26,lo8(ram+0x00d3)       ; LDA $84d3,X
          ldi r27,hi8(ram+0x00d3)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
L8350:    lsl r16                       ; ASL
L8351:    mov r18, r16                  ; TAY
L8352:    ldi r26,lo8(ram+0x0000)       ; LDA $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8355:    sts ram+0x00db, r16           ; STA $84db
L8358:    ldi r26,lo8(ram+0x0001)       ; LDA $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L835b:    lds r18, ram+0x00c3           ; LDY $84c3
          tst r18
L835e:    mov r20, r16                  ; STA $d401,Y (SID)
          ldi r21, 0x01
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
L8361:    lds r16, ram+0x00db           ; LDA $84db
          tst r16
L8364:    mov r20, r16                  ; STA $d400,Y (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r18
          out 0x3f, r22
          rcall sid_write
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
L838a:    brpl L838d                    ; BPL $838d
L838c:    ret                           ; RTS
L838d:    brvc L8392                    ; BVC $8392
L838f:    rcall L8506                   ; JSR $8506
L8392:    lds r20, ram+0x00ff           ; DEC $84ff
          dec r20
          sts ram+0x00ff, r20
L8395:    brpl L838c                    ; BPL $838c
L8397:    lds r16, ram+0x0105           ; LDA $8505
L839a:    andi r16, 0x0f                ; AND #$0f
L839c:    sts ram+0x00ff, r16           ; STA $84ff
L839f:    lds r16, ram+0x00fe           ; LDA $84fe
          tst r16
L83a2:    lds r20, ram+0x0100           ; CMP $8500
          cp r16, r20
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L83a5:    brne L83b6                    ; BNE $83b6
L83a7:    ldi r17, 0x00                 ; LDX #$00
          tst r17
L83a9:    mov r20, r17                  ; STX $d404 (SID)
          ldi r21, 0x04
          rcall sid_write
L83ac:    mov r20, r17                  ; STX $d40b (SID)
          ldi r21, 0x0b
          rcall sid_write
L83af:    dec r17                       ; DEX
L83b0:    sts ram+0x00fc, r17           ; STX $84fc
L83b3:    rjmp L838c                    ; JMP $838c
L83b6:    lds r20, ram+0x00fe           ; DEC $84fe (SELF MODIFYING)
          lds r21, zero+0x00
          cpi r21, 0xce
          breq 1f
          inc r20
          sbrc r19, 0
1:        dec r20
          sts ram+0x00fe, r20
L83b9:    lsl r16                       ; ASL
L83ba:    mov r18, r16                  ; TAY
          tst r18
L83bb:    lds r20, ram+0x0105           ; BIT $8505
          mov r21, r20
          and r21, r16
          cln
          clv
          sbrc r20, 7
          sen
          sbrc r20, 6
          sev
L83be:    brmi 1f                       ; BMI $83e0
          sbrc r19, 0
1:        rjmp L83e0
L83c0:    brvs L83ce                    ; BVS $83ce
L83c2:    ldi r26,lo8(ram+0x0000)       ; LDA $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L83c5:    mov r20, r16                  ; STA $d400 (SID)
          ldi r21, 0x00
          rcall sid_write
L83c8:    ldi r26,lo8(ram+0x0001)       ; LDA $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L83cb:    mov r20, r16                  ; STA $d401 (SID)
          ldi r21, 0x01
          rcall sid_write
L83ce:    mov r16, r18                  ; TYA
          tst r16
L83cf:    sec                           ; SEC
L83d0:    lds r20, ram+0x0101           ; SBC $8501
          sbc r16, r20
L83d3:    mov r18, r16                  ; TAY
L83d4:    ldi r26,lo8(ram+0x0000)       ; LDA $8400,Y
          ldi r27,hi8(ram+0x0000)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L83d7:    mov r20, r16                  ; STA $d407 (SID)
          ldi r21, 0x07
          rcall sid_write
L83da:    ldi r26,lo8(ram+0x0001)       ; LDA $8401,Y
          ldi r27,hi8(ram+0x0001)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L83dd:    mov r20, r16                  ; STA $d408 (SID)
          ldi r21, 0x08
          rcall sid_write
L83e0:    lds r20, ram+0x0102           ; BIT $8502
          mov r21, r20
          and r21, r16
          cln
          clv
          sbrc r20, 7
          sen
          sbrc r20, 6
          sev
L83e3:    brpl L83f0                    ; BPL $83f0
L83e5:    lds r16, ram+0x0103           ; LDA $8503
          tst r16
L83e8:    ldi r20, 0x01                 ; EOR #$01
          eor r16, r20
L83ea:    mov r20, r16                  ; STA $d404 (SID)
          ldi r21, 0x04
          rcall sid_write
L83ed:    sts ram+0x0103, r16           ; STA $8503
L83f0:    brvc L83fd                    ; BVC $83fd
L83f2:    lds r16, ram+0x0104           ; LDA $8504
          tst r16
L83f5:    ldi r20, 0x01                 ; EOR #$01
          eor r16, r20
L83f7:    mov r20, r16                  ; STA $d40b (SID)
          ldi r21, 0x0b
          rcall sid_write
L83fa:    sts ram+0x0104, r16           ; STA $8504
L83fd:    rjmp L838c                    ; JMP $838c

          ; transcode 8506 - 8566

L8506:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L8508:    mov r20, r16                  ; STA $d404 (SID)
          ldi r21, 0x04
          rcall sid_write
L850b:    mov r20, r16                  ; STA $d40b (SID)
          ldi r21, 0x0b
          rcall sid_write
L850e:    sts ram+0x00ff, r16           ; STA $84ff
L8511:    lds r16, ram+0x00fc           ; LDA $84fc
L8514:    andi r16, 0x0f                ; AND #$0f
L8516:    sts ram+0x00fc, r16           ; STA $84fc
L8519:    lsl r16                       ; ASL
L851a:    lsl r16                       ; ASL
L851b:    lsl r16                       ; ASL
L851c:    lsl r16                       ; ASL
L851d:    mov r18, r16                  ; TAY
L851e:    ldi r26,lo8(ram+0x1054)       ; LDA $9454,Y
          ldi r27,hi8(ram+0x1054)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8521:    sts ram+0x0105, r16           ; STA $8505
L8524:    ldi r26,lo8(ram+0x1055)       ; LDA $9455,Y
          ldi r27,hi8(ram+0x1055)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8527:    sts ram+0x00fe, r16           ; STA $84fe
L852a:    ldi r26,lo8(ram+0x1063)       ; LDA $9463,Y
          ldi r27,hi8(ram+0x1063)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L852d:    sts ram+0x0100, r16           ; STA $8500
L8530:    ldi r26,lo8(ram+0x105c)       ; LDA $945c,Y
          ldi r27,hi8(ram+0x105c)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8533:    sts ram+0x0102, r16           ; STA $8502
L8536:    andi r16, 0x3f                ; AND #$3f
L8538:    sts ram+0x0101, r16           ; STA $8501
L853b:    ldi r26,lo8(ram+0x1059)       ; LDA $9459,Y
          ldi r27,hi8(ram+0x1059)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L853e:    sts ram+0x0103, r16           ; STA $8503
L8541:    ldi r26,lo8(ram+0x1060)       ; LDA $9460,Y
          ldi r27,hi8(ram+0x1060)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L8544:    sts ram+0x0104, r16           ; STA $8504
L8547:    ldi r17, 0x00                 ; LDX #$00
L8549:    ldi r26,lo8(ram+0x1055)       ; LDA $9455,Y
          ldi r27,hi8(ram+0x1055)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L854c:    mov r20, r16                  ; STA $d400,X (SID)
          ldi r21, 0x00
          in r22, 0x3f
          add r21, r17
          out 0x3f, r22
          rcall sid_write
L854f:    inc r18                       ; INY
L8550:    inc r17                       ; INX
L8551:    cpi r17, 0x0e                 ; CPX #$0e
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L8553:    brne L8549                    ; BNE $8549
L8555:    lds r16, ram+0x0105           ; LDA $8505
L8558:    andi r16, 0x30                ; AND #$30
L855a:    ldi r18, 0xee                 ; LDY #$ee
          tst r18
L855c:    cpi r16, 0x20                 ; CMP #$20
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L855e:    breq L8562                    ; BEQ $8562
L8560:    ldi r18, 0xce                 ; LDY #$ce
          tst r18
L8562:    sts zero+0x00, r18            ; STY $83b6 (SELF MODIFYING)
L8565:    ret                           ; RTS

          ; transcode 9554 - 95b6

L9554:    ldi r18, 0x00                 ; LDY #$00
L9556:    lsl r16                       ; ASL
L9557:    sts ram+0x00dc, r16           ; STA $84dc
L955a:    lsl r16                       ; ASL
L955b:    clc                           ; CLC
L955c:    lds r20, ram+0x00dc           ; ADC $84dc
          adc r16, r20
L955f:    mov r17, r16                  ; TAX
L9560:    ldi r26,lo8(ram+0x016c)       ; LDA $856c,X
          ldi r27,hi8(ram+0x016c)
          in r22, 0x3f
          add r26,r17
          adc r27,r19
          out 0x3f, r22
          ld r16, X
          tst r16
L9563:    ldi r26,lo8(ram+0x0166)       ; STA $8566,Y
          ldi r27,hi8(ram+0x0166)
          in r22, 0x3f
          add r26,r18
          adc r27,r19
          out 0x3f, r22
          st X, r16
L9566:    inc r17                       ; INX
L9567:    inc r18                       ; INY
L9568:    cpi r18, 0x06                 ; CPY #$06
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L956a:    brne L9560                    ; BNE $9560
L956c:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L956e:    mov r20, r16                  ; STA $d404 (SID)
          ldi r21, 0x04
          rcall sid_write
L9571:    mov r20, r16                  ; STA $d40b (SID)
          ldi r21, 0x0b
          rcall sid_write
L9574:    mov r20, r16                  ; STA $d412 (SID)
          ldi r21, 0x12
          rcall sid_write
L9577:    ldi r16, 0x40                 ; LDA #$40
          tst r16
L9579:    sts ram+0x00ee, r16           ; STA $84ee
L957c:    ret                           ; RTS
L957d:    ldi r16, 0xc0                 ; LDA #$c0
          tst r16
L957f:    sts ram+0x00ee, r16           ; STA $84ee
L9582:    ret                           ; RTS
L9583:    ldi r16, 0x00                 ; LDA #$00
          tst r16
L9585:    sts ram+0x00fb, r16           ; STA $84fb
L9588:    ret                           ; RTS
L9589:    ldi r16, 0xff                 ; LDA #$ff
          tst r16
L958b:    sts ram+0x00fb, r16           ; STA $84fb
L958e:    rjmp L83a7                    ; JMP $83a7
L9591:    lds r17, ram+0x00fb           ; LDX $84fb
          tst r17
L9594:    breq L959a                    ; BEQ $959a
L9596:    sts ram+0x00fc, r17           ; STX $84fc
L9599:    ret                           ; RTS
L959a:    ori r16, 0x40                 ; ORA #$40
L959c:    sts ram+0x00fc, r16           ; STA $84fc
L959f:    ret                           ; RTS
L95a0:    sts ram+0x11bf, r16           ; STA $95bf
L95a3:    cpi r16, 0x03                 ; CMP #$03
          in r22, 0x3f
          eor r22, r23
          out 0x3f, r22
L95a5:    brcs L95aa                    ; BCS $95aa
L95a7:    rjmp L9554                    ; JMP $9554
L95aa:    sec                           ; SEC
L95ab:    sbci r16, 0x03                ; SBC #$03
L95ad:    push r16                      ; PHA
L95ae:    rcall L957d                   ; JSR $957d
L95b1:    pop r16                       ; PLA
          tst r16
L95b2:    rcall L9591                   ; JSR $9591
L95b5:    ret                           ; RTS

.global	zero
    .section .bss
    .type zero, @object
    .size zero, 6
zero:
    .zero 6

.global	ram
    .data
    .type ram, @object
    .size ram, 4544
ram:
    .ascii "\026\001\047\001\070\001\113\001\137\001\163\001\212\001\241\001\272\001\324\001\360\001\016\002"
    .ascii "\055\002\116\002\161\002\226\002\275\002\347\002\023\003\102\003\164\003\251\003\340\003\033\004"
    .ascii "\132\004\233\004\342\004\054\005\173\005\316\005\047\006\205\006\350\006\121\007\301\007\067\010"
    .ascii "\264\010\067\011\304\011\127\012\365\012\234\013\116\014\011\015\320\015\243\016\202\017\156\020"
    .ascii "\150\021\156\022\210\023\257\024\353\025\071\027\234\030\023\032\241\033\106\035\004\037\334\040"
    .ascii "\320\042\334\044\020\047\136\051\326\053\162\056\070\061\046\064\102\067\214\072\010\076\270\101"
    .ascii "\240\105\270\111\040\116\274\122\254\127\344\134\160\142\114\150\204\156\030\165\020\174\160\203"
    .ascii "\100\213\160\223\100\234\170\245\130\257\310\271\340\304\230\320\010\335\060\352\040\370\056\375"
    .ascii "\000\007\016\000\004\002\004\042\012\042\001\023\001\045\027\045\101\101\101\106\046\103\020\002"
    .ascii "\020\377\045\010\000\101\377\000\166\000\010\076\002\000\001\035\001\000\000\000\001\200\000\076"
    .ascii "\011\064\010\304\046\000\000\000\000\200\372\000\377\377\060\000\060\024\024\201\025\120\251\000"
    .ascii "\215\004\324\215\013\324\215\377\204\255\374\204\051\017\215\374\204\012\012\012\012\250\271\124"
    .ascii "\224\215\005\205\271\125\224\215\376\204\271\143\224\215\000\205\271\134\224\215\002\205\051\077"
    .ascii "\215\001\205\271\131\224\215\003\205\271\140\224\215\004\205\242\000\271\125\224\235\000\324\310"
    .ascii "\350\340\016\320\364\255\005\205\051\060\240\356\311\040\360\002\240\316\214\266\203\140\141\150"
    .ascii "\155\207\207\207\030\131\245\206\206\206\141\150\155\207\207\207\051\126\130\207\207\207\164\242"
    .ascii "\267\276\372\020\074\237\313\153\327\107\131\130\176\315\171\314\336\351\373\036\101\142\225\310"
    .ascii "\351\361\370\311\332\353\033\335\356\377\020\041\152\256\261\072\221\266\077\126\111\113\212\256"
    .ascii "\335\046\210\233\274\375\077\146\221\274\147\211\253\353\053\314\336\362\006\032\056\065\116\141"
    .ascii "\165\207\227\207\215\215\207\215\210\216\210\216\211\211\217\217\212\217\212\217\213\213\213\213"
    .ascii "\214\214\214\214\214\214\214\214\215\215\215\216\216\216\216\217\217\217\207\207\215\211\211\215"
    .ascii "\215\222\222\217\217\217\220\220\220\220\220\221\215\210\216\221\221\221\221\222\222\222\222\223"
    .ascii "\223\223\223\223\223\223\223\223\021\024\027\032\000\047\000\050\003\005\000\047\000\050\003\005"
    .ascii "\007\072\024\027\000\047\000\050\057\060\061\061\062\063\063\064\064\064\064\064\064\064\064\065"
    .ascii "\065\065\065\065\065\066\022\067\070\011\052\011\053\011\012\011\052\011\053\011\012\015\015\017"
    .ascii "\377\022\025\030\033\055\071\071\071\071\071\071\054\071\071\071\071\071\071\054\071\071\071\001"
    .ascii "\001\051\051\054\025\030\071\071\071\071\071\071\071\071\071\071\071\071\071\071\071\071\071\071"
    .ascii "\071\071\071\071\071\071\071\071\071\071\071\071\071\001\001\001\051\071\071\071\001\001\001\051"
    .ascii "\071\071\071\071\377\023\026\031\034\002\002\035\036\002\002\035\037\004\004\040\040\006\002\002"
    .ascii "\035\036\002\002\035\037\004\004\040\040\006\010\010\010\010\041\041\041\041\042\042\042\043\042"
    .ascii "\044\045\073\046\046\046\046\046\046\046\046\046\046\046\046\046\046\046\046\002\002\035\036\002"
    .ascii "\002\035\037\057\057\057\057\057\057\057\057\057\057\057\057\057\013\013\035\035\013\013\035\013"
    .ascii "\013\013\014\014\035\035\035\020\013\013\035\035\013\013\035\013\013\013\014\014\035\035\035\020"
    .ascii "\013\035\013\035\013\035\013\035\013\014\035\013\014\043\013\013\377\106\107\110\106\107\110\111"
    .ascii "\111\111\111\111\111\111\111\113\113\113\113\113\113\114\112\112\112\112\112\112\112\112\112\112"
    .ascii "\112\112\112\112\112\112\113\113\113\113\113\113\114\377\101\377\102\102\103\103\104\104\105\105"
    .ascii "\377\074\074\074\074\076\056\376\013\013\100\056\376\075\075\075\075\077\056\376\203\000\067\001"
    .ascii "\076\001\076\003\075\003\076\003\103\003\076\003\075\003\076\003\067\001\076\001\076\003\075\003"
    .ascii "\076\003\103\003\102\003\103\003\105\003\106\001\110\001\106\003\105\003\103\003\113\001\115\001"
    .ascii "\113\003\112\003\110\377\037\112\377\003\106\001\110\001\106\003\105\003\112\017\103\377\277\006"
    .ascii "\110\007\110\001\113\001\112\001\113\001\112\003\113\003\115\003\113\003\112\077\110\007\110\001"
    .ascii "\113\001\112\001\113\001\112\003\113\003\115\003\113\003\110\077\114\007\114\001\117\001\116\001"
    .ascii "\117\001\116\003\117\003\121\003\117\003\116\077\114\007\114\001\117\001\116\001\117\001\116\003"
    .ascii "\117\003\121\003\117\003\114\377\203\004\046\003\051\003\050\003\051\003\046\003\065\003\064\003"
    .ascii "\062\003\055\003\060\003\057\003\060\003\055\003\074\003\073\003\071\003\060\003\063\003\062\003"
    .ascii "\063\003\060\003\077\003\076\003\074\003\106\003\105\003\103\003\072\003\071\003\067\003\056\003"
    .ascii "\055\003\046\003\051\003\050\003\051\003\046\003\065\003\064\003\062\003\055\003\060\003\057\003"
    .ascii "\060\003\055\003\074\003\073\003\071\003\060\003\063\003\062\003\063\003\060\003\077\003\076\003"
    .ascii "\074\003\064\003\067\003\066\003\067\003\064\003\067\003\072\003\075\003\076\007\076\007\077\007"
    .ascii "\076\003\074\007\076\127\377\213\000\072\001\072\001\074\003\075\003\077\003\075\003\074\013\072"
    .ascii "\003\071\007\072\201\006\113\001\115\001\116\001\115\001\116\001\115\005\113\201\000\072\001\074"
    .ascii "\001\075\003\077\003\075\003\074\003\072\003\071\033\072\013\073\001\073\001\075\003\076\003\100"
    .ascii "\003\076\003\075\013\073\003\072\007\073\201\006\114\001\116\001\117\001\116\001\117\001\116\005"
    .ascii "\114\201\000\073\001\075\001\076\003\100\003\076\003\075\003\073\003\072\033\073\213\005\065\003"
    .ascii "\063\007\062\003\060\003\057\013\060\003\062\017\060\013\065\003\063\007\062\003\060\003\057\037"
    .ascii "\060\213\000\074\001\074\001\076\003\077\003\101\003\077\003\076\013\075\001\075\001\077\003\100"
    .ascii "\003\102\003\100\003\077\003\076\001\076\001\100\003\101\003\100\003\076\003\075\003\076\003\074"
    .ascii "\003\072\001\072\001\074\003\075\003\074\003\072\003\071\003\072\003\074\377\203\000\062\001\065"
    .ascii "\001\064\003\062\003\065\003\064\003\062\003\065\001\064\001\062\003\062\003\072\003\071\003\072"
    .ascii "\003\062\003\072\003\071\003\072\377\003\064\001\067\001\065\003\064\003\067\003\065\003\064\003"
    .ascii "\067\001\065\001\064\003\064\003\072\003\071\003\072\003\064\003\072\003\071\003\072\377\003\071"
    .ascii "\003\070\003\071\003\072\003\071\003\067\003\065\003\064\003\065\003\064\003\065\003\067\003\065"
    .ascii "\003\064\003\062\003\061\377\003\067\001\072\001\071\003\067\003\072\003\071\003\067\003\072\001"
    .ascii "\071\001\067\003\067\003\076\003\075\003\076\003\067\003\076\003\075\003\076\003\075\001\100\001"
    .ascii "\076\003\075\003\100\001\076\001\075\003\100\003\076\003\100\003\100\001\103\001\101\003\100\003"
    .ascii "\103\001\101\001\100\003\103\003\101\003\103\003\103\001\106\001\105\003\103\003\106\001\105\001"
    .ascii "\103\003\106\003\105\003\103\001\110\001\111\001\110\001\106\001\105\001\106\001\105\001\103\001"
    .ascii "\101\001\103\001\101\001\100\001\075\001\071\001\073\001\075\377\001\076\001\071\001\065\001\071"
    .ascii "\001\076\001\071\001\065\001\071\003\076\001\101\001\100\003\100\001\075\001\076\001\100\001\075"
    .ascii "\001\071\001\075\001\100\001\075\001\071\001\075\003\100\001\103\001\101\003\101\001\076\001\100"
    .ascii "\001\101\001\076\001\071\001\076\001\101\001\076\001\071\001\076\003\101\001\105\001\103\003\103"
    .ascii "\001\100\001\101\001\103\001\100\001\075\001\100\001\103\001\100\001\075\001\100\001\106\001\103"
    .ascii "\001\105\001\106\001\104\001\103\001\100\001\075\377\001\076\001\071\001\065\001\071\001\076\001"
    .ascii "\071\001\065\001\071\001\076\001\071\001\065\001\071\001\076\001\071\001\065\001\071\001\076\001"
    .ascii "\072\001\067\001\072\001\076\001\072\001\067\001\072\001\076\001\072\001\067\001\072\001\076\001"
    .ascii "\072\001\067\001\072\001\100\001\075\001\071\001\075\001\100\001\075\001\071\001\075\001\100\001"
    .ascii "\075\001\071\001\075\001\100\001\075\001\071\001\075\001\101\001\076\001\071\001\076\001\101\001"
    .ascii "\076\001\071\001\076\001\101\001\076\001\071\001\076\001\101\001\076\001\071\001\076\001\103\001"
    .ascii "\076\001\072\001\076\001\103\001\076\001\072\001\076\001\103\001\076\001\072\001\076\001\103\001"
    .ascii "\076\001\072\001\076\001\103\001\077\001\074\001\077\001\103\001\077\001\074\001\077\001\103\001"
    .ascii "\077\001\074\001\077\001\103\001\077\001\074\001\077\001\105\001\102\001\074\001\102\001\105\001"
    .ascii "\102\001\074\001\102\001\110\001\105\001\102\001\105\001\113\001\110\001\105\001\110\001\113\001"
    .ascii "\112\001\110\001\112\001\113\001\112\001\110\001\112\001\113\001\112\001\110\001\112\001\114\001"
    .ascii "\116\003\117\377\277\006\126\037\127\037\126\037\133\037\126\037\127\037\126\037\117\377\277\014"
    .ascii "\150\177\177\177\177\177\177\177\377\277\010\023\077\023\077\023\077\023\077\023\077\023\077\023"
    .ascii "\037\023\377\227\011\056\003\056\033\062\003\062\033\061\003\061\037\064\103\027\062\003\062\033"
    .ascii "\065\003\065\033\064\003\064\017\067\217\012\067\103\377\227\011\053\003\053\033\056\003\056\033"
    .ascii "\055\003\055\037\060\103\027\056\003\056\033\062\003\062\033\061\003\061\017\064\217\012\064\103"
    .ascii "\377\017\037\017\037\017\037\017\037\017\037\017\037\017\037\017\037\017\037\017\037\017\037\017"
    .ascii "\037\017\037\017\037\017\037\017\037\377\227\011\063\003\063\033\067\003\067\033\066\003\066\037"
    .ascii "\071\103\027\067\003\067\033\072\003\072\033\071\003\071\057\074\041\074\041\075\041\076\041\077"
    .ascii "\041\100\041\101\041\102\041\103\041\104\001\105\377\227\011\060\003\060\033\063\003\063\033\062"
    .ascii "\003\062\037\066\103\027\063\003\063\033\067\003\067\033\066\003\066\057\071\041\071\041\072\041"
    .ascii "\073\041\074\041\075\041\076\041\077\041\100\041\101\001\102\377\017\032\017\032\017\032\017\032"
    .ascii "\017\032\017\032\017\032\017\032\017\032\017\032\017\032\017\032\017\032\017\032\017\032\017\032"
    .ascii "\377\037\106\277\012\106\177\177\377\037\103\277\012\103\177\377\203\002\023\003\023\003\036\003"
    .ascii "\037\003\023\003\023\003\036\003\037\003\023\003\023\003\036\003\037\003\023\003\023\003\036\003"
    .ascii "\037\003\023\003\023\003\036\003\037\003\023\003\023\003\036\003\037\003\023\003\023\003\036\003"
    .ascii "\037\003\023\003\023\003\036\003\037\377\217\013\070\117\377\203\016\062\007\062\007\057\007\057"
    .ascii "\003\053\207\013\106\203\016\054\003\054\217\013\062\377\103\203\016\062\003\062\003\057\003\057"
    .ascii "\003\054\207\013\070\377\203\001\103\001\117\001\133\207\003\057\203\001\103\001\117\001\133\207"
    .ascii "\003\057\203\001\103\001\117\001\133\207\003\057\203\001\103\001\117\001\133\207\003\057\203\001"
    .ascii "\103\001\117\001\133\207\003\057\203\001\103\001\117\001\133\207\003\057\203\001\103\001\117\001"
    .ascii "\133\207\003\057\203\001\103\001\117\001\133\207\003\057\377\203\002\023\003\023\003\037\003\037"
    .ascii "\003\023\003\023\003\037\003\037\377\003\025\003\025\003\037\003\041\003\025\003\025\003\037\003"
    .ascii "\041\377\003\032\003\032\003\034\003\034\003\035\003\035\003\036\003\036\377\003\032\003\032\003"
    .ascii "\044\003\046\003\023\003\023\007\037\377\003\030\003\030\003\044\003\044\003\030\003\030\003\044"
    .ascii "\003\044\003\040\003\040\003\054\003\054\003\040\003\040\003\054\003\054\377\003\031\003\031\003"
    .ascii "\045\003\045\003\031\003\031\003\045\003\045\003\041\003\041\003\055\003\055\003\041\003\041\003"
    .ascii "\055\003\055\377\003\032\003\032\003\046\003\046\003\032\003\032\003\046\003\046\003\025\003\025"
    .ascii "\003\041\003\041\003\025\003\025\003\041\003\041\003\030\003\030\003\044\003\044\003\030\003\030"
    .ascii "\003\044\003\044\003\037\003\037\003\053\003\053\003\037\003\037\003\053\003\053\003\032\003\032"
    .ascii "\003\046\003\046\003\032\003\032\003\046\003\046\003\025\003\025\003\041\003\041\003\025\003\025"
    .ascii "\003\041\003\041\003\030\003\030\003\044\003\044\003\030\003\030\003\044\003\044\003\034\003\034"
    .ascii "\003\050\003\050\003\034\003\034\003\050\003\050\203\004\066\007\066\007\067\007\066\003\063\007"
    .ascii "\062\127\377\203\002\033\003\033\003\047\003\047\003\033\003\033\003\047\003\047\377\003\034\003"
    .ascii "\034\003\050\003\050\003\034\003\034\003\050\003\050\377\003\035\003\035\003\051\003\051\003\035"
    .ascii "\003\035\003\051\003\051\377\003\030\003\030\003\044\003\044\003\030\003\030\003\044\003\044\377"
    .ascii "\003\036\003\036\003\052\003\052\003\036\003\036\003\052\003\052\377\203\005\046\001\112\001\064"
    .ascii "\003\051\003\114\003\112\003\061\003\112\003\044\003\042\001\106\001\060\003\045\003\110\003\106"
    .ascii "\003\055\003\106\003\044\377\203\002\032\003\032\003\046\003\046\003\032\003\032\003\046\003\046"
    .ascii "\377\003\023\003\023\003\035\003\037\003\023\003\023\003\035\003\037\377\207\002\032\207\003\057"
    .ascii "\203\002\046\003\046\207\003\057\377\007\032\117\107\377\003\037\003\037\003\044\003\046\007\023"
    .ascii "\107\377\277\017\062\017\062\217\220\060\077\062\023\062\003\062\003\065\003\067\077\067\017\067"
    .ascii "\217\220\060\077\062\023\062\003\055\003\060\003\062\377\017\062\257\220\065\017\067\247\231\067"
    .ascii "\007\065\077\062\023\062\003\062\243\350\065\003\067\017\065\257\220\067\017\067\247\231\067\007"
    .ascii "\065\077\062\023\062\003\055\243\350\060\003\062\377\007\062\003\071\023\074\247\232\067\247\233"
    .ascii "\070\007\067\003\065\003\062\003\071\033\074\247\232\067\247\233\070\007\067\003\065\003\062\003"
    .ascii "\071\003\074\003\076\003\074\007\076\003\074\003\071\247\232\067\247\233\070\007\067\003\065\003"
    .ascii "\062\257\220\074\037\076\103\003\076\003\074\003\076\377\003\076\003\076\243\350\074\003\076\003"
    .ascii "\076\003\076\243\350\074\003\076\003\076\003\076\243\350\074\003\076\003\076\003\076\243\350\074"
    .ascii "\003\076\257\221\103\037\101\103\003\076\003\101\003\103\003\103\003\103\243\350\101\003\103\003"
    .ascii "\103\003\103\243\350\101\003\103\003\105\003\110\243\375\105\003\104\001\103\001\101\003\076\003"
    .ascii "\074\003\076\057\076\277\230\076\103\003\076\003\074\003\076\377\003\112\003\112\243\370\110\003"
    .ascii "\112\003\112\003\112\243\370\110\003\112\377\001\121\001\124\001\121\001\124\001\121\001\124\001"
    .ascii "\121\001\124\001\121\001\124\001\121\001\124\001\121\001\124\001\121\001\124\377\001\120\001\117"
    .ascii "\001\115\001\112\001\117\001\115\001\112\001\110\001\112\001\110\001\105\001\103\001\104\001\103"
    .ascii "\001\101\001\076\001\103\001\101\001\076\001\074\001\076\001\074\001\071\001\067\001\070\001\067"
    .ascii "\001\065\001\062\001\067\001\065\001\062\001\060\377\137\137\137\107\203\016\062\007\062\007\057"
    .ascii "\003\057\007\057\227\013\072\137\137\107\213\016\062\003\062\003\057\003\057\107\227\013\072\137"
    .ascii "\137\107\203\016\057\013\057\003\057\003\057\207\013\060\027\072\137\213\016\062\013\062\013\057"
    .ascii "\013\057\007\054\007\054\377\207\013\064\027\072\137\137\204\016\062\004\062\005\062\004\057\004"
    .ascii "\057\005\057\107\227\013\072\137\137\204\016\062\004\062\005\062\004\057\004\057\005\057\377\200"
    .ascii "\020\106\000\103\000\105\000\102\000\106\000\103\000\105\000\102\000\106\000\103\000\105\000\102"
    .ascii "\000\106\000\103\000\105\000\102\377\200\020\103\000\077\000\102\000\076\000\103\000\077\000\102"
    .ascii "\000\076\000\103\000\077\000\102\000\076\000\103\000\077\000\102\000\076\377\041\106\041\103\041"
    .ascii "\105\041\102\042\106\042\103\042\105\042\102\043\106\043\103\043\105\043\102\044\106\044\103\044"
    .ascii "\105\044\102\045\106\045\103\045\105\045\102\050\106\050\103\050\105\050\102\011\103\013\077\016"
    .ascii "\102\022\074\057\072\257\320\072\037\106\377\041\103\041\077\041\102\041\076\042\103\042\077\042"
    .ascii "\102\042\076\043\103\043\077\043\102\043\076\044\103\044\077\044\102\044\076\045\103\045\077\045"
    .ascii "\102\045\076\050\103\050\077\050\102\050\076\011\077\013\074\016\076\022\071\057\062\257\320\062"
    .ascii "\037\076\377\007\046\013\032\017\046\023\032\027\046\021\032\021\046\011\032\013\046\016\032\022"
    .ascii "\046\057\053\257\301\053\037\037\377\137\377\003\032\003\032\003\044\003\046\003\032\003\032\003"
    .ascii "\030\003\031\003\032\003\032\003\044\003\046\003\032\003\032\003\030\003\031\003\030\003\030\003"
    .ascii "\042\003\044\003\030\003\030\003\026\003\027\003\030\003\030\003\042\003\044\003\030\003\030\003"
    .ascii "\026\003\027\003\023\003\023\003\035\003\037\003\023\003\023\003\035\003\036\003\023\003\023\003"
    .ascii "\035\003\037\003\023\003\023\003\035\003\036\003\032\003\032\003\044\003\046\003\032\003\032\003"
    .ascii "\030\003\031\003\032\003\032\003\044\003\046\003\032\003\032\003\030\003\031\377\207\021\077\007"
    .ascii "\104\007\106\007\104\007\113\007\104\007\106\007\104\377\217\002\040\207\003\057\207\002\040\007"
    .ascii "\040\007\040\207\003\057\207\002\033\377\217\002\035\207\003\057\207\002\035\007\035\007\035\207"
    .ascii "\003\057\207\002\030\377\217\002\031\207\003\057\207\002\031\007\031\007\031\207\003\057\207\002"
    .ascii "\040\377\217\002\033\207\003\057\207\002\033\007\033\007\033\207\003\057\207\002\042\377\277\011"
    .ascii "\074\077\074\017\074\003\075\003\074\003\075\003\074\007\075\007\077\007\075\007\074\007\075\017"
    .ascii "\074\067\070\037\070\377\007\065\027\075\017\074\007\074\017\072\047\072\077\072\077\072\037\072"
    .ascii "\377\107\217\022\074\027\077\007\075\007\074\107\017\074\027\074\007\072\007\070\377\207\023\104"
    .ascii "\007\110\007\111\007\110\007\104\007\111\007\110\007\111\377\243\011\104\243\350\104\042\106\244"
    .ascii "\331\106\037\104\017\077\377\043\113\243\376\113\043\115\243\361\115\037\113\017\111\043\106\243"
    .ascii "\376\106\043\110\243\353\110\037\106\017\106\377\200\013\101\110\140\003\201\000\000\010\201\002"
    .ascii "\010\000\000\001\240\002\101\011\200\000\000\000\000\002\201\011\011\000\000\005\000\010\101\010"
    .ascii "\120\002\000\004\000\001\101\077\300\002\000\000\000\010\101\004\100\002\000\000\000\010\101\011"
    .ascii "\000\002\000\000\200\012\101\011\160\002\137\004\200\010\101\112\151\002\201\000\000\011\101\100"
    .ascii "\157\000\201\002\200\007\201\012\012\000\000\001\240\013\101\077\377\001\347\002\000\010\101\220"
    .ascii "\360\001\350\002\000\010\101\006\012\000\000\001\000\011\101\031\160\002\250\000\000\002\101\011"
    .ascii "\220\002\000\000\000\000\021\012\372\000\000\005\000\010\101\067\100\002\000\000\000\010\021\007"
    .ascii "\160\002\000\000\140\063\230\200\001\101\017\000\000\127\000\006\025\017\000\137\142\100\003\100"
    .ascii "\002\101\014\000\062\220\000\010\103\012\000\130\120\100\010\200\010\101\012\220\006\024\024\002"
    .ascii "\107\017\240\040\142\020\010\040\000\201\016\000\010\001\200\010\201\017\000\117\041\050\010\100"
    .ascii "\010\021\017\220\002\140\200\006\025\017\220\117\021\117\010\100\010\021\017\220\002\140\200\006"
    .ascii "\025\017\220\050\144\004\004\200\010\101\012\240\002\000\024\001\107\017\200\137\240\060\310\000"
    .ascii "\010\101\011\000\002\171\000\010\101\012\000\120\200\120\070\100\010\101\011\000\000\041\200\010"
    .ascii "\025\013\000\060\120\157\024\100\000\201\012\000\024\047\000\010\025\015\000\060\120\105\005\100"
    .ascii "\000\201\002\000\200\300\000\010\025\117\360\030\140\020\007\200\000\201\012\000\045\001\000\002"
    .ascii "\027\014\000\044\022\060\002\200\000\021\017\360\010\001\000\002\021\017\360\024\020\032\002\040"
    .ascii "\000\201\017\360\041\001\000\003\205\017\360\007\240\063\032\200\000\201\012\000\000\015\000\002"
    .ascii "\201\013\000\137\040\012\003\200\000\101\012\000\004\161\240\000\121\013\360\040\240\000\012\215"
    .ascii "\334\204\012\030\155\334\204\252\275\154\205\231\146\205\350\310\300\006\320\364\251\000\215\004"
    .ascii "\324\215\013\324\215\022\324\251\100\215\356\204\140\251\300\215\356\204\140\251\000\215\373\204"
    .ascii "\140\251\377\215\373\204\114\247\203\256\373\204\360\004\216\374\204\140\011\100\215\374\204\140"
    .ascii "\215\277\225\311\003\260\003\114\124\225\070\351\003\110\040\175\225\150\040\221\225\140\000\000"
    .ascii "\000\000\000\000\000\000\000\000"


.global __do_copy_data
.global __do_clear_bss


    .end

