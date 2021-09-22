                            * = $8000
8000   4C A0 95             JMP L95A0
8003   4C 12 80             JMP L8012
8006   60                   RTS
8007   60                   RTS
8008   00                   BRK
8009   4C 89 00             JMP $0089
800C   00                   BRK
800D   00                   BRK
800E   00                   BRK
800F   00                   BRK
8010   00                   BRK
8011   00                   BRK
8012   A9 0F      L8012     LDA #$0F
8014   8D 18 D4             STA $D418
8017   EE FA 84             INC $84FA
801A   2C EE 84             BIT $84EE
801D   30 1E                BMI L803D
801F   50 31                BVC L8052
8021   A9 00                LDA #$00
8023   8D FA 84             STA $84FA
8026   A2 02                LDX #$02
8028   9D C4 84   L8028     STA $84C4,X
802B   9D C7 84             STA $84C7,X
802E   9D CA 84             STA $84CA,X
8031   9D D3 84             STA $84D3,X
8034   CA                   DEX
8035   10 F1                BPL L8028
8037   8D EE 84             STA $84EE
803A   4C 52 80             JMP L8052
803D   50 10      L803D     BVC L804F
803F   A9 00                LDA #$00
8041   8D 04 D4             STA $D404
8044   8D 0B D4             STA $D40B
8047   8D 12 D4             STA $D412
804A   A9 80                LDA #$80
804C   8D EE 84             STA $84EE
804F   4C 7D 83   L804F     JMP L837D
8052   A2 02      L8052     LDX #$02
8054   CE EB 84             DEC $84EB
8057   10 06                BPL L805F
8059   AD EC 84             LDA $84EC
805C   8D EB 84             STA $84EB
805F   BD C0 84   L805F     LDA $84C0,X
8062   8D C3 84             STA $84C3
8065   A8                   TAY
8066   AD EB 84             LDA $84EB
8069   CD EC 84             CMP $84EC
806C   D0 15                BNE L8083
806E   BD 66 85             LDA $8566,X
8071   85 02                STA $02
8073   BD 69 85             LDA $8569,X
8076   85 03                STA $03
8078   DE CA 84             DEC $84CA,X
807B   30 09                BMI L8086
807D   4C 74 81             JMP L8174
8080   4C 67 83             JMP L8367
8083   4C 9B 81   L8083     JMP L819B
8086   BC C4 84   L8086     LDY $84C4,X
8089   B1 02                LDA ($02),Y
808B   C9 FF                CMP #$FF
808D   F0 0A                BEQ L8099
808F   C9 FE                CMP #$FE
8091   D0 17                BNE L80AA
8093   EA                   NOP
8094   EA                   NOP
8095   EA                   NOP
8096   4C 7D 83             JMP L837D
8099   A9 00      L8099     LDA #$00
809B   9D CA 84             STA $84CA,X
809E   9D C4 84             STA $84C4,X
80A1   9D C7 84             STA $84C7,X
80A4   4C 86 80             JMP L8086
80A7   4C 67 83             JMP L8367
80AA   A8         L80AA     TAY
80AB   B9 7E 85             LDA $857E,Y
80AE   85 04                STA $04
80B0   B9 CB 85             LDA $85CB,Y
80B3   85 05                STA $05
80B5   A9 00                LDA #$00
80B7   9D F5 84             STA $84F5,X
80BA   BC C7 84             LDY $84C7,X
80BD   A9 FF                LDA #$FF
80BF   8D D9 84             STA L84D9
80C2   B1 04                LDA ($04),Y
80C4   9D CD 84             STA $84CD,X
80C7   8D DA 84             STA L84DA
80CA   29 1F                AND #$1F
80CC   9D CA 84             STA $84CA,X
80CF   2C DA 84             BIT L84DA
80D2   70 44                BVS L8118
80D4   FE C7 84             INC $84C7,X
80D7   AD DA 84             LDA L84DA
80DA   10 11                BPL L80ED
80DC   C8                   INY
80DD   B1 04                LDA ($04),Y
80DF   10 06                BPL L80E7
80E1   9D F5 84             STA $84F5,X
80E4   4C EA 80             JMP L80EA
80E7   9D D6 84   L80E7     STA $84D6,X
80EA   FE C7 84   L80EA     INC $84C7,X
80ED   C8         L80ED     INY
80EE   B1 04                LDA ($04),Y
80F0   9D D3 84             STA $84D3,X
80F3   0A                   ASL A
80F4   A8                   TAY
80F5   AD FD 84             LDA $84FD
80F8   10 21                BPL L811B
80FA   B9 00 84             LDA $8400,Y
80FD   8D DB 84             STA $84DB
8100   B9 01 84   L8100     LDA $8401,Y
8103   AC C3 84             LDY $84C3
8106   99 01 D4             STA $D401,Y
8109   9D EF 84             STA $84EF,X
810C   AD DB 84             LDA $84DB
810F   99 00 D4             STA $D400,Y
8112   9D F2 84             STA $84F2,X
8115   4C 1B 81             JMP L811B
8118   CE D9 84   L8118     DEC L84D9
811B   AC C3 84   L811B     LDY $84C3
811E   BD D6 84             LDA $84D6,X
8121   8E DC 84             STX $84DC
8124   0A                   ASL A
8125   0A                   ASL A
8126   0A                   ASL A
8127   AA                   TAX
8128   BD B6 93             LDA $93B6,X
812B   8D DD 84             STA $84DD
812E   AD FD 84             LDA $84FD
8131   10 21                BPL L8154
8133   BD B6 93             LDA $93B6,X
8136   2D D9 84             AND L84D9
8139   99 04 D4             STA $D404,Y
813C   BD B4 93             LDA $93B4,X
813F   99 02 D4             STA $D402,Y
8142   BD B5 93             LDA $93B5,X
8145   99 03 D4             STA $D403,Y
8148   BD B7 93             LDA $93B7,X
814B   99 05 D4             STA $D405,Y
814E   BD B8 93             LDA $93B8,X
8151   99 06 D4             STA $D406,Y
8154   AE DC 84   L8154     LDX $84DC
8157   AD DD 84             LDA $84DD
815A   9D D0 84             STA $84D0,X
815D   FE C7 84             INC $84C7,X
8160   BC C7 84             LDY $84C7,X
8163   B1 04                LDA ($04),Y
8165   C9 FF                CMP #$FF
8167   D0 08                BNE L8171
8169   A9 00                LDA #$00
816B   9D C7 84             STA $84C7,X
816E   FE C4 84             INC $84C4,X
8171   4C 67 83   L8171     JMP L8367
8174   AD FD 84   L8174     LDA $84FD
8177   30 03                BMI L817C
8179   4C 67 83             JMP L8367
817C   AC C3 84   L817C     LDY $84C3
817F   BD CD 84             LDA $84CD,X
8182   29 20                AND #$20
8184   D0 15                BNE L819B
8186   BD CA 84             LDA $84CA,X
8189   D0 10                BNE L819B
818B   BD D0 84             LDA $84D0,X
818E   29 FE                AND #$FE
8190   99 04 D4             STA $D404,Y
8193   A9 00                LDA #$00
8195   99 05 D4             STA $D405,Y
8198   99 06 D4             STA $D406,Y
819B   AD FD 84   L819B     LDA $84FD
819E   30 03                BMI L81A3
81A0   4C 67 83             JMP L8367
81A3   BD D6 84   L81A3     LDA $84D6,X
81A6   0A                   ASL A
81A7   0A                   ASL A
81A8   0A                   ASL A
81A9   A8                   TAY
81AA   8C ED 84             STY $84ED
81AD   B9 BB 93             LDA $93BB,Y
81B0   8D F8 84             STA $84F8
81B3   B9 BA 93             LDA $93BA,Y
81B6   8D DF 84             STA $84DF
81B9   B9 B9 93             LDA $93B9,Y
81BC   8D DE 84             STA $84DE
81BF   F0 6F                BEQ L8230
81C1   AD FA 84             LDA $84FA
81C4   29 07                AND #$07
81C6   C9 04                CMP #$04
81C8   90 02                BCC L81CC
81CA   49 07                EOR #$07
81CC   8D E4 84   L81CC     STA $84E4
81CF   BD D3 84             LDA $84D3,X
81D2   0A                   ASL A
81D3   A8                   TAY
81D4   38                   SEC
81D5   B9 02 84             LDA $8402,Y
81D8   F9 00 84             SBC $8400,Y
81DB   8D E0 84             STA $84E0
81DE   B9 03 84             LDA $8403,Y
81E1   F9 01 84             SBC $8401,Y
81E4   4A         L81E4     LSR A
81E5   6E E0 84             ROR $84E0
81E8   CE DE 84             DEC $84DE
81EB   10 F7                BPL L81E4
81ED   8D E1 84             STA $84E1
81F0   B9 00 84             LDA $8400,Y
81F3   8D E2 84             STA $84E2
81F6   B9 01 84             LDA $8401,Y
81F9   8D E3 84             STA $84E3
81FC   BD CD 84             LDA $84CD,X
81FF   29 1F                AND #$1F
8201   C9 08                CMP #$08
8203   90 1C                BCC L8221
8205   AC E4 84             LDY $84E4
8208   88         L8208     DEY
8209   30 16                BMI L8221
820B   18                   CLC
820C   AD E2 84             LDA $84E2
820F   6D E0 84             ADC $84E0
8212   8D E2 84             STA $84E2
8215   AD E3 84             LDA $84E3
8218   6D E1 84             ADC $84E1
821B   8D E3 84             STA $84E3
821E   4C 08 82             JMP L8208
8221   AC C3 84   L8221     LDY $84C3
8224   AD E2 84             LDA $84E2
8227   99 00 D4             STA $D400,Y
822A   AD E3 84             LDA $84E3
822D   99 01 D4             STA $D401,Y
8230   AD DF 84   L8230     LDA $84DF
8233   F0 62                BEQ L8297
8235   AC ED 84             LDY $84ED
8238   29 1F                AND #$1F
823A   DE E5 84             DEC $84E5,X
823D   10 58                BPL L8297
823F   9D E5 84             STA $84E5,X
8242   AD DF 84             LDA $84DF
8245   29 E0                AND #$E0
8247   8D F9 84             STA $84F9
824A   BD E8 84             LDA $84E8,X
824D   D0 1A                BNE L8269
824F   AD F9 84             LDA $84F9
8252   18                   CLC
8253   79 B4 93             ADC $93B4,Y
8256   48                   PHA
8257   B9 B5 93             LDA $93B5,Y
825A   69 00                ADC #$00
825C   29 0F                AND #$0F
825E   48                   PHA
825F   C9 0E                CMP #$0E
8261   D0 1D                BNE L8280
8263   FE E8 84             INC $84E8,X
8266   4C 80 82             JMP L8280
8269   38         L8269     SEC
826A   B9 B4 93             LDA $93B4,Y
826D   ED F9 84             SBC $84F9
8270   48                   PHA
8271   B9 B5 93             LDA $93B5,Y
8274   E9 00                SBC #$00
8276   29 0F                AND #$0F
8278   48                   PHA
8279   C9 08                CMP #$08
827B   D0 03                BNE L8280
827D   DE E8 84             DEC $84E8,X
8280   8E DC 84   L8280     STX $84DC
8283   AE C3 84             LDX $84C3
8286   68                   PLA
8287   99 B5 93             STA $93B5,Y
828A   9D 03 D4             STA $D403,X
828D   68                   PLA
828E   99 B4 93             STA $93B4,Y
8291   9D 02 D4             STA $D402,X
8294   AE DC 84             LDX $84DC
8297   AC C3 84   L8297     LDY $84C3
829A   BD F5 84             LDA $84F5,X
829D   F0 3F                BEQ L82DE
829F   29 7E                AND #$7E
82A1   8D DC 84             STA $84DC
82A4   BD F5 84             LDA $84F5,X
82A7   29 01                AND #$01
82A9   F0 1B                BEQ L82C6
82AB   38                   SEC
82AC   BD F2 84             LDA $84F2,X
82AF   ED DC 84             SBC $84DC
82B2   9D F2 84             STA $84F2,X
82B5   99 00 D4             STA $D400,Y
82B8   BD EF 84             LDA $84EF,X
82BB   E9 00                SBC #$00
82BD   9D EF 84             STA $84EF,X
82C0   99 01 D4             STA $D401,Y
82C3   4C DE 82             JMP L82DE
82C6   18         L82C6     CLC
82C7   BD F2 84             LDA $84F2,X
82CA   6D DC 84             ADC $84DC
82CD   9D F2 84             STA $84F2,X
82D0   99 00 D4             STA $D400,Y
82D3   BD EF 84             LDA $84EF,X
82D6   69 00                ADC #$00
82D8   9D EF 84             STA $84EF,X
82DB   99 01 D4             STA $D401,Y
82DE   AD F8 84   L82DE     LDA $84F8
82E1   29 01                AND #$01
82E3   F0 35                BEQ L831A
82E5   BD EF 84             LDA $84EF,X
82E8   F0 30                BEQ L831A
82EA   BD CA 84             LDA $84CA,X
82ED   F0 2B                BEQ L831A
82EF   BD CD 84             LDA $84CD,X
82F2   29 1F                AND #$1F
82F4   38                   SEC
82F5   E9 01                SBC #$01
82F7   DD CA 84             CMP $84CA,X
82FA   AC C3 84             LDY $84C3
82FD   90 10                BCC L830F
82FF   BD EF 84             LDA $84EF,X
8302   DE EF 84             DEC $84EF,X
8305   99 01 D4             STA $D401,Y
8308   BD D0 84             LDA $84D0,X
830B   29 FE                AND #$FE
830D   D0 08                BNE L8317
830F   BD EF 84   L830F     LDA $84EF,X
8312   99 01 D4             STA $D401,Y
8315   A9 80                LDA #$80
8317   99 04 D4   L8317     STA $D404,Y
831A   AD F8 84   L831A     LDA $84F8
831D   29 02                AND #$02
831F   F0 15                BEQ L8336
8321   AD FA 84             LDA $84FA
8324   29 01                AND #$01
8326   F0 0E                BEQ L8336
8328   BD EF 84             LDA $84EF,X
832B   F0 09                BEQ L8336
832D   DE EF 84             DEC $84EF,X
8330   AC C3 84             LDY $84C3
8333   99 01 D4             STA $D401,Y
8336   AD F8 84   L8336     LDA $84F8
8339   29 04                AND #$04
833B   F0 2A                BEQ L8367
833D   AD FA 84             LDA $84FA
8340   29 01                AND #$01
8342   F0 09                BEQ L834D
8344   BD D3 84             LDA $84D3,X
8347   18                   CLC
8348   69 0C                ADC #$0C
834A   4C 50 83             JMP L8350
834D   BD D3 84   L834D     LDA $84D3,X
8350   0A         L8350     ASL A
8351   A8                   TAY
8352   B9 00 84             LDA $8400,Y
8355   8D DB 84             STA $84DB
8358   B9 01 84             LDA $8401,Y
835B   AC C3 84             LDY $84C3
835E   99 01 D4             STA $D401,Y
8361   AD DB 84             LDA $84DB
8364   99 00 D4             STA $D400,Y
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
838A   10 01                BPL L838D
838C   60         L838C     RTS
838D   50 03      L838D     BVC L8392
838F   20 06 85             JSR L8506
8392   CE FF 84   L8392     DEC $84FF
8395   10 F5                BPL L838C
8397   AD 05 85             LDA $8505
839A   29 0F                AND #$0F
839C   8D FF 84             STA $84FF
839F   AD FE 84             LDA $84FE
83A2   CD 00 85             CMP L8500
83A5   D0 0F                BNE L83B6
83A7   A2 00      L83A7     LDX #$00
83A9   8E 04 D4             STX $D404
83AC   8E 0B D4             STX $D40B
83AF   CA                   DEX
83B0   8E FC 84             STX $84FC
83B3   4C 8C 83             JMP L838C
83B6   CE FE 84   L83B6     DEC $84FE
83B9   0A                   ASL A
83BA   A8                   TAY
83BB   2C 05 85             BIT $8505
83BE   30 20                BMI L83E0
83C0   70 0C                BVS L83CE
83C2   B9 00 84             LDA $8400,Y
83C5   8D 00 D4             STA $D400
83C8   B9 01 84             LDA $8401,Y
83CB   8D 01 D4             STA $D401
83CE   98         L83CE     TYA
83CF   38                   SEC
83D0   ED 01 85             SBC $8501
83D3   A8                   TAY
83D4   B9 00 84             LDA $8400,Y
83D7   8D 07 D4             STA $D407
83DA   B9 01 84             LDA $8401,Y
83DD   8D 08 D4             STA $D408
83E0   2C 02 85   L83E0     BIT $8502
83E3   10 0B                BPL L83F0
83E5   AD 03 85             LDA $8503
83E8   49 01                EOR #$01
83EA   8D 04 D4             STA $D404
83ED   8D 03 85             STA $8503
83F0   50 0B      L83F0     BVC L83FD
83F2   AD 04 85             LDA $8504
83F5   49 01                EOR #$01
83F7   8D 0B D4             STA $D40B
83FA   8D 04 85             STA $8504
83FD   4C 8C 83   L83FD     JMP L838C
8400   16 01                ASL $01,X
8402   27                   ???
8403   01 38                ORA ($38,X)
8405   01 4B                ORA ($4B,X)
8407   01 5F                ORA ($5F,X)
8409   01 73                ORA ($73,X)
840B   01 8A                ORA ($8A,X)
840D   01 A1                ORA ($A1,X)
840F   01 BA                ORA ($BA,X)
8411   01 D4                ORA ($D4,X)
8413   01 F0                ORA ($F0,X)
8415   01 0E                ORA ($0E,X)
8417   02                   ???
8418   2D 02 4E             AND $4E02
841B   02                   ???
841C   71 02                ADC ($02),Y
841E   96 02                STX $02,Y
8420   BD 02 E7             LDA $E702,X
8423   02                   ???
8424   13                   ???
8425   03                   ???
8426   42                   ???
8427   03                   ???
8428   74                   ???
8429   03                   ???
842A   A9 03                LDA #$03
842C   E0 03                CPX #$03
842E   1B                   ???
842F   04                   ???
8430   5A                   ???
8431   04                   ???
8432   9B                   ???
8433   04                   ???
8434   E2                   ???
8435   04                   ???
8436   2C 05 7B             BIT $7B05
8439   05 CE                ORA $CE
843B   05 27                ORA $27
843D   06 85                ASL $85
843F   06 E8      L843F     ASL $E8
8441   06 51                ASL $51
8443   07                   ???
8444   C1 07                CMP ($07,X)
8446   37                   ???
8447   08                   PHP
8448   B4 08                LDY $08,X
844A   37                   ???
844B   09 C4                ORA #$C4
844D   09 57                ORA #$57
844F   0A                   ASL A
8450   F5 0A                SBC $0A,X
8452   9C                   ???
8453   0B                   ???
8454   4E 0C 09             LSR $090C
8457   0D D0 0D             ORA $0DD0
845A   A3                   ???
845B   0E 82 0F             ASL $0F82
845E   6E 10 68             ROR $6810
8461   11 6E                ORA ($6E),Y
8463   12                   ???
8464   88                   DEY
8465   13                   ???
8466   AF                   ???
8467   14                   ???
8468   EB         L8468     ???
8469   15 39                ORA $39,X
846B   17                   ???
846C   9C                   ???
846D   18                   CLC
846E   13                   ???
846F   1A                   ???
8470   A1 1B                LDA ($1B,X)
8472   46 1D                LSR $1D
8474   04                   ???
8475   1F                   ???
8476   DC                   ???
8477   20 D0 22             JSR $22D0
847A   DC                   ???
847B   24 10                BIT $10
847D   27                   ???
847E   5E 29 D6             LSR $D629,X
8481   2B                   ???
8482   72                   ???
8483   2E 38 31             ROL $3138
8486   26 34                ROL $34
8488   42                   ???
8489   37                   ???
848A   8C 3A 08             STY $083A
848D   3E B8 41             ROL $41B8,X
8490   A0 45                LDY #$45
8492   B8                   CLV
8493   49 20                EOR #$20
8495   4E BC 52             LSR $52BC
8498   AC 57 E4             LDY $E457
849B   5C                   ???
849C   70 62                BVS L8500
849E   4C 68 84             JMP L8468
84A1   6E 18 75             ROR $7518
84A4   10 7C                BPL L8522
84A6   70 83                BVS L842B
84A8   40                   RTI
84A9   8B                   ???
84AA   70 93                BVS L843F
84AC   40                   RTI
84AD   9C                   ???
84AE   78                   SEI
84AF   A5 58                LDA $58
84B1   AF                   ???
84B2   C8                   INY
84B3   B9 E0 C4             LDA $C4E0,Y
84B6   98                   TYA
84B7   D0 08                BNE L84C1
84B9   DD 30 EA             CMP $EA30,X
84BC   20 F8 2E             JSR $2EF8
84BF   FD 00 07             SBC $0700,X
84C2   0E 00 04             ASL $0400
84C5   02                   ???
84C6   04                   ???
84C7   22                   ???
84C8   0A                   ASL A
84C9   22                   ???
84CA   01 13                ORA ($13,X)
84CC   01 25                ORA ($25,X)
84CE   17                   ???
84CF   25 41                AND $41
84D1   41 41                EOR ($41,X)
84D3   46 26                LSR $26
84D5   43                   ???
84D6   10 02                BPL L84DA
84D8   10 FF                BPL L84D9
84DA   25 08      L84DA     AND $08
84DC   00                   BRK
84DD   41 FF                EOR ($FF,X)
84DF   00                   BRK
84E0   76 00                ROR $00,X
84E2   08                   PHP
84E3   3E 02 00             ROL $0002,X
84E6   01 1D                ORA ($1D,X)
84E8   01 00                ORA ($00,X)
84EA   00                   BRK
84EB   00                   BRK
84EC   01 80                ORA ($80,X)
84EE   00                   BRK
84EF   3E 09 34             ROL $3409,X
84F2   08                   PHP
84F3   C4 26                CPY $26
84F5   00                   BRK
84F6   00                   BRK
84F7   00                   BRK
84F8   00                   BRK
84F9   80                   ???
84FA   FA                   ???
84FB   00                   BRK
84FC   FF                   ???
84FD   FF                   ???
84FE   30 00                BMI L8500
8500   30 14      L8500     BMI L8516
8502   14                   ???
8503   81 15                STA ($15,X)
8505   50 A9                BVC L84B0
8507   00                   BRK
8508   8D 04 D4             STA $D404
850B   8D 0B D4             STA $D40B
850E   8D FF 84             STA $84FF
8511   AD FC 84             LDA $84FC
8514   29 0F                AND #$0F
8516   8D FC 84   L8516     STA $84FC
8519   0A                   ASL A
851A   0A                   ASL A
851B   0A                   ASL A
851C   0A                   ASL A
851D   A8                   TAY
851E   B9 54 94             LDA L9454,Y
8521   8D 05 85             STA $8505
8524   B9 55 94             LDA L9455,Y
8527   8D FE 84             STA $84FE
852A   B9 63 94             LDA $9463,Y
852D   8D 00 85             STA L8500
8530   B9 5C 94             LDA $945C,Y
8533   8D 02 85             STA $8502
8536   29 3F                AND #$3F
8538   8D 01 85             STA $8501
853B   B9 59 94             LDA $9459,Y
853E   8D 03 85             STA $8503
8541   B9 60 94             LDA $9460,Y
8544   8D 04 85             STA $8504
8547   A2 00                LDX #$00
8549   B9 55 94   L8549     LDA L9455,Y
854C   9D 00 D4             STA $D400,X
854F   C8                   INY
8550   E8                   INX
8551   E0 0E                CPX #$0E
8553   D0 F4                BNE L8549
8555   AD 05 85             LDA $8505
8558   29 30                AND #$30
855A   A0 EE                LDY #$EE
855C   C9 20                CMP #$20
855E   F0 02                BEQ L8562
8560   A0 CE                LDY #$CE
8562   8C B6 83   L8562     STY L83B6
8565   60                   RTS
8566   61 68                ADC ($68,X)
8568   6D 87 87             ADC $8787
856B   87                   ???
856C   18                   CLC
856D   59 A5 86             EOR $86A5,Y
8570   86 86                STX $86
8572   61 68                ADC ($68,X)
8574   6D 87 87             ADC $8787
8577   87                   ???
8578   29 56                AND #$56
857A   58                   CLI
857B   87                   ???
857C   87                   ???
857D   87                   ???
857E   74                   ???
857F   A2 B7                LDX #$B7
8581   BE FA 10             LDX $10FA,Y
8584   3C                   ???
8585   9F                   ???
8586   CB                   ???
8587   6B                   ???
8588   D7                   ???
8589   47                   ???
858A   59 58 7E             EOR $7E58,Y
858D   CD 79 CC             CMP $CC79
8590   DE E9 FB   L8590     DEC $FBE9,X
8593   1E 41 62             ASL $6241,X
8596   95 C8                STA $C8,X
8598   E9 F1                SBC #$F1
859A   F8                   SED
859B   C9 DA                CMP #$DA
859D   EB                   ???
859E   1B                   ???
859F   DD EE FF             CMP $FFEE,X
85A2   10 21                BPL L85C5
85A4   6A                   ROR A
85A5   AE B1 3A             LDX $3AB1
85A8   91 B6                STA ($B6),Y
85AA   3F                   ???
85AB   56 49                LSR $49,X
85AD   4B                   ???
85AE   8A                   TXA
85AF   AE DD 26             LDX $26DD
85B2   88                   DEY
85B3   9B                   ???
85B4   BC FD 3F             LDY $3FFD,X
85B7   66 91                ROR $91
85B9   BC 67 89             LDY $8967,X
85BC   AB                   ???
85BD   EB                   ???
85BE   2B                   ???
85BF   CC DE F2             CPY $F2DE
85C2   06 1A                ASL $1A
85C4   2E 35 4E             ROL $4E35
85C7   61 75                ADC ($75,X)
85C9   87                   ???
85CA   97                   ???
85CB   87                   ???
85CC   8D 8D 87             STA $878D
85CF   8D 88 8E             STA $8E88
85D2   88                   DEY
85D3   8E 89 89             STX $8989
85D6   8F                   ???
85D7   8F                   ???
85D8   8A                   TXA
85D9   8F                   ???
85DA   8A                   TXA
85DB   8F                   ???
85DC   8B                   ???
85DD   8B                   ???
85DE   8B                   ???
85DF   8B                   ???
85E0   8C 8C 8C             STY $8C8C
85E3   8C 8C 8C             STY $8C8C
85E6   8C 8C 8D             STY $8D8C
85E9   8D 8D 8E             STA $8E8D
85EC   8E 8E 8E             STX $8E8E
85EF   8F                   ???
85F0   8F                   ???
85F1   8F                   ???
85F2   87                   ???
85F3   87                   ???
85F4   8D 89 89             STA $8989
85F7   8D 8D 92             STA $928D
85FA   92                   ???
85FB   8F                   ???
85FC   8F                   ???
85FD   8F                   ???
85FE   90 90                BCC L8590
8600   90 90                BCC L8592
8602   90 91                BCC L8595
8604   8D 88 8E             STA $8E88
8607   91 91                STA ($91),Y
8609   91 91                STA ($91),Y
860B   92                   ???
860C   92                   ???
860D   92                   ???
860E   92                   ???
860F   93                   ???
8610   93                   ???
8611   93                   ???
8612   93                   ???
8613   93                   ???
8614   93                   ???
8615   93                   ???
8616   93                   ???
8617   93                   ???
8618   11 14                ORA ($14),Y
861A   17                   ???
861B   1A                   ???
861C   00                   BRK
861D   27                   ???
861E   00                   BRK
861F   28                   PLP
8620   03                   ???
8621   05 00                ORA $00
8623   27                   ???
8624   00                   BRK
8625   28                   PLP
8626   03                   ???
8627   05 07                ORA $07
8629   3A                   ???
862A   14                   ???
862B   17                   ???
862C   00                   BRK
862D   27                   ???
862E   00                   BRK
862F   28                   PLP
8630   2F                   ???
8631   30 31                BMI L8664
8633   31 32                AND ($32),Y
8635   33                   ???
8636   33                   ???
8637   34                   ???
8638   34                   ???
8639   34                   ???
863A   34                   ???
863B   34                   ???
863C   34                   ???
863D   34                   ???
863E   34                   ???
863F   35 35                AND $35,X
8641   35 35                AND $35,X
8643   35 35                AND $35,X
8645   36 12                ROL $12,X
8647   37                   ???
8648   38                   SEC
8649   09 2A                ORA #$2A
864B   09 2B                ORA #$2B
864D   09 0A                ORA #$0A
864F   09 2A                ORA #$2A
8651   09 2B                ORA #$2B
8653   09 0A                ORA #$0A
8655   0D 0D 0F             ORA $0F0D
8658   FF                   ???
8659   12                   ???
865A   15 18                ORA $18,X
865C   1B                   ???
865D   2D 39 39             AND $3939
8660   39 39 39             AND $3939,Y
8663   39 2C 39             AND $392C,Y
8666   39 39 39             AND $3939,Y
8669   39 39 2C             AND $2C39,Y
866C   39 39 39             AND $3939,Y
866F   01 01                ORA ($01,X)
8671   29 29                AND #$29
8673   2C 15 18             BIT $1815
8676   39 39 39             AND $3939,Y
8679   39 39 39             AND $3939,Y
867C   39 39 39             AND $3939,Y
867F   39 39 39             AND $3939,Y
8682   39 39 39             AND $3939,Y
8685   39 39 39             AND $3939,Y
8688   39 39 39             AND $3939,Y
868B   39 39 39             AND $3939,Y
868E   39 39 39             AND $3939,Y
8691   39 39 39             AND $3939,Y
8694   39 01 01             AND $0101,Y
8697   01 29                ORA ($29,X)
8699   39 39 39             AND $3939,Y
869C   01 01                ORA ($01,X)
869E   01 29                ORA ($29,X)
86A0   39 39 39             AND $3939,Y
86A3   39 FF 13             AND $13FF,Y
86A6   16 19                ASL $19,X
86A8   1C                   ???
86A9   02                   ???
86AA   02                   ???
86AB   1D 1E 02             ORA $021E,X
86AE   02                   ???
86AF   1D 1F 04             ORA $041F,X
86B2   04                   ???
86B3   20 20 06             JSR $0620
86B6   02                   ???
86B7   02                   ???
86B8   1D 1E 02             ORA $021E,X
86BB   02                   ???
86BC   1D 1F 04             ORA $041F,X
86BF   04                   ???
86C0   20 20 06             JSR $0620
86C3   08                   PHP
86C4   08                   PHP
86C5   08                   PHP
86C6   08                   PHP
86C7   21 21                AND ($21,X)
86C9   21 21                AND ($21,X)
86CB   22                   ???
86CC   22                   ???
86CD   22                   ???
86CE   23                   ???
86CF   22                   ???
86D0   24 25                BIT $25
86D2   3B                   ???
86D3   26 26                ROL $26
86D5   26 26                ROL $26
86D7   26 26                ROL $26
86D9   26 26                ROL $26
86DB   26 26                ROL $26
86DD   26 26                ROL $26
86DF   26 26                ROL $26
86E1   26 26                ROL $26
86E3   02                   ???
86E4   02                   ???
86E5   1D 1E 02             ORA $021E,X
86E8   02                   ???
86E9   1D 1F 2F             ORA $2F1F,X
86EC   2F                   ???
86ED   2F                   ???
86EE   2F                   ???
86EF   2F                   ???
86F0   2F                   ???
86F1   2F                   ???
86F2   2F                   ???
86F3   2F                   ???
86F4   2F                   ???
86F5   2F                   ???
86F6   2F                   ???
86F7   2F                   ???
86F8   0B                   ???
86F9   0B                   ???
86FA   1D 1D 0B             ORA $0B1D,X
86FD   0B                   ???
86FE   1D 0B 0B             ORA $0B0B,X
8701   0B                   ???
8702   0C                   ???
8703   0C                   ???
8704   1D 1D 1D             ORA $1D1D,X
8707   10 0B                BPL L8714
8709   0B                   ???
870A   1D 1D 0B             ORA $0B1D,X
870D   0B                   ???
870E   1D 0B 0B             ORA $0B0B,X
8711   0B                   ???
8712   0C                   ???
8713   0C                   ???
8714   1D 1D 1D   L8714     ORA $1D1D,X
8717   10 0B                BPL L8724
8719   1D 0B 1D             ORA $1D0B,X
871C   0B                   ???
871D   1D 0B 1D             ORA $1D0B,X
8720   0B                   ???
8721   0C                   ???
8722   1D 0B 0C             ORA $0C0B,X
8725   23                   ???
8726   0B                   ???
8727   0B                   ???
8728   FF                   ???
8729   46 47                LSR $47
872B   48                   PHA
872C   46 47                LSR $47
872E   48                   PHA
872F   49 49                EOR #$49
8731   49 49                EOR #$49
8733   49 49                EOR #$49
8735   49 49                EOR #$49
8737   4B                   ???
8738   4B                   ???
8739   4B                   ???
873A   4B                   ???
873B   4B                   ???
873C   4B                   ???
873D   4C 4A 4A             JMP $4A4A
8740   4A                   LSR A
8741   4A                   LSR A
8742   4A                   LSR A
8743   4A                   LSR A
8744   4A                   LSR A
8745   4A                   LSR A
8746   4A                   LSR A
8747   4A                   LSR A
8748   4A                   LSR A
8749   4A                   LSR A
874A   4A                   LSR A
874B   4A                   LSR A
874C   4A                   LSR A
874D   4A                   LSR A
874E   4B                   ???
874F   4B                   ???
8750   4B                   ???
8751   4B                   ???
8752   4B                   ???
8753   4B                   ???
8754   4C FF 41             JMP $41FF
8757   FF                   ???
8758   42                   ???
8759   42                   ???
875A   43                   ???
875B   43                   ???
875C   44                   ???
875D   44                   ???
875E   45 45                EOR $45
8760   FF                   ???
8761   3C                   ???
8762   3C                   ???
8763   3C                   ???
8764   3C                   ???
8765   3E 2E FE             ROL $FE2E,X
8768   0B                   ???
8769   0B                   ???
876A   40                   RTI
876B   2E FE 3D             ROL $3DFE
876E   3D 3D 3D             AND $3D3D,X
8771   3F                   ???
8772   2E FE 83             ROL $83FE
8775   00                   BRK
8776   37                   ???
8777   01 3E                ORA ($3E,X)
8779   01 3E                ORA ($3E,X)
877B   03                   ???
877C   3D 03 3E             AND $3E03,X
877F   03                   ???
8780   43                   ???
8781   03                   ???
8782   3E 03 3D             ROL $3D03,X
8785   03                   ???
8786   3E 03 37             ROL $3703,X
8789   01 3E                ORA ($3E,X)
878B   01 3E                ORA ($3E,X)
878D   03                   ???
878E   3D 03 3E             AND $3E03,X
8791   03                   ???
8792   43                   ???
8793   03                   ???
8794   42                   ???
8795   03                   ???
8796   43                   ???
8797   03                   ???
8798   45 03                EOR $03
879A   46 01                LSR $01
879C   48                   PHA
879D   01 46                ORA ($46,X)
879F   03                   ???
87A0   45 03                EOR $03
87A2   43                   ???
87A3   03                   ???
87A4   4B                   ???
87A5   01 4D                ORA ($4D,X)
87A7   01 4B                ORA ($4B,X)
87A9   03                   ???
87AA   4A                   LSR A
87AB   03                   ???
87AC   48                   PHA
87AD   FF                   ???
87AE   1F                   ???
87AF   4A                   LSR A
87B0   FF                   ???
87B1   03                   ???
87B2   46 01                LSR $01
87B4   48                   PHA
87B5   01 46                ORA ($46,X)
87B7   03                   ???
87B8   45 03                EOR $03
87BA   4A                   LSR A
87BB   0F                   ???
87BC   43                   ???
87BD   FF                   ???
87BE   BF                   ???
87BF   06 48                ASL $48
87C1   07                   ???
87C2   48                   PHA
87C3   01 4B                ORA ($4B,X)
87C5   01 4A                ORA ($4A,X)
87C7   01 4B                ORA ($4B,X)
87C9   01 4A                ORA ($4A,X)
87CB   03                   ???
87CC   4B                   ???
87CD   03                   ???
87CE   4D 03 4B             EOR $4B03
87D1   03                   ???
87D2   4A                   LSR A
87D3   3F                   ???
87D4   48                   PHA
87D5   07                   ???
87D6   48                   PHA
87D7   01 4B                ORA ($4B,X)
87D9   01 4A                ORA ($4A,X)
87DB   01 4B                ORA ($4B,X)
87DD   01 4A                ORA ($4A,X)
87DF   03                   ???
87E0   4B                   ???
87E1   03                   ???
87E2   4D 03 4B             EOR $4B03
87E5   03                   ???
87E6   48                   PHA
87E7   3F                   ???
87E8   4C 07 4C             JMP $4C07
87EB   01 4F                ORA ($4F,X)
87ED   01 4E                ORA ($4E,X)
87EF   01 4F                ORA ($4F,X)
87F1   01 4E                ORA ($4E,X)
87F3   03                   ???
87F4   4F                   ???
87F5   03                   ???
87F6   51 03                EOR ($03),Y
87F8   4F                   ???
87F9   03                   ???
87FA   4E 3F 4C             LSR $4C3F
87FD   07                   ???
87FE   4C 01 4F             JMP $4F01
8801   01 4E                ORA ($4E,X)
8803   01 4F                ORA ($4F,X)
8805   01 4E                ORA ($4E,X)
8807   03                   ???
8808   4F                   ???
8809   03                   ???
880A   51 03                EOR ($03),Y
880C   4F                   ???
880D   03                   ???
880E   4C FF 83             JMP L83FF
8811   04                   ???
8812   26 03                ROL $03
8814   29 03                AND #$03
8816   28                   PLP
8817   03                   ???
8818   29 03                AND #$03
881A   26 03                ROL $03
881C   35 03                AND $03,X
881E   34                   ???
881F   03                   ???
8820   32                   ???
8821   03                   ???
8822   2D 03 30             AND $3003
8825   03                   ???
8826   2F                   ???
8827   03                   ???
8828   30 03                BMI L882D
882A   2D 03 3C             AND $3C03
882D   03         L882D     ???
882E   3B                   ???
882F   03                   ???
8830   39 03 30             AND $3003,Y
8833   03                   ???
8834   33                   ???
8835   03                   ???
8836   32                   ???
8837   03                   ???
8838   33                   ???
8839   03                   ???
883A   30 03                BMI L883F
883C   3F                   ???
883D   03                   ???
883E   3E 03 3C             ROL $3C03,X
8841   03                   ???
8842   46 03                LSR $03
8844   45 03                EOR $03
8846   43                   ???
8847   03                   ???
8848   3A                   ???
8849   03                   ???
884A   39 03 37             AND $3703,Y
884D   03                   ???
884E   2E 03 2D             ROL $2D03
8851   03                   ???
8852   26 03                ROL $03
8854   29 03                AND #$03
8856   28                   PLP
8857   03                   ???
8858   29 03                AND #$03
885A   26 03                ROL $03
885C   35 03                AND $03,X
885E   34                   ???
885F   03                   ???
8860   32                   ???
8861   03                   ???
8862   2D 03 30             AND $3003
8865   03                   ???
8866   2F                   ???
8867   03                   ???
8868   30 03                BMI L886D
886A   2D 03 3C             AND $3C03
886D   03         L886D     ???
886E   3B                   ???
886F   03                   ???
8870   39 03 30             AND $3003,Y
8873   03                   ???
8874   33                   ???
8875   03                   ???
8876   32                   ???
8877   03                   ???
8878   33                   ???
8879   03                   ???
887A   30 03                BMI L887F
887C   3F                   ???
887D   03                   ???
887E   3E 03 3C             ROL $3C03,X
8881   03                   ???
8882   34                   ???
8883   03                   ???
8884   37                   ???
8885   03                   ???
8886   36 03                ROL $03,X
8888   37                   ???
8889   03                   ???
888A   34                   ???
888B   03                   ???
888C   37                   ???
888D   03                   ???
888E   3A                   ???
888F   03                   ???
8890   3D 03 3E             AND $3E03,X
8893   07                   ???
8894   3E 07 3F             ROL $3F07,X
8897   07                   ???
8898   3E 03 3C             ROL $3C03,X
889B   07                   ???
889C   3E 57 FF             ROL $FF57,X
889F   8B                   ???
88A0   00                   BRK
88A1   3A                   ???
88A2   01 3A                ORA ($3A,X)
88A4   01 3C                ORA ($3C,X)
88A6   03                   ???
88A7   3D 03 3F             AND $3F03,X
88AA   03                   ???
88AB   3D 03 3C             AND $3C03,X
88AE   0B                   ???
88AF   3A                   ???
88B0   03                   ???
88B1   39 07 3A             AND $3A07,Y
88B4   81 06                STA ($06,X)
88B6   4B                   ???
88B7   01 4D                ORA ($4D,X)
88B9   01 4E                ORA ($4E,X)
88BB   01 4D                ORA ($4D,X)
88BD   01 4E                ORA ($4E,X)
88BF   01 4D                ORA ($4D,X)
88C1   05 4B                ORA $4B
88C3   81 00                STA ($00,X)
88C5   3A                   ???
88C6   01 3C                ORA ($3C,X)
88C8   01 3D                ORA ($3D,X)
88CA   03                   ???
88CB   3F                   ???
88CC   03                   ???
88CD   3D 03 3C             AND $3C03,X
88D0   03                   ???
88D1   3A                   ???
88D2   03                   ???
88D3   39 1B 3A             AND $3A1B,Y
88D6   0B                   ???
88D7   3B                   ???
88D8   01 3B                ORA ($3B,X)
88DA   01 3D                ORA ($3D,X)
88DC   03                   ???
88DD   3E 03 40             ROL $4003,X
88E0   03                   ???
88E1   3E 03 3D             ROL $3D03,X
88E4   0B                   ???
88E5   3B                   ???
88E6   03                   ???
88E7   3A                   ???
88E8   07                   ???
88E9   3B                   ???
88EA   81 06                STA ($06,X)
88EC   4C 01 4E             JMP $4E01
88EF   01 4F                ORA ($4F,X)
88F1   01 4E                ORA ($4E,X)
88F3   01 4F                ORA ($4F,X)
88F5   01 4E                ORA ($4E,X)
88F7   05 4C                ORA $4C
88F9   81 00                STA ($00,X)
88FB   3B                   ???
88FC   01 3D                ORA ($3D,X)
88FE   01 3E                ORA ($3E,X)
8900   03                   ???
8901   40                   RTI
8902   03                   ???
8903   3E 03 3D             ROL $3D03,X
8906   03                   ???
8907   3B                   ???
8908   03                   ???
8909   3A                   ???
890A   1B                   ???
890B   3B                   ???
890C   8B                   ???
890D   05 35                ORA $35
890F   03                   ???
8910   33                   ???
8911   07                   ???
8912   32                   ???
8913   03                   ???
8914   30 03                BMI L8919
8916   2F                   ???
8917   0B                   ???
8918   30 03                BMI L891D
891A   32                   ???
891B   0F                   ???
891C   30 0B                BMI L8929
891E   35 03                AND $03,X
8920   33                   ???
8921   07                   ???
8922   32                   ???
8923   03                   ???
8924   30 03                BMI L8929
8926   2F                   ???
8927   1F                   ???
8928   30 8B                BMI L88B5
892A   00                   BRK
892B   3C                   ???
892C   01 3C                ORA ($3C,X)
892E   01 3E                ORA ($3E,X)
8930   03                   ???
8931   3F                   ???
8932   03                   ???
8933   41 03                EOR ($03,X)
8935   3F                   ???
8936   03                   ???
8937   3E 0B 3D             ROL $3D0B,X
893A   01 3D                ORA ($3D,X)
893C   01 3F                ORA ($3F,X)
893E   03                   ???
893F   40                   RTI
8940   03                   ???
8941   42                   ???
8942   03                   ???
8943   40                   RTI
8944   03                   ???
8945   3F                   ???
8946   03                   ???
8947   3E 01 3E             ROL $3E01,X
894A   01 40                ORA ($40,X)
894C   03                   ???
894D   41 03                EOR ($03,X)
894F   40                   RTI
8950   03                   ???
8951   3E 03 3D             ROL $3D03,X
8954   03                   ???
8955   3E 03 3C             ROL $3C03,X
8958   03                   ???
8959   3A                   ???
895A   01 3A                ORA ($3A,X)
895C   01 3C                ORA ($3C,X)
895E   03                   ???
895F   3D 03 3C             AND $3C03,X
8962   03                   ???
8963   3A                   ???
8964   03                   ???
8965   39 03 3A             AND $3A03,Y
8968   03                   ???
8969   3C                   ???
896A   FF                   ???
896B   83                   ???
896C   00                   BRK
896D   32                   ???
896E   01 35                ORA ($35,X)
8970   01 34                ORA ($34,X)
8972   03                   ???
8973   32                   ???
8974   03                   ???
8975   35 03                AND $03,X
8977   34                   ???
8978   03                   ???
8979   32                   ???
897A   03                   ???
897B   35 01                AND $01,X
897D   34                   ???
897E   01 32                ORA ($32,X)
8980   03                   ???
8981   32                   ???
8982   03                   ???
8983   3A                   ???
8984   03                   ???
8985   39 03 3A             AND $3A03,Y
8988   03                   ???
8989   32                   ???
898A   03                   ???
898B   3A                   ???
898C   03                   ???
898D   39 03 3A             AND $3A03,Y
8990   FF                   ???
8991   03                   ???
8992   34                   ???
8993   01 37                ORA ($37,X)
8995   01 35                ORA ($35,X)
8997   03                   ???
8998   34                   ???
8999   03                   ???
899A   37                   ???
899B   03                   ???
899C   35 03                AND $03,X
899E   34                   ???
899F   03                   ???
89A0   37                   ???
89A1   01 35                ORA ($35,X)
89A3   01 34                ORA ($34,X)
89A5   03                   ???
89A6   34                   ???
89A7   03                   ???
89A8   3A                   ???
89A9   03                   ???
89AA   39 03 3A             AND $3A03,Y
89AD   03                   ???
89AE   34                   ???
89AF   03                   ???
89B0   3A                   ???
89B1   03                   ???
89B2   39 03 3A             AND $3A03,Y
89B5   FF                   ???
89B6   03                   ???
89B7   39 03 38             AND $3803,Y
89BA   03                   ???
89BB   39 03 3A             AND $3A03,Y
89BE   03                   ???
89BF   39 03 37             AND $3703,Y
89C2   03                   ???
89C3   35 03                AND $03,X
89C5   34                   ???
89C6   03                   ???
89C7   35 03                AND $03,X
89C9   34                   ???
89CA   03                   ???
89CB   35 03                AND $03,X
89CD   37                   ???
89CE   03                   ???
89CF   35 03                AND $03,X
89D1   34                   ???
89D2   03                   ???
89D3   32                   ???
89D4   03                   ???
89D5   31 FF                AND ($FF),Y
89D7   03                   ???
89D8   37                   ???
89D9   01 3A                ORA ($3A,X)
89DB   01 39                ORA ($39,X)
89DD   03                   ???
89DE   37                   ???
89DF   03                   ???
89E0   3A                   ???
89E1   03                   ???
89E2   39 03 37             AND $3703,Y
89E5   03                   ???
89E6   3A                   ???
89E7   01 39                ORA ($39,X)
89E9   01 37                ORA ($37,X)
89EB   03                   ???
89EC   37                   ???
89ED   03                   ???
89EE   3E 03 3D             ROL $3D03,X
89F1   03                   ???
89F2   3E 03 37             ROL $3703,X
89F5   03                   ???
89F6   3E 03 3D             ROL $3D03,X
89F9   03                   ???
89FA   3E 03 3D             ROL $3D03,X
89FD   01 40                ORA ($40,X)
89FF   01 3E                ORA ($3E,X)
8A01   03                   ???
8A02   3D 03 40             AND $4003,X
8A05   01 3E                ORA ($3E,X)
8A07   01 3D                ORA ($3D,X)
8A09   03                   ???
8A0A   40                   RTI
8A0B   03                   ???
8A0C   3E 03 40             ROL $4003,X
8A0F   03                   ???
8A10   40                   RTI
8A11   01 43                ORA ($43,X)
8A13   01 41                ORA ($41,X)
8A15   03                   ???
8A16   40                   RTI
8A17   03                   ???
8A18   43                   ???
8A19   01 41                ORA ($41,X)
8A1B   01 40                ORA ($40,X)
8A1D   03                   ???
8A1E   43                   ???
8A1F   03                   ???
8A20   41 03                EOR ($03,X)
8A22   43                   ???
8A23   03                   ???
8A24   43                   ???
8A25   01 46                ORA ($46,X)
8A27   01 45                ORA ($45,X)
8A29   03                   ???
8A2A   43                   ???
8A2B   03                   ???
8A2C   46 01                LSR $01
8A2E   45 01                EOR $01
8A30   43                   ???
8A31   03                   ???
8A32   46 03                LSR $03
8A34   45 03                EOR $03
8A36   43                   ???
8A37   01 48                ORA ($48,X)
8A39   01 49                ORA ($49,X)
8A3B   01 48                ORA ($48,X)
8A3D   01 46                ORA ($46,X)
8A3F   01 45                ORA ($45,X)
8A41   01 46                ORA ($46,X)
8A43   01 45                ORA ($45,X)
8A45   01 43                ORA ($43,X)
8A47   01 41                ORA ($41,X)
8A49   01 43                ORA ($43,X)
8A4B   01 41                ORA ($41,X)
8A4D   01 40                ORA ($40,X)
8A4F   01 3D                ORA ($3D,X)
8A51   01 39                ORA ($39,X)
8A53   01 3B                ORA ($3B,X)
8A55   01 3D                ORA ($3D,X)
8A57   FF                   ???
8A58   01 3E                ORA ($3E,X)
8A5A   01 39                ORA ($39,X)
8A5C   01 35                ORA ($35,X)
8A5E   01 39                ORA ($39,X)
8A60   01 3E                ORA ($3E,X)
8A62   01 39                ORA ($39,X)
8A64   01 35                ORA ($35,X)
8A66   01 39                ORA ($39,X)
8A68   03                   ???
8A69   3E 01 41             ROL $4101,X
8A6C   01 40                ORA ($40,X)
8A6E   03                   ???
8A6F   40                   RTI
8A70   01 3D                ORA ($3D,X)
8A72   01 3E                ORA ($3E,X)
8A74   01 40                ORA ($40,X)
8A76   01 3D                ORA ($3D,X)
8A78   01 39                ORA ($39,X)
8A7A   01 3D                ORA ($3D,X)
8A7C   01 40                ORA ($40,X)
8A7E   01 3D                ORA ($3D,X)
8A80   01 39                ORA ($39,X)
8A82   01 3D                ORA ($3D,X)
8A84   03                   ???
8A85   40                   RTI
8A86   01 43                ORA ($43,X)
8A88   01 41                ORA ($41,X)
8A8A   03                   ???
8A8B   41 01                EOR ($01,X)
8A8D   3E 01 40             ROL $4001,X
8A90   01 41                ORA ($41,X)
8A92   01 3E                ORA ($3E,X)
8A94   01 39                ORA ($39,X)
8A96   01 3E                ORA ($3E,X)
8A98   01 41                ORA ($41,X)
8A9A   01 3E                ORA ($3E,X)
8A9C   01 39                ORA ($39,X)
8A9E   01 3E                ORA ($3E,X)
8AA0   03                   ???
8AA1   41 01                EOR ($01,X)
8AA3   45 01                EOR $01
8AA5   43                   ???
8AA6   03                   ???
8AA7   43                   ???
8AA8   01 40                ORA ($40,X)
8AAA   01 41                ORA ($41,X)
8AAC   01 43                ORA ($43,X)
8AAE   01 40                ORA ($40,X)
8AB0   01 3D                ORA ($3D,X)
8AB2   01 40                ORA ($40,X)
8AB4   01 43                ORA ($43,X)
8AB6   01 40                ORA ($40,X)
8AB8   01 3D                ORA ($3D,X)
8ABA   01 40                ORA ($40,X)
8ABC   01 46                ORA ($46,X)
8ABE   01 43                ORA ($43,X)
8AC0   01 45                ORA ($45,X)
8AC2   01 46                ORA ($46,X)
8AC4   01 44                ORA ($44,X)
8AC6   01 43                ORA ($43,X)
8AC8   01 40                ORA ($40,X)
8ACA   01 3D                ORA ($3D,X)
8ACC   FF                   ???
8ACD   01 3E                ORA ($3E,X)
8ACF   01 39                ORA ($39,X)
8AD1   01 35                ORA ($35,X)
8AD3   01 39                ORA ($39,X)
8AD5   01 3E                ORA ($3E,X)
8AD7   01 39                ORA ($39,X)
8AD9   01 35                ORA ($35,X)
8ADB   01 39                ORA ($39,X)
8ADD   01 3E                ORA ($3E,X)
8ADF   01 39                ORA ($39,X)
8AE1   01 35                ORA ($35,X)
8AE3   01 39                ORA ($39,X)
8AE5   01 3E                ORA ($3E,X)
8AE7   01 39                ORA ($39,X)
8AE9   01 35                ORA ($35,X)
8AEB   01 39                ORA ($39,X)
8AED   01 3E                ORA ($3E,X)
8AEF   01 3A                ORA ($3A,X)
8AF1   01 37                ORA ($37,X)
8AF3   01 3A                ORA ($3A,X)
8AF5   01 3E                ORA ($3E,X)
8AF7   01 3A                ORA ($3A,X)
8AF9   01 37                ORA ($37,X)
8AFB   01 3A                ORA ($3A,X)
8AFD   01 3E                ORA ($3E,X)
8AFF   01 3A                ORA ($3A,X)
8B01   01 37                ORA ($37,X)
8B03   01 3A                ORA ($3A,X)
8B05   01 3E                ORA ($3E,X)
8B07   01 3A                ORA ($3A,X)
8B09   01 37                ORA ($37,X)
8B0B   01 3A                ORA ($3A,X)
8B0D   01 40                ORA ($40,X)
8B0F   01 3D                ORA ($3D,X)
8B11   01 39                ORA ($39,X)
8B13   01 3D                ORA ($3D,X)
8B15   01 40                ORA ($40,X)
8B17   01 3D                ORA ($3D,X)
8B19   01 39                ORA ($39,X)
8B1B   01 3D                ORA ($3D,X)
8B1D   01 40                ORA ($40,X)
8B1F   01 3D                ORA ($3D,X)
8B21   01 39                ORA ($39,X)
8B23   01 3D                ORA ($3D,X)
8B25   01 40                ORA ($40,X)
8B27   01 3D                ORA ($3D,X)
8B29   01 39                ORA ($39,X)
8B2B   01 3D                ORA ($3D,X)
8B2D   01 41                ORA ($41,X)
8B2F   01 3E                ORA ($3E,X)
8B31   01 39                ORA ($39,X)
8B33   01 3E                ORA ($3E,X)
8B35   01 41                ORA ($41,X)
8B37   01 3E                ORA ($3E,X)
8B39   01 39                ORA ($39,X)
8B3B   01 3E                ORA ($3E,X)
8B3D   01 41                ORA ($41,X)
8B3F   01 3E                ORA ($3E,X)
8B41   01 39                ORA ($39,X)
8B43   01 3E                ORA ($3E,X)
8B45   01 41                ORA ($41,X)
8B47   01 3E                ORA ($3E,X)
8B49   01 39                ORA ($39,X)
8B4B   01 3E                ORA ($3E,X)
8B4D   01 43                ORA ($43,X)
8B4F   01 3E                ORA ($3E,X)
8B51   01 3A                ORA ($3A,X)
8B53   01 3E                ORA ($3E,X)
8B55   01 43                ORA ($43,X)
8B57   01 3E                ORA ($3E,X)
8B59   01 3A                ORA ($3A,X)
8B5B   01 3E                ORA ($3E,X)
8B5D   01 43                ORA ($43,X)
8B5F   01 3E                ORA ($3E,X)
8B61   01 3A                ORA ($3A,X)
8B63   01 3E                ORA ($3E,X)
8B65   01 43                ORA ($43,X)
8B67   01 3E                ORA ($3E,X)
8B69   01 3A                ORA ($3A,X)
8B6B   01 3E                ORA ($3E,X)
8B6D   01 43                ORA ($43,X)
8B6F   01 3F                ORA ($3F,X)
8B71   01 3C                ORA ($3C,X)
8B73   01 3F                ORA ($3F,X)
8B75   01 43                ORA ($43,X)
8B77   01 3F                ORA ($3F,X)
8B79   01 3C                ORA ($3C,X)
8B7B   01 3F                ORA ($3F,X)
8B7D   01 43                ORA ($43,X)
8B7F   01 3F                ORA ($3F,X)
8B81   01 3C                ORA ($3C,X)
8B83   01 3F                ORA ($3F,X)
8B85   01 43                ORA ($43,X)
8B87   01 3F                ORA ($3F,X)
8B89   01 3C                ORA ($3C,X)
8B8B   01 3F                ORA ($3F,X)
8B8D   01 45                ORA ($45,X)
8B8F   01 42                ORA ($42,X)
8B91   01 3C                ORA ($3C,X)
8B93   01 42                ORA ($42,X)
8B95   01 45                ORA ($45,X)
8B97   01 42                ORA ($42,X)
8B99   01 3C                ORA ($3C,X)
8B9B   01 42                ORA ($42,X)
8B9D   01 48                ORA ($48,X)
8B9F   01 45                ORA ($45,X)
8BA1   01 42                ORA ($42,X)
8BA3   01 45                ORA ($45,X)
8BA5   01 4B                ORA ($4B,X)
8BA7   01 48                ORA ($48,X)
8BA9   01 45                ORA ($45,X)
8BAB   01 48                ORA ($48,X)
8BAD   01 4B                ORA ($4B,X)
8BAF   01 4A                ORA ($4A,X)
8BB1   01 48                ORA ($48,X)
8BB3   01 4A                ORA ($4A,X)
8BB5   01 4B                ORA ($4B,X)
8BB7   01 4A                ORA ($4A,X)
8BB9   01 48                ORA ($48,X)
8BBB   01 4A                ORA ($4A,X)
8BBD   01 4B                ORA ($4B,X)
8BBF   01 4A                ORA ($4A,X)
8BC1   01 48                ORA ($48,X)
8BC3   01 4A                ORA ($4A,X)
8BC5   01 4C                ORA ($4C,X)
8BC7   01 4E                ORA ($4E,X)
8BC9   03                   ???
8BCA   4F                   ???
8BCB   FF                   ???
8BCC   BF                   ???
8BCD   06 56                ASL $56
8BCF   1F                   ???
8BD0   57                   ???
8BD1   1F                   ???
8BD2   56 1F                LSR $1F,X
8BD4   5B                   ???
8BD5   1F                   ???
8BD6   56 1F                LSR $1F,X
8BD8   57                   ???
8BD9   1F                   ???
8BDA   56 1F                LSR $1F,X
8BDC   4F                   ???
8BDD   FF                   ???
8BDE   BF                   ???
8BDF   0C                   ???
8BE0   68                   PLA
8BE1   7F                   ???
8BE2   7F                   ???
8BE3   7F                   ???
8BE4   7F                   ???
8BE5   7F                   ???
8BE6   7F                   ???
8BE7   7F                   ???
8BE8   FF                   ???
8BE9   BF                   ???
8BEA   08                   PHP
8BEB   13                   ???
8BEC   3F                   ???
8BED   13                   ???
8BEE   3F                   ???
8BEF   13                   ???
8BF0   3F                   ???
8BF1   13                   ???
8BF2   3F                   ???
8BF3   13                   ???
8BF4   3F                   ???
8BF5   13                   ???
8BF6   3F                   ???
8BF7   13                   ???
8BF8   1F                   ???
8BF9   13                   ???
8BFA   FF                   ???
8BFB   97                   ???
8BFC   09 2E                ORA #$2E
8BFE   03                   ???
8BFF   2E 1B 32             ROL $321B
8C02   03                   ???
8C03   32                   ???
8C04   1B                   ???
8C05   31 03                AND ($03),Y
8C07   31 1F                AND ($1F),Y
8C09   34                   ???
8C0A   43                   ???
8C0B   17                   ???
8C0C   32                   ???
8C0D   03                   ???
8C0E   32                   ???
8C0F   1B                   ???
8C10   35 03                AND $03,X
8C12   35 1B                AND $1B,X
8C14   34                   ???
8C15   03                   ???
8C16   34                   ???
8C17   0F                   ???
8C18   37                   ???
8C19   8F                   ???
8C1A   0A                   ASL A
8C1B   37                   ???
8C1C   43                   ???
8C1D   FF                   ???
8C1E   97                   ???
8C1F   09 2B                ORA #$2B
8C21   03                   ???
8C22   2B                   ???
8C23   1B                   ???
8C24   2E 03 2E             ROL $2E03
8C27   1B                   ???
8C28   2D 03 2D             AND $2D03
8C2B   1F                   ???
8C2C   30 43                BMI L8C71
8C2E   17                   ???
8C2F   2E 03 2E             ROL $2E03
8C32   1B                   ???
8C33   32                   ???
8C34   03                   ???
8C35   32                   ???
8C36   1B                   ???
8C37   31 03                AND ($03),Y
8C39   31 0F                AND ($0F),Y
8C3B   34                   ???
8C3C   8F                   ???
8C3D   0A                   ASL A
8C3E   34                   ???
8C3F   43                   ???
8C40   FF                   ???
8C41   0F                   ???
8C42   1F                   ???
8C43   0F                   ???
8C44   1F                   ???
8C45   0F                   ???
8C46   1F                   ???
8C47   0F                   ???
8C48   1F                   ???
8C49   0F                   ???
8C4A   1F                   ???
8C4B   0F                   ???
8C4C   1F                   ???
8C4D   0F                   ???
8C4E   1F                   ???
8C4F   0F                   ???
8C50   1F                   ???
8C51   0F                   ???
8C52   1F                   ???
8C53   0F                   ???
8C54   1F                   ???
8C55   0F                   ???
8C56   1F                   ???
8C57   0F                   ???
8C58   1F                   ???
8C59   0F                   ???
8C5A   1F                   ???
8C5B   0F                   ???
8C5C   1F                   ???
8C5D   0F                   ???
8C5E   1F                   ???
8C5F   0F                   ???
8C60   1F                   ???
8C61   FF                   ???
8C62   97                   ???
8C63   09 33                ORA #$33
8C65   03                   ???
8C66   33                   ???
8C67   1B                   ???
8C68   37                   ???
8C69   03                   ???
8C6A   37                   ???
8C6B   1B                   ???
8C6C   36 03                ROL $03,X
8C6E   36 1F                ROL $1F,X
8C70   39 43 17             AND $1743,Y
8C73   37                   ???
8C74   03                   ???
8C75   37                   ???
8C76   1B                   ???
8C77   3A                   ???
8C78   03                   ???
8C79   3A                   ???
8C7A   1B                   ???
8C7B   39 03 39             AND $3903,Y
8C7E   2F                   ???
8C7F   3C                   ???
8C80   21 3C                AND ($3C,X)
8C82   21 3D                AND ($3D,X)
8C84   21 3E                AND ($3E,X)
8C86   21 3F                AND ($3F,X)
8C88   21 40                AND ($40,X)
8C8A   21 41                AND ($41,X)
8C8C   21 42                AND ($42,X)
8C8E   21 43                AND ($43,X)
8C90   21 44                AND ($44,X)
8C92   01 45                ORA ($45,X)
8C94   FF                   ???
8C95   97                   ???
8C96   09 30                ORA #$30
8C98   03                   ???
8C99   30 1B                BMI L8CB6
8C9B   33                   ???
8C9C   03                   ???
8C9D   33                   ???
8C9E   1B                   ???
8C9F   32                   ???
8CA0   03                   ???
8CA1   32                   ???
8CA2   1F                   ???
8CA3   36 43                ROL $43,X
8CA5   17                   ???
8CA6   33                   ???
8CA7   03                   ???
8CA8   33                   ???
8CA9   1B                   ???
8CAA   37                   ???
8CAB   03                   ???
8CAC   37                   ???
8CAD   1B                   ???
8CAE   36 03                ROL $03,X
8CB0   36 2F                ROL $2F,X
8CB2   39 21 39             AND $3921,Y
8CB5   21 3A                AND ($3A,X)
8CB7   21 3B                AND ($3B,X)
8CB9   21 3C                AND ($3C,X)
8CBB   21 3D                AND ($3D,X)
8CBD   21 3E                AND ($3E,X)
8CBF   21 3F                AND ($3F,X)
8CC1   21 40                AND ($40,X)
8CC3   21 41                AND ($41,X)
8CC5   01 42                ORA ($42,X)
8CC7   FF                   ???
8CC8   0F                   ???
8CC9   1A                   ???
8CCA   0F                   ???
8CCB   1A                   ???
8CCC   0F                   ???
8CCD   1A                   ???
8CCE   0F                   ???
8CCF   1A                   ???
8CD0   0F                   ???
8CD1   1A                   ???
8CD2   0F                   ???
8CD3   1A                   ???
8CD4   0F                   ???
8CD5   1A                   ???
8CD6   0F                   ???
8CD7   1A                   ???
8CD8   0F                   ???
8CD9   1A                   ???
8CDA   0F                   ???
8CDB   1A                   ???
8CDC   0F                   ???
8CDD   1A                   ???
8CDE   0F                   ???
8CDF   1A                   ???
8CE0   0F                   ???
8CE1   1A                   ???
8CE2   0F                   ???
8CE3   1A                   ???
8CE4   0F                   ???
8CE5   1A                   ???
8CE6   0F                   ???
8CE7   1A                   ???
8CE8   FF                   ???
8CE9   1F                   ???
8CEA   46 BF                LSR $BF
8CEC   0A                   ASL A
8CED   46 7F                LSR $7F
8CEF   7F                   ???
8CF0   FF                   ???
8CF1   1F                   ???
8CF2   43                   ???
8CF3   BF                   ???
8CF4   0A                   ASL A
8CF5   43                   ???
8CF6   7F                   ???
8CF7   FF                   ???
8CF8   83                   ???
8CF9   02                   ???
8CFA   13                   ???
8CFB   03                   ???
8CFC   13                   ???
8CFD   03                   ???
8CFE   1E 03 1F             ASL $1F03,X
8D01   03                   ???
8D02   13                   ???
8D03   03                   ???
8D04   13                   ???
8D05   03                   ???
8D06   1E 03 1F             ASL $1F03,X
8D09   03                   ???
8D0A   13                   ???
8D0B   03                   ???
8D0C   13                   ???
8D0D   03                   ???
8D0E   1E 03 1F             ASL $1F03,X
8D11   03                   ???
8D12   13                   ???
8D13   03                   ???
8D14   13                   ???
8D15   03                   ???
8D16   1E 03 1F             ASL $1F03,X
8D19   03                   ???
8D1A   13                   ???
8D1B   03                   ???
8D1C   13                   ???
8D1D   03                   ???
8D1E   1E 03 1F             ASL $1F03,X
8D21   03                   ???
8D22   13                   ???
8D23   03                   ???
8D24   13                   ???
8D25   03                   ???
8D26   1E 03 1F             ASL $1F03,X
8D29   03                   ???
8D2A   13                   ???
8D2B   03                   ???
8D2C   13                   ???
8D2D   03                   ???
8D2E   1E 03 1F             ASL $1F03,X
8D31   03                   ???
8D32   13                   ???
8D33   03                   ???
8D34   13                   ???
8D35   03                   ???
8D36   1E 03 1F             ASL $1F03,X
8D39   FF                   ???
8D3A   8F                   ???
8D3B   0B                   ???
8D3C   38                   SEC
8D3D   4F                   ???
8D3E   FF                   ???
8D3F   83                   ???
8D40   0E 32 07             ASL $0732
8D43   32                   ???
8D44   07                   ???
8D45   2F                   ???
8D46   07                   ???
8D47   2F                   ???
8D48   03                   ???
8D49   2B                   ???
8D4A   87                   ???
8D4B   0B                   ???
8D4C   46 83                LSR $83
8D4E   0E 2C 03             ASL $032C
8D51   2C 8F 0B             BIT $0B8F
8D54   32                   ???
8D55   FF                   ???
8D56   43                   ???
8D57   83                   ???
8D58   0E 32 03             ASL $0332
8D5B   32                   ???
8D5C   03                   ???
8D5D   2F                   ???
8D5E   03                   ???
8D5F   2F                   ???
8D60   03                   ???
8D61   2C 87 0B             BIT $0B87
8D64   38                   SEC
8D65   FF                   ???
8D66   83                   ???
8D67   01 43                ORA ($43,X)
8D69   01 4F                ORA ($4F,X)
8D6B   01 5B                ORA ($5B,X)
8D6D   87                   ???
8D6E   03                   ???
8D6F   2F                   ???
8D70   83                   ???
8D71   01 43                ORA ($43,X)
8D73   01 4F                ORA ($4F,X)
8D75   01 5B                ORA ($5B,X)
8D77   87                   ???
8D78   03                   ???
8D79   2F                   ???
8D7A   83                   ???
8D7B   01 43                ORA ($43,X)
8D7D   01 4F                ORA ($4F,X)
8D7F   01 5B                ORA ($5B,X)
8D81   87                   ???
8D82   03                   ???
8D83   2F                   ???
8D84   83                   ???
8D85   01 43                ORA ($43,X)
8D87   01 4F                ORA ($4F,X)
8D89   01 5B                ORA ($5B,X)
8D8B   87                   ???
8D8C   03                   ???
8D8D   2F                   ???
8D8E   83                   ???
8D8F   01 43                ORA ($43,X)
8D91   01 4F                ORA ($4F,X)
8D93   01 5B                ORA ($5B,X)
8D95   87                   ???
8D96   03                   ???
8D97   2F                   ???
8D98   83                   ???
8D99   01 43                ORA ($43,X)
8D9B   01 4F                ORA ($4F,X)
8D9D   01 5B                ORA ($5B,X)
8D9F   87                   ???
8DA0   03                   ???
8DA1   2F                   ???
8DA2   83                   ???
8DA3   01 43                ORA ($43,X)
8DA5   01 4F                ORA ($4F,X)
8DA7   01 5B                ORA ($5B,X)
8DA9   87                   ???
8DAA   03                   ???
8DAB   2F                   ???
8DAC   83                   ???
8DAD   01 43                ORA ($43,X)
8DAF   01 4F                ORA ($4F,X)
8DB1   01 5B                ORA ($5B,X)
8DB3   87                   ???
8DB4   03                   ???
8DB5   2F                   ???
8DB6   FF                   ???
8DB7   83                   ???
8DB8   02                   ???
8DB9   13                   ???
8DBA   03                   ???
8DBB   13                   ???
8DBC   03                   ???
8DBD   1F                   ???
8DBE   03                   ???
8DBF   1F                   ???
8DC0   03                   ???
8DC1   13                   ???
8DC2   03                   ???
8DC3   13                   ???
8DC4   03                   ???
8DC5   1F                   ???
8DC6   03                   ???
8DC7   1F                   ???
8DC8   FF                   ???
8DC9   03                   ???
8DCA   15 03                ORA $03,X
8DCC   15 03                ORA $03,X
8DCE   1F                   ???
8DCF   03                   ???
8DD0   21 03                AND ($03,X)
8DD2   15 03                ORA $03,X
8DD4   15 03                ORA $03,X
8DD6   1F                   ???
8DD7   03                   ???
8DD8   21 FF                AND ($FF,X)
8DDA   03                   ???
8DDB   1A                   ???
8DDC   03                   ???
8DDD   1A                   ???
8DDE   03                   ???
8DDF   1C                   ???
8DE0   03                   ???
8DE1   1C                   ???
8DE2   03                   ???
8DE3   1D 03 1D             ORA $1D03,X
8DE6   03                   ???
8DE7   1E 03 1E             ASL $1E03,X
8DEA   FF                   ???
8DEB   03                   ???
8DEC   1A                   ???
8DED   03                   ???
8DEE   1A                   ???
8DEF   03                   ???
8DF0   24 03                BIT $03
8DF2   26 03                ROL $03
8DF4   13                   ???
8DF5   03                   ???
8DF6   13                   ???
8DF7   07                   ???
8DF8   1F                   ???
8DF9   FF                   ???
8DFA   03                   ???
8DFB   18                   CLC
8DFC   03                   ???
8DFD   18                   CLC
8DFE   03                   ???
8DFF   24 03                BIT $03
8E01   24 03                BIT $03
8E03   18                   CLC
8E04   03                   ???
8E05   18                   CLC
8E06   03                   ???
8E07   24 03                BIT $03
8E09   24 03                BIT $03
8E0B   20 03 20             JSR $2003
8E0E   03                   ???
8E0F   2C 03 2C             BIT $2C03
8E12   03                   ???
8E13   20 03 20             JSR $2003
8E16   03                   ???
8E17   2C 03 2C             BIT $2C03
8E1A   FF                   ???
8E1B   03                   ???
8E1C   19 03 19             ORA $1903,Y
8E1F   03                   ???
8E20   25 03                AND $03
8E22   25 03                AND $03
8E24   19 03 19             ORA $1903,Y
8E27   03                   ???
8E28   25 03                AND $03
8E2A   25 03                AND $03
8E2C   21 03                AND ($03,X)
8E2E   21 03                AND ($03,X)
8E30   2D 03 2D             AND $2D03
8E33   03                   ???
8E34   21 03                AND ($03,X)
8E36   21 03                AND ($03,X)
8E38   2D 03 2D             AND $2D03
8E3B   FF                   ???
8E3C   03                   ???
8E3D   1A                   ???
8E3E   03                   ???
8E3F   1A                   ???
8E40   03                   ???
8E41   26 03                ROL $03
8E43   26 03                ROL $03
8E45   1A                   ???
8E46   03                   ???
8E47   1A                   ???
8E48   03                   ???
8E49   26 03                ROL $03
8E4B   26 03                ROL $03
8E4D   15 03                ORA $03,X
8E4F   15 03                ORA $03,X
8E51   21 03                AND ($03,X)
8E53   21 03                AND ($03,X)
8E55   15 03                ORA $03,X
8E57   15 03                ORA $03,X
8E59   21 03                AND ($03,X)
8E5B   21 03                AND ($03,X)
8E5D   18                   CLC
8E5E   03                   ???
8E5F   18                   CLC
8E60   03                   ???
8E61   24 03                BIT $03
8E63   24 03                BIT $03
8E65   18                   CLC
8E66   03                   ???
8E67   18                   CLC
8E68   03                   ???
8E69   24 03                BIT $03
8E6B   24 03                BIT $03
8E6D   1F                   ???
8E6E   03                   ???
8E6F   1F                   ???
8E70   03                   ???
8E71   2B                   ???
8E72   03                   ???
8E73   2B                   ???
8E74   03                   ???
8E75   1F                   ???
8E76   03                   ???
8E77   1F                   ???
8E78   03                   ???
8E79   2B                   ???
8E7A   03                   ???
8E7B   2B                   ???
8E7C   03                   ???
8E7D   1A                   ???
8E7E   03                   ???
8E7F   1A                   ???
8E80   03                   ???
8E81   26 03                ROL $03
8E83   26 03                ROL $03
8E85   1A                   ???
8E86   03                   ???
8E87   1A                   ???
8E88   03                   ???
8E89   26 03                ROL $03
8E8B   26 03                ROL $03
8E8D   15 03                ORA $03,X
8E8F   15 03                ORA $03,X
8E91   21 03                AND ($03,X)
8E93   21 03                AND ($03,X)
8E95   15 03                ORA $03,X
8E97   15 03                ORA $03,X
8E99   21 03                AND ($03,X)
8E9B   21 03                AND ($03,X)
8E9D   18                   CLC
8E9E   03                   ???
8E9F   18                   CLC
8EA0   03                   ???
8EA1   24 03                BIT $03
8EA3   24 03                BIT $03
8EA5   18                   CLC
8EA6   03                   ???
8EA7   18                   CLC
8EA8   03                   ???
8EA9   24 03                BIT $03
8EAB   24 03                BIT $03
8EAD   1C                   ???
8EAE   03                   ???
8EAF   1C                   ???
8EB0   03                   ???
8EB1   28                   PLP
8EB2   03                   ???
8EB3   28                   PLP
8EB4   03                   ???
8EB5   1C                   ???
8EB6   03                   ???
8EB7   1C                   ???
8EB8   03                   ???
8EB9   28                   PLP
8EBA   03                   ???
8EBB   28                   PLP
8EBC   83                   ???
8EBD   04                   ???
8EBE   36 07                ROL $07,X
8EC0   36 07                ROL $07,X
8EC2   37                   ???
8EC3   07                   ???
8EC4   36 03                ROL $03,X
8EC6   33                   ???
8EC7   07                   ???
8EC8   32                   ???
8EC9   57                   ???
8ECA   FF                   ???
8ECB   83                   ???
8ECC   02                   ???
8ECD   1B                   ???
8ECE   03                   ???
8ECF   1B                   ???
8ED0   03                   ???
8ED1   27                   ???
8ED2   03                   ???
8ED3   27                   ???
8ED4   03                   ???
8ED5   1B                   ???
8ED6   03                   ???
8ED7   1B                   ???
8ED8   03                   ???
8ED9   27                   ???
8EDA   03                   ???
8EDB   27                   ???
8EDC   FF                   ???
8EDD   03                   ???
8EDE   1C                   ???
8EDF   03                   ???
8EE0   1C                   ???
8EE1   03                   ???
8EE2   28                   PLP
8EE3   03                   ???
8EE4   28                   PLP
8EE5   03                   ???
8EE6   1C                   ???
8EE7   03                   ???
8EE8   1C                   ???
8EE9   03                   ???
8EEA   28                   PLP
8EEB   03                   ???
8EEC   28                   PLP
8EED   FF                   ???
8EEE   03                   ???
8EEF   1D 03 1D             ORA $1D03,X
8EF2   03                   ???
8EF3   29 03                AND #$03
8EF5   29 03                AND #$03
8EF7   1D 03 1D             ORA $1D03,X
8EFA   03                   ???
8EFB   29 03                AND #$03
8EFD   29 FF                AND #$FF
8EFF   03                   ???
8F00   18                   CLC
8F01   03                   ???
8F02   18                   CLC
8F03   03                   ???
8F04   24 03                BIT $03
8F06   24 03                BIT $03
8F08   18                   CLC
8F09   03                   ???
8F0A   18                   CLC
8F0B   03                   ???
8F0C   24 03                BIT $03
8F0E   24 FF                BIT $FF
8F10   03                   ???
8F11   1E 03 1E             ASL $1E03,X
8F14   03                   ???
8F15   2A                   ROL A
8F16   03                   ???
8F17   2A                   ROL A
8F18   03                   ???
8F19   1E 03 1E             ASL $1E03,X
8F1C   03                   ???
8F1D   2A                   ROL A
8F1E   03                   ???
8F1F   2A                   ROL A
8F20   FF                   ???
8F21   83                   ???
8F22   05 26                ORA $26
8F24   01 4A                ORA ($4A,X)
8F26   01 34                ORA ($34,X)
8F28   03                   ???
8F29   29 03                AND #$03
8F2B   4C 03 4A             JMP $4A03
8F2E   03                   ???
8F2F   31 03                AND ($03),Y
8F31   4A                   LSR A
8F32   03                   ???
8F33   24 03                BIT $03
8F35   22                   ???
8F36   01 46                ORA ($46,X)
8F38   01 30                ORA ($30,X)
8F3A   03                   ???
8F3B   25 03                AND $03
8F3D   48                   PHA
8F3E   03                   ???
8F3F   46 03                LSR $03
8F41   2D 03 46             AND $4603
8F44   03                   ???
8F45   24 FF                BIT $FF
8F47   83                   ???
8F48   02                   ???
8F49   1A                   ???
8F4A   03                   ???
8F4B   1A                   ???
8F4C   03                   ???
8F4D   26 03                ROL $03
8F4F   26 03                ROL $03
8F51   1A                   ???
8F52   03                   ???
8F53   1A                   ???
8F54   03                   ???
8F55   26 03                ROL $03
8F57   26 FF                ROL $FF
8F59   03                   ???
8F5A   13                   ???
8F5B   03                   ???
8F5C   13                   ???
8F5D   03                   ???
8F5E   1D 03 1F             ORA $1F03,X
8F61   03                   ???
8F62   13                   ???
8F63   03                   ???
8F64   13                   ???
8F65   03                   ???
8F66   1D 03 1F             ORA $1F03,X
8F69   FF                   ???
8F6A   87                   ???
8F6B   02                   ???
8F6C   1A                   ???
8F6D   87                   ???
8F6E   03                   ???
8F6F   2F                   ???
8F70   83                   ???
8F71   02                   ???
8F72   26 03                ROL $03
8F74   26 87                ROL $87
8F76   03                   ???
8F77   2F                   ???
8F78   FF                   ???
8F79   07                   ???
8F7A   1A                   ???
8F7B   4F                   ???
8F7C   47                   ???
8F7D   FF                   ???
8F7E   03                   ???
8F7F   1F                   ???
8F80   03                   ???
8F81   1F                   ???
8F82   03                   ???
8F83   24 03                BIT $03
8F85   26 07                ROL $07
8F87   13                   ???
8F88   47                   ???
8F89   FF                   ???
8F8A   BF                   ???
8F8B   0F                   ???
8F8C   32                   ???
8F8D   0F                   ???
8F8E   32                   ???
8F8F   8F                   ???
8F90   90 30                BCC L8FC2
8F92   3F                   ???
8F93   32                   ???
8F94   13                   ???
8F95   32                   ???
8F96   03                   ???
8F97   32                   ???
8F98   03                   ???
8F99   35 03                AND $03,X
8F9B   37                   ???
8F9C   3F                   ???
8F9D   37                   ???
8F9E   0F                   ???
8F9F   37                   ???
8FA0   8F                   ???
8FA1   90 30                BCC L8FD3
8FA3   3F                   ???
8FA4   32                   ???
8FA5   13                   ???
8FA6   32                   ???
8FA7   03                   ???
8FA8   2D 03 30             AND $3003
8FAB   03                   ???
8FAC   32                   ???
8FAD   FF                   ???
8FAE   0F                   ???
8FAF   32                   ???
8FB0   AF                   ???
8FB1   90 35                BCC L8FE8
8FB3   0F                   ???
8FB4   37                   ???
8FB5   A7                   ???
8FB6   99 37 07             STA $0737,Y
8FB9   35 3F                AND $3F,X
8FBB   32                   ???
8FBC   13                   ???
8FBD   32                   ???
8FBE   03                   ???
8FBF   32                   ???
8FC0   A3                   ???
8FC1   E8                   INX
8FC2   35 03      L8FC2     AND $03,X
8FC4   37                   ???
8FC5   0F                   ???
8FC6   35 AF                AND $AF,X
8FC8   90 37                BCC L9001
8FCA   0F                   ???
8FCB   37                   ???
8FCC   A7                   ???
8FCD   99 37 07             STA $0737,Y
8FD0   35 3F                AND $3F,X
8FD2   32                   ???
8FD3   13         L8FD3     ???
8FD4   32                   ???
8FD5   03                   ???
8FD6   2D A3 E8             AND $E8A3
8FD9   30 03                BMI L8FDE
8FDB   32                   ???
8FDC   FF                   ???
8FDD   07                   ???
8FDE   32         L8FDE     ???
8FDF   03                   ???
8FE0   39 13 3C             AND $3C13,Y
8FE3   A7                   ???
8FE4   9A                   TXS
8FE5   37                   ???
8FE6   A7                   ???
8FE7   9B                   ???
8FE8   38         L8FE8     SEC
8FE9   07                   ???
8FEA   37                   ???
8FEB   03                   ???
8FEC   35 03                AND $03,X
8FEE   32                   ???
8FEF   03                   ???
8FF0   39 1B 3C             AND $3C1B,Y
8FF3   A7                   ???
8FF4   9A                   TXS
8FF5   37                   ???
8FF6   A7                   ???
8FF7   9B                   ???
8FF8   38                   SEC
8FF9   07                   ???
8FFA   37                   ???
8FFB   03                   ???
8FFC   35 03                AND $03,X
8FFE   32                   ???
8FFF   03         L8FFF     ???
9000   39 03 3C             AND $3C03,Y
9003   03                   ???
9004   3E 03 3C             ROL $3C03,X
9007   07                   ???
9008   3E 03 3C             ROL $3C03,X
900B   03                   ???
900C   39 A7 9A             AND $9AA7,Y
900F   37                   ???
9010   A7                   ???
9011   9B                   ???
9012   38                   SEC
9013   07                   ???
9014   37                   ???
9015   03                   ???
9016   35 03                AND $03,X
9018   32                   ???
9019   AF                   ???
901A   90 3C                BCC L9058
901C   1F                   ???
901D   3E 43 03             ROL $0343,X
9020   3E 03 3C             ROL $3C03,X
9023   03                   ???
9024   3E FF 03             ROL $03FF,X
9027   3E 03 3E             ROL $3E03,X
902A   A3                   ???
902B   E8                   INX
902C   3C                   ???
902D   03                   ???
902E   3E 03 3E             ROL $3E03,X
9031   03                   ???
9032   3E A3 E8             ROL $E8A3,X
9035   3C                   ???
9036   03                   ???
9037   3E 03 3E             ROL $3E03,X
903A   03                   ???
903B   3E A3 E8             ROL $E8A3,X
903E   3C                   ???
903F   03                   ???
9040   3E 03 3E             ROL $3E03,X
9043   03                   ???
9044   3E A3 E8             ROL $E8A3,X
9047   3C                   ???
9048   03                   ???
9049   3E AF 91             ROL $91AF,X
904C   43                   ???
904D   1F                   ???
904E   41 43                EOR ($43,X)
9050   03                   ???
9051   3E 03 41             ROL $4103,X
9054   03                   ???
9055   43                   ???
9056   03                   ???
9057   43                   ???
9058   03         L9058     ???
9059   43                   ???
905A   A3                   ???
905B   E8                   INX
905C   41 03                EOR ($03,X)
905E   43                   ???
905F   03                   ???
9060   43                   ???
9061   03                   ???
9062   43                   ???
9063   A3                   ???
9064   E8                   INX
9065   41 03                EOR ($03,X)
9067   43                   ???
9068   03                   ???
9069   45 03                EOR $03
906B   48                   PHA
906C   A3                   ???
906D   FD 45 03             SBC $0345,X
9070   44                   ???
9071   01 43                ORA ($43,X)
9073   01 41                ORA ($41,X)
9075   03                   ???
9076   3E 03 3C             ROL $3C03,X
9079   03                   ???
907A   3E 2F 3E             ROL $3E2F,X
907D   BF                   ???
907E   98                   TYA
907F   3E 43 03             ROL $0343,X
9082   3E 03 3C             ROL $3C03,X
9085   03                   ???
9086   3E FF 03             ROL $03FF,X
9089   4A                   LSR A
908A   03                   ???
908B   4A                   LSR A
908C   A3                   ???
908D   F8                   SED
908E   48                   PHA
908F   03                   ???
9090   4A                   LSR A
9091   03                   ???
9092   4A                   LSR A
9093   03                   ???
9094   4A                   LSR A
9095   A3                   ???
9096   F8                   SED
9097   48                   PHA
9098   03                   ???
9099   4A                   LSR A
909A   FF                   ???
909B   01 51                ORA ($51,X)
909D   01 54                ORA ($54,X)
909F   01 51                ORA ($51,X)
90A1   01 54                ORA ($54,X)
90A3   01 51                ORA ($51,X)
90A5   01 54                ORA ($54,X)
90A7   01 51                ORA ($51,X)
90A9   01 54                ORA ($54,X)
90AB   01 51                ORA ($51,X)
90AD   01 54                ORA ($54,X)
90AF   01 51                ORA ($51,X)
90B1   01 54                ORA ($54,X)
90B3   01 51                ORA ($51,X)
90B5   01 54                ORA ($54,X)
90B7   01 51                ORA ($51,X)
90B9   01 54                ORA ($54,X)
90BB   FF                   ???
90BC   01 50                ORA ($50,X)
90BE   01 4F                ORA ($4F,X)
90C0   01 4D                ORA ($4D,X)
90C2   01 4A                ORA ($4A,X)
90C4   01 4F                ORA ($4F,X)
90C6   01 4D                ORA ($4D,X)
90C8   01 4A                ORA ($4A,X)
90CA   01 48                ORA ($48,X)
90CC   01 4A                ORA ($4A,X)
90CE   01 48                ORA ($48,X)
90D0   01 45                ORA ($45,X)
90D2   01 43                ORA ($43,X)
90D4   01 44                ORA ($44,X)
90D6   01 43                ORA ($43,X)
90D8   01 41                ORA ($41,X)
90DA   01 3E                ORA ($3E,X)
90DC   01 43                ORA ($43,X)
90DE   01 41                ORA ($41,X)
90E0   01 3E                ORA ($3E,X)
90E2   01 3C                ORA ($3C,X)
90E4   01 3E                ORA ($3E,X)
90E6   01 3C                ORA ($3C,X)
90E8   01 39                ORA ($39,X)
90EA   01 37                ORA ($37,X)
90EC   01 38                ORA ($38,X)
90EE   01 37                ORA ($37,X)
90F0   01 35                ORA ($35,X)
90F2   01 32                ORA ($32,X)
90F4   01 37                ORA ($37,X)
90F6   01 35                ORA ($35,X)
90F8   01 32                ORA ($32,X)
90FA   01 30                ORA ($30,X)
90FC   FF                   ???
90FD   5F                   ???
90FE   5F                   ???
90FF   5F                   ???
9100   47                   ???
9101   83                   ???
9102   0E 32 07             ASL $0732
9105   32                   ???
9106   07                   ???
9107   2F                   ???
9108   03                   ???
9109   2F                   ???
910A   07                   ???
910B   2F                   ???
910C   97                   ???
910D   0B                   ???
910E   3A                   ???
910F   5F                   ???
9110   5F                   ???
9111   47                   ???
9112   8B                   ???
9113   0E 32 03             ASL $0332
9116   32                   ???
9117   03                   ???
9118   2F                   ???
9119   03                   ???
911A   2F                   ???
911B   47                   ???
911C   97                   ???
911D   0B                   ???
911E   3A                   ???
911F   5F                   ???
9120   5F                   ???
9121   47                   ???
9122   83                   ???
9123   0E 2F 0B             ASL $0B2F
9126   2F                   ???
9127   03                   ???
9128   2F                   ???
9129   03                   ???
912A   2F                   ???
912B   87                   ???
912C   0B                   ???
912D   30 17                BMI L9146
912F   3A                   ???
9130   5F                   ???
9131   8B                   ???
9132   0E 32 0B             ASL $0B32
9135   32                   ???
9136   0B                   ???
9137   2F                   ???
9138   0B                   ???
9139   2F                   ???
913A   07                   ???
913B   2C 07 2C             BIT $2C07
913E   FF                   ???
913F   87                   ???
9140   0B                   ???
9141   34                   ???
9142   17                   ???
9143   3A                   ???
9144   5F                   ???
9145   5F                   ???
9146   84 0E      L9146     STY $0E
9148   32                   ???
9149   04                   ???
914A   32                   ???
914B   05 32                ORA $32
914D   04                   ???
914E   2F                   ???
914F   04                   ???
9150   2F                   ???
9151   05 2F                ORA $2F
9153   47                   ???
9154   97                   ???
9155   0B                   ???
9156   3A                   ???
9157   5F                   ???
9158   5F                   ???
9159   84 0E                STY $0E
915B   32                   ???
915C   04                   ???
915D   32                   ???
915E   05 32                ORA $32
9160   04                   ???
9161   2F                   ???
9162   04                   ???
9163   2F                   ???
9164   05 2F                ORA $2F
9166   FF                   ???
9167   80                   ???
9168   10 46                BPL L91B0
916A   00                   BRK
916B   43                   ???
916C   00                   BRK
916D   45 00                EOR $00
916F   42                   ???
9170   00                   BRK
9171   46 00                LSR $00
9173   43                   ???
9174   00                   BRK
9175   45 00                EOR $00
9177   42                   ???
9178   00                   BRK
9179   46 00                LSR $00
917B   43                   ???
917C   00                   BRK
917D   45 00                EOR $00
917F   42                   ???
9180   00                   BRK
9181   46 00                LSR $00
9183   43                   ???
9184   00                   BRK
9185   45 00                EOR $00
9187   42                   ???
9188   FF                   ???
9189   80                   ???
918A   10 43                BPL L91CF
918C   00                   BRK
918D   3F                   ???
918E   00                   BRK
918F   42                   ???
9190   00                   BRK
9191   3E 00 43             ROL $4300,X
9194   00                   BRK
9195   3F                   ???
9196   00                   BRK
9197   42                   ???
9198   00                   BRK
9199   3E 00 43             ROL $4300,X
919C   00                   BRK
919D   3F                   ???
919E   00                   BRK
919F   42                   ???
91A0   00                   BRK
91A1   3E 00 43             ROL $4300,X
91A4   00                   BRK
91A5   3F                   ???
91A6   00                   BRK
91A7   42                   ???
91A8   00                   BRK
91A9   3E FF 21             ROL $21FF,X
91AC   46 21                LSR $21
91AE   43                   ???
91AF   21 45                AND ($45,X)
91B1   21 42                AND ($42,X)
91B3   22                   ???
91B4   46 22                LSR $22
91B6   43                   ???
91B7   22                   ???
91B8   45 22                EOR $22
91BA   42                   ???
91BB   23                   ???
91BC   46 23                LSR $23
91BE   43                   ???
91BF   23                   ???
91C0   45 23                EOR $23
91C2   42                   ???
91C3   24 46                BIT $46
91C5   24 43                BIT $43
91C7   24 45                BIT $45
91C9   24 42                BIT $42
91CB   25 46                AND $46
91CD   25 43                AND $43
91CF   25 45      L91CF     AND $45
91D1   25 42                AND $42
91D3   28                   PLP
91D4   46 28                LSR $28
91D6   43                   ???
91D7   28                   PLP
91D8   45 28                EOR $28
91DA   42                   ???
91DB   09 43                ORA #$43
91DD   0B                   ???
91DE   3F                   ???
91DF   0E 42 12             ASL $1242
91E2   3C                   ???
91E3   2F                   ???
91E4   3A                   ???
91E5   AF                   ???
91E6   D0 3A                BNE L9222
91E8   1F                   ???
91E9   46 FF                LSR $FF
91EB   21 43                AND ($43,X)
91ED   21 3F                AND ($3F,X)
91EF   21 42                AND ($42,X)
91F1   21 3E                AND ($3E,X)
91F3   22                   ???
91F4   43                   ???
91F5   22                   ???
91F6   3F                   ???
91F7   22                   ???
91F8   42                   ???
91F9   22                   ???
91FA   3E 23 43             ROL $4323,X
91FD   23                   ???
91FE   3F                   ???
91FF   23                   ???
9200   42                   ???
9201   23                   ???
9202   3E 24 43             ROL $4324,X
9205   24 3F                BIT $3F
9207   24 42                BIT $42
9209   24 3E                BIT $3E
920B   25 43                AND $43
920D   25 3F                AND $3F
920F   25 42                AND $42
9211   25 3E                AND $3E
9213   28                   PLP
9214   43                   ???
9215   28                   PLP
9216   3F                   ???
9217   28                   PLP
9218   42                   ???
9219   28                   PLP
921A   3E 09 3F             ROL $3F09,X
921D   0B                   ???
921E   3C                   ???
921F   0E 3E 12             ASL $123E
9222   39 2F 32   L9222     AND $322F,Y
9225   AF                   ???
9226   D0 32                BNE L925A
9228   1F                   ???
9229   3E FF 07             ROL $07FF,X
922C   26 0B                ROL $0B
922E   1A                   ???
922F   0F                   ???
9230   26 13                ROL $13
9232   1A                   ???
9233   17                   ???
9234   26 11                ROL $11
9236   1A                   ???
9237   11 26                ORA ($26),Y
9239   09 1A                ORA #$1A
923B   0B                   ???
923C   26 0E                ROL $0E
923E   1A                   ???
923F   12                   ???
9240   26 2F                ROL $2F
9242   2B                   ???
9243   AF                   ???
9244   C1 2B                CMP ($2B,X)
9246   1F                   ???
9247   1F                   ???
9248   FF                   ???
9249   5F                   ???
924A   FF                   ???
924B   03                   ???
924C   1A                   ???
924D   03                   ???
924E   1A                   ???
924F   03                   ???
9250   24 03                BIT $03
9252   26 03                ROL $03
9254   1A                   ???
9255   03                   ???
9256   1A                   ???
9257   03                   ???
9258   18                   CLC
9259   03                   ???
925A   19 03 1A   L925A     ORA $1A03,Y
925D   03                   ???
925E   1A                   ???
925F   03                   ???
9260   24 03                BIT $03
9262   26 03                ROL $03
9264   1A                   ???
9265   03                   ???
9266   1A                   ???
9267   03                   ???
9268   18                   CLC
9269   03                   ???
926A   19 03 18             ORA $1803,Y
926D   03                   ???
926E   18                   CLC
926F   03                   ???
9270   22                   ???
9271   03                   ???
9272   24 03                BIT $03
9274   18                   CLC
9275   03                   ???
9276   18                   CLC
9277   03                   ???
9278   16 03                ASL $03,X
927A   17                   ???
927B   03                   ???
927C   18                   CLC
927D   03                   ???
927E   18                   CLC
927F   03                   ???
9280   22                   ???
9281   03                   ???
9282   24 03                BIT $03
9284   18                   CLC
9285   03                   ???
9286   18                   CLC
9287   03                   ???
9288   16 03                ASL $03,X
928A   17                   ???
928B   03                   ???
928C   13                   ???
928D   03                   ???
928E   13                   ???
928F   03                   ???
9290   1D 03 1F             ORA $1F03,X
9293   03                   ???
9294   13                   ???
9295   03                   ???
9296   13                   ???
9297   03                   ???
9298   1D 03 1E             ORA $1E03,X
929B   03                   ???
929C   13                   ???
929D   03                   ???
929E   13                   ???
929F   03                   ???
92A0   1D 03 1F             ORA $1F03,X
92A3   03                   ???
92A4   13                   ???
92A5   03                   ???
92A6   13                   ???
92A7   03                   ???
92A8   1D 03 1E             ORA $1E03,X
92AB   03                   ???
92AC   1A                   ???
92AD   03                   ???
92AE   1A                   ???
92AF   03                   ???
92B0   24 03                BIT $03
92B2   26 03                ROL $03
92B4   1A                   ???
92B5   03                   ???
92B6   1A                   ???
92B7   03                   ???
92B8   18                   CLC
92B9   03                   ???
92BA   19 03 1A             ORA $1A03,Y
92BD   03                   ???
92BE   1A                   ???
92BF   03                   ???
92C0   24 03                BIT $03
92C2   26 03                ROL $03
92C4   1A                   ???
92C5   03                   ???
92C6   1A                   ???
92C7   03                   ???
92C8   18                   CLC
92C9   03                   ???
92CA   19 FF 87             ORA $87FF,Y
92CD   11 3F                ORA ($3F),Y
92CF   07                   ???
92D0   44                   ???
92D1   07                   ???
92D2   46 07                LSR $07
92D4   44                   ???
92D5   07                   ???
92D6   4B                   ???
92D7   07                   ???
92D8   44                   ???
92D9   07                   ???
92DA   46 07                LSR $07
92DC   44                   ???
92DD   FF                   ???
92DE   8F                   ???
92DF   02                   ???
92E0   20 87 03             JSR $0387
92E3   2F                   ???
92E4   87                   ???
92E5   02                   ???
92E6   20 07 20             JSR $2007
92E9   07                   ???
92EA   20 87 03             JSR $0387
92ED   2F                   ???
92EE   87                   ???
92EF   02                   ???
92F0   1B                   ???
92F1   FF                   ???
92F2   8F                   ???
92F3   02                   ???
92F4   1D 87 03             ORA $0387,X
92F7   2F                   ???
92F8   87                   ???
92F9   02                   ???
92FA   1D 07 1D             ORA $1D07,X
92FD   07                   ???
92FE   1D 87 03             ORA $0387,X
9301   2F                   ???
9302   87                   ???
9303   02                   ???
9304   18                   CLC
9305   FF                   ???
9306   8F                   ???
9307   02                   ???
9308   19 87 03             ORA $0387,Y
930B   2F                   ???
930C   87                   ???
930D   02                   ???
930E   19 07 19             ORA $1907,Y
9311   07                   ???
9312   19 87 03             ORA $0387,Y
9315   2F                   ???
9316   87                   ???
9317   02                   ???
9318   20 FF 8F             JSR L8FFF
931B   02                   ???
931C   1B                   ???
931D   87                   ???
931E   03                   ???
931F   2F                   ???
9320   87                   ???
9321   02                   ???
9322   1B                   ???
9323   07                   ???
9324   1B                   ???
9325   07                   ???
9326   1B                   ???
9327   87                   ???
9328   03                   ???
9329   2F                   ???
932A   87                   ???
932B   02                   ???
932C   22                   ???
932D   FF                   ???
932E   BF                   ???
932F   09 3C                ORA #$3C
9331   3F                   ???
9332   3C                   ???
9333   0F                   ???
9334   3C                   ???
9335   03                   ???
9336   3D 03 3C             AND $3C03,X
9339   03                   ???
933A   3D 03 3C             AND $3C03,X
933D   07                   ???
933E   3D 07 3F             AND $3F07,X
9341   07                   ???
9342   3D 07 3C             AND $3C07,X
9345   07                   ???
9346   3D 0F 3C             AND $3C0F,X
9349   37                   ???
934A   38                   SEC
934B   1F                   ???
934C   38                   SEC
934D   FF                   ???
934E   07                   ???
934F   35 17                AND $17,X
9351   3D 0F 3C             AND $3C0F,X
9354   07                   ???
9355   3C                   ???
9356   0F                   ???
9357   3A                   ???
9358   27                   ???
9359   3A                   ???
935A   3F                   ???
935B   3A                   ???
935C   3F                   ???
935D   3A                   ???
935E   1F                   ???
935F   3A                   ???
9360   FF                   ???
9361   47                   ???
9362   8F                   ???
9363   12                   ???
9364   3C                   ???
9365   17                   ???
9366   3F                   ???
9367   07                   ???
9368   3D 07 3C             AND $3C07,X
936B   47                   ???
936C   0F                   ???
936D   3C                   ???
936E   17                   ???
936F   3C                   ???
9370   07                   ???
9371   3A                   ???
9372   07                   ???
9373   38                   SEC
9374   FF                   ???
9375   87                   ???
9376   13                   ???
9377   44                   ???
9378   07                   ???
9379   48                   PHA
937A   07                   ???
937B   49 07                EOR #$07
937D   48                   PHA
937E   07                   ???
937F   44                   ???
9380   07                   ???
9381   49 07                EOR #$07
9383   48                   PHA
9384   07                   ???
9385   49 FF                EOR #$FF
9387   A3                   ???
9388   09 44                ORA #$44
938A   A3                   ???
938B   E8                   INX
938C   44                   ???
938D   22                   ???
938E   46 A4                LSR $A4
9390   D9 46 1F             CMP $1F46,Y
9393   44                   ???
9394   0F                   ???
9395   3F                   ???
9396   FF                   ???
9397   23                   ???
9398   4B                   ???
9399   A3                   ???
939A   FE 4B 23             INC $234B,X
939D   4D A3 F1             EOR $F1A3
93A0   4D 1F 4B             EOR $4B1F
93A3   0F                   ???
93A4   49 23                EOR #$23
93A6   46 A3                LSR $A3
93A8   FE 46 23             INC $2346,X
93AB   48                   PHA
93AC   A3                   ???
93AD   EB                   ???
93AE   48                   PHA
93AF   1F                   ???
93B0   46 0F                LSR $0F
93B2   46 FF                LSR $FF
93B4   80                   ???
93B5   0B                   ???
93B6   41 48                EOR ($48,X)
93B8   60                   RTS
93B9   03                   ???
93BA   81 00                STA ($00,X)
93BC   00                   BRK
93BD   08                   PHP
93BE   81 02                STA ($02,X)
93C0   08                   PHP
93C1   00                   BRK
93C2   00                   BRK
93C3   01 A0                ORA ($A0,X)
93C5   02                   ???
93C6   41 09                EOR ($09,X)
93C8   80                   ???
93C9   00                   BRK
93CA   00                   BRK
93CB   00                   BRK
93CC   00                   BRK
93CD   02                   ???
93CE   81 09                STA ($09,X)
93D0   09 00                ORA #$00
93D2   00                   BRK
93D3   05 00                ORA $00
93D5   08                   PHP
93D6   41 08                EOR ($08,X)
93D8   50 02                BVC L93DC
93DA   00                   BRK
93DB   04                   ???
93DC   00         L93DC     BRK
93DD   01 41                ORA ($41,X)
93DF   3F                   ???
93E0   C0 02                CPY #$02
93E2   00                   BRK
93E3   00                   BRK
93E4   00                   BRK
93E5   08                   PHP
93E6   41 04                EOR ($04,X)
93E8   40                   RTI
93E9   02                   ???
93EA   00                   BRK
93EB   00                   BRK
93EC   00                   BRK
93ED   08                   PHP
93EE   41 09                EOR ($09,X)
93F0   00                   BRK
93F1   02                   ???
93F2   00                   BRK
93F3   00                   BRK
93F4   80                   ???
93F5   0A                   ASL A
93F6   41 09                EOR ($09,X)
93F8   70 02                BVS L93FC
93FA   5F                   ???
93FB   04                   ???
93FC   80         L93FC     ???
93FD   08                   PHP
93FE   41 4A                EOR ($4A,X)
9400   69 02                ADC #$02
9402   81 00                STA ($00,X)
9404   00                   BRK
9405   09 41                ORA #$41
9407   40                   RTI
9408   6F                   ???
9409   00                   BRK
940A   81 02                STA ($02,X)
940C   80                   ???
940D   07                   ???
940E   81 0A                STA ($0A,X)
9410   0A                   ASL A
9411   00                   BRK
9412   00                   BRK
9413   01 A0                ORA ($A0,X)
9415   0B                   ???
9416   41 3F                EOR ($3F,X)
9418   FF                   ???
9419   01 E7                ORA ($E7,X)
941B   02                   ???
941C   00                   BRK
941D   08                   PHP
941E   41 90                EOR ($90,X)
9420   F0 01                BEQ L9423
9422   E8                   INX
9423   02         L9423     ???
9424   00                   BRK
9425   08                   PHP
9426   41 06                EOR ($06,X)
9428   0A                   ASL A
9429   00                   BRK
942A   00                   BRK
942B   01 00                ORA ($00,X)
942D   09 41                ORA #$41
942F   19 70 02             ORA $0270,Y
9432   A8                   TAY
9433   00                   BRK
9434   00                   BRK
9435   02                   ???
9436   41 09                EOR ($09,X)
9438   90 02                BCC L943C
943A   00                   BRK
943B   00                   BRK
943C   00         L943C     BRK
943D   00                   BRK
943E   11 0A                ORA ($0A),Y
9440   FA                   ???
9441   00                   BRK
9442   00                   BRK
9443   05 00                ORA $00
9445   08                   PHP
9446   41 37                EOR ($37,X)
9448   40                   RTI
9449   02                   ???
944A   00                   BRK
944B   00                   BRK
944C   00                   BRK
944D   08                   PHP
944E   11 07                ORA ($07),Y
9450   70 02                BVS L9454
9452   00                   BRK
9453   00                   BRK
9454   60         L9454     RTS
9455   33         L9455     ???
9456   98                   TYA
9457   80                   ???
9458   01 41                ORA ($41,X)
945A   0F                   ???
945B   00                   BRK
945C   00                   BRK
945D   57                   ???
945E   00                   BRK
945F   06 15                ASL $15
9461   0F                   ???
9462   00                   BRK
9463   5F                   ???
9464   62                   ???
9465   40                   RTI
9466   03                   ???
9467   40                   RTI
9468   02                   ???
9469   41 0C                EOR ($0C,X)
946B   00                   BRK
946C   32                   ???
946D   90 00                BCC L946F
946F   08         L946F     PHP
9470   43                   ???
9471   0A                   ASL A
9472   00                   BRK
9473   58                   CLI
9474   50 40                BVC L94B6
9476   08                   PHP
9477   80                   ???
9478   08                   PHP
9479   41 0A                EOR ($0A,X)
947B   90 06                BCC L9483
947D   14                   ???
947E   14                   ???
947F   02                   ???
9480   47                   ???
9481   0F                   ???
9482   A0 20                LDY #$20
9484   62                   ???
9485   10 08                BPL L948F
9487   20 00 81             JSR L8100
948A   0E 00 08             ASL $0800
948D   01 80                ORA ($80,X)
948F   08         L948F     PHP
9490   81 0F                STA ($0F,X)
9492   00                   BRK
9493   4F                   ???
9494   21 28                AND ($28,X)
9496   08                   PHP
9497   40                   RTI
9498   08                   PHP
9499   11 0F                ORA ($0F),Y
949B   90 02                BCC L949F
949D   60                   RTS
949E   80                   ???
949F   06 15      L949F     ASL $15
94A1   0F                   ???
94A2   90 4F                BCC L94F3
94A4   11 4F                ORA ($4F),Y
94A6   08                   PHP
94A7   40                   RTI
94A8   08                   PHP
94A9   11 0F                ORA ($0F),Y
94AB   90 02                BCC L94AF
94AD   60                   RTS
94AE   80                   ???
94AF   06 15      L94AF     ASL $15
94B1   0F                   ???
94B2   90 28                BCC L94DC
94B4   64                   ???
94B5   04                   ???
94B6   04         L94B6     ???
94B7   80                   ???
94B8   08                   PHP
94B9   41 0A                EOR ($0A,X)
94BB   A0 02                LDY #$02
94BD   00                   BRK
94BE   14                   ???
94BF   01 47                ORA ($47,X)
94C1   0F                   ???
94C2   80                   ???
94C3   5F                   ???
94C4   A0 30                LDY #$30
94C6   C8                   INY
94C7   00                   BRK
94C8   08                   PHP
94C9   41 09                EOR ($09,X)
94CB   00                   BRK
94CC   02                   ???
94CD   79 00 08             ADC $0800,Y
94D0   41 0A                EOR ($0A,X)
94D2   00                   BRK
94D3   50 80                BVC L9455
94D5   50 38                BVC L950F
94D7   40                   RTI
94D8   08                   PHP
94D9   41 09                EOR ($09,X)
94DB   00                   BRK
94DC   00         L94DC     BRK
94DD   21 80                AND ($80,X)
94DF   08                   PHP
94E0   15 0B                ORA $0B,X
94E2   00                   BRK
94E3   30 50                BMI L9535
94E5   6F                   ???
94E6   14                   ???
94E7   40                   RTI
94E8   00                   BRK
94E9   81 0A                STA ($0A,X)
94EB   00                   BRK
94EC   14                   ???
94ED   27                   ???
94EE   00                   BRK
94EF   08                   PHP
94F0   15 0D                ORA $0D,X
94F2   00                   BRK
94F3   30 50      L94F3     BMI L9545
94F5   45 05                EOR $05
94F7   40                   RTI
94F8   00                   BRK
94F9   81 02                STA ($02,X)
94FB   00                   BRK
94FC   80                   ???
94FD   C0 00                CPY #$00
94FF   08                   PHP
9500   15 4F                ORA $4F,X
9502   F0 18                BEQ L951C
9504   60                   RTS
9505   10 07                BPL L950E
9507   80                   ???
9508   00                   BRK
9509   81 0A                STA ($0A,X)
950B   00                   BRK
950C   25 01                AND $01
950E   00         L950E     BRK
950F   02         L950F     ???
9510   17                   ???
9511   0C                   ???
9512   00                   BRK
9513   24 12                BIT $12
9515   30 02                BMI L9519
9517   80                   ???
9518   00                   BRK
9519   11 0F      L9519     ORA ($0F),Y
951B   F0 08                BEQ L9525
951D   01 00                ORA ($00,X)
951F   02                   ???
9520   11 0F                ORA ($0F),Y
9522   F0 14                BEQ L9538
9524   10 1A                BPL L9540
9526   02                   ???
9527   20 00 81             JSR L8100
952A   0F                   ???
952B   F0 21                BEQ L954E
952D   01 00                ORA ($00,X)
952F   03                   ???
9530   85 0F                STA $0F
9532   F0 07                BEQ L953B
9534   A0 33                LDY #$33
9536   1A                   ???
9537   80                   ???
9538   00         L9538     BRK
9539   81 0A                STA ($0A,X)
953B   00         L953B     BRK
953C   00                   BRK
953D   0D 00 02             ORA $0200
9540   81 0B      L9540     STA ($0B,X)
9542   00                   BRK
9543   5F                   ???
9544   20 0A 03             JSR $030A
9547   80                   ???
9548   00                   BRK
9549   41 0A                EOR ($0A,X)
954B   00                   BRK
954C   04                   ???
954D   71 A0                ADC ($A0),Y
954F   00                   BRK
9550   51 0B                EOR ($0B),Y
9552   F0 20                BEQ L9574
9554   A0 00      L9554     LDY #$00
9556   0A                   ASL A
9557   8D DC 84             STA $84DC
955A   0A                   ASL A
955B   18                   CLC
955C   6D DC 84             ADC $84DC
955F   AA                   TAX
9560   BD 6C 85   L9560     LDA $856C,X
9563   99 66 85             STA $8566,Y
9566   E8                   INX
9567   C8                   INY
9568   C0 06                CPY #$06
956A   D0 F4                BNE L9560
956C   A9 00                LDA #$00
956E   8D 04 D4             STA $D404
9571   8D 0B D4             STA $D40B
9574   8D 12 D4   L9574     STA $D412
9577   A9 40                LDA #$40
9579   8D EE 84             STA $84EE
957C   60                   RTS
957D   A9 C0      L957D     LDA #$C0
957F   8D EE 84             STA $84EE
9582   60                   RTS
9583   A9 00                LDA #$00
9585   8D FB 84             STA $84FB
9588   60                   RTS
9589   A9 FF                LDA #$FF
958B   8D FB 84             STA $84FB
958E   4C A7 83             JMP L83A7
9591   AE FB 84   L9591     LDX $84FB
9594   F0 04                BEQ L959A
9596   8E FC 84             STX $84FC
9599   60                   RTS
959A   09 40      L959A     ORA #$40
959C   8D FC 84             STA $84FC
959F   60                   RTS
95A0   8D BF 95   L95A0     STA $95BF
95A3   C9 03                CMP #$03
95A5   B0 03                BCS L95AA
95A7   4C 54 95             JMP L9554
95AA   38         L95AA     SEC
95AB   E9 03                SBC #$03
95AD   48                   PHA
95AE   20 7D 95             JSR L957D
95B1   68                   PLA
95B2   20 91 95             JSR L9591
95B5   60                   RTS
95B6   00                   BRK
95B7   00                   BRK
95B8   00                   BRK
95B9   00                   BRK
95BA   00                   BRK
95BB   00                   BRK
95BC   00                   BRK
95BD   00                   BRK
95BE   00                   BRK
95BF   00                   BRK
                            .END

;auto-generated symbols and labels
 L8012      $8012
 L8028      $8028
 L8052      $8052
 L8083      $8083
 L8086      $8086
 L8099      $8099
 L8100      $8100
 L8118      $8118
 L8154      $8154
 L8171      $8171
 L8174      $8174
 L8208      $8208
 L8221      $8221
 L8230      $8230
 L8269      $8269
 L8280      $8280
 L8297      $8297
 L8317      $8317
 L8336      $8336
 L8350      $8350
 L8367      $8367
 L8374      $8374
 L8392      $8392
 L8468      $8468
 L8500      $8500
 L8506      $8506
 L8516      $8516
 L8522      $8522
 L8549      $8549
 L8562      $8562
 L8590      $8590
 L8592      $8592
 L8595      $8595
 L8664      $8664
 L8714      $8714
 L8724      $8724
 L8919      $8919
 L8929      $8929
 L9001      $9001
 L9058      $9058
 L9146      $9146
 L9222      $9222
 L9423      $9423
 L9454      $9454
 L9455      $9455
 L9483      $9483
 L9519      $9519
 L9525      $9525
 L9535      $9535
 L9538      $9538
 L9540      $9540
 L9545      $9545
 L9554      $9554
 L9560      $9560
 L9574      $9574
 L9591      $9591
 L95A0      $95A0
 L803D      $803D
 L804F      $804F
 L837D      $837D
 L805F      $805F
 L819B      $819B
 L80AA      $80AA
 L80ED      $80ED
 L80E7      $80E7
 L80EA      $80EA
 L811B      $811B
 L817C      $817C
 L81A3      $81A3
 L81CC      $81CC
 L81E4      $81E4
 L82DE      $82DE
 L82C6      $82C6
 L831A      $831A
 L830F      $830F
 L834D      $834D
 L838C      $838C
 L838D      $838D
 L83B6      $83B6
 L83E0      $83E0
 L83CE      $83CE
 L83F0      $83F0
 L83FD      $83FD
 L842B      $842B
 L843F      $843F
 L84C1      $84C1
 L84DA      $84DA
 L84D9      $84D9
 L84B0      $84B0
 L85C5      $85C5
 L83FF      $83FF
 L882D      $882D
 L883F      $883F
 L886D      $886D
 L887F      $887F
 L891D      $891D
 L88B5      $88B5
 L8C71      $8C71
 L8CB6      $8CB6
 L8FC2      $8FC2
 L8FD3      $8FD3
 L8FE8      $8FE8
 L8FDE      $8FDE
 L91B0      $91B0
 L91CF      $91CF
 L925A      $925A
 L8FFF      $8FFF
 L93DC      $93DC
 L93FC      $93FC
 L943C      $943C
 L946F      $946F
 L94B6      $94B6
 L948F      $948F
 L949F      $949F
 L94F3      $94F3
 L94AF      $94AF
 L94DC      $94DC
 L950F      $950F
 L951C      $951C
 L950E      $950E
 L954E      $954E
 L953B      $953B
 L83A7      $83A7
 L959A      $959A
 L95AA      $95AA
 L957D      $957D
