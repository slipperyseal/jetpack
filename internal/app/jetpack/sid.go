package jetpack

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

