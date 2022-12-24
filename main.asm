;----------------------------------------------------------------
; constants
;----------------------------------------------------------------

PRG_COUNT = 1 ;1 = 16KB, 2 = 32KB
MIRRORING = %0001 ;%0000 = horizontal, %0001 = vertical, %1000 = four-screen

;----------------------------------------------------------------
; variables
;----------------------------------------------------------------

	.enum $0000

	; Player1 Paddle Variables																
	player1Speed .dsb 1
	player1PosX  .dsb 1
	player1PosY  .dsb 1

	.ende

;----------------------------------------------------------------
; iNES header
;----------------------------------------------------------------

	.db "NES", $1a ;identification of the iNES header
	.db PRG_COUNT ;number of 16KB PRG-ROM pages
	.db $01 ;number of 8KB CHR-ROM pages
	.db $00|MIRRORING ;mapper 0 and mirroring
	.dsb 9, $00 ;clear the remaining bytes

;----------------------------------------------------------------
; program bank(s)
;----------------------------------------------------------------

	.base $10000-(PRG_COUNT*$4000)

Reset:
    sei        ; ignore IRQs
    cld        ; disable decimal mode
    ldx #$40
    stx $4017  ; disable APU frame IRQ
    ldx #$ff
    txs        ; Set up stack
    inx        ; now X = 0
    stx $2000  ; disable NMI
    stx $2001  ; disable rendering
    stx $4010  ; disable DMC IRQs

    ; Optional (omitted):
    ; Set up mapper and jmp to further init code here.

    ; The vblank flag is in an unknown state after reset,
    ; so it is cleared here to make sure that @vblankwait1
    ; does not exit immediately.
    bit $2002

    ; First of two waits for vertical blank to make sure that the
    ; PPU has stabilized
@vblankwait1:  
    bit $2002
    bpl @vblankwait1

    ; We now have about 30,000 cycles to burn before the PPU stabilizes.
    ; One thing we can do with this time is put RAM in a known state.
    ; Here we fill it with $00, which matches what (say) a C compiler
    ; expects for BSS.  Conveniently, X is still 0.
    txa
@clrmem:
    sta $000,x
    sta $100,x
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne @clrmem

    ; Other things you can do between vblank waits are set up audio
    ; or set up other mapper registers.
   
@vblankwait2:
    bit $2002

Main:
	; TODO: draw paddle sprite on the left side of the screen


NMI:

IRQ:

;----------------------------------------------------------------
; interrupt vectors
;----------------------------------------------------------------

	.org $fffa

	.dw NMI
	.dw Reset
	.dw IRQ

;----------------------------------------------------------------
; CHR-ROM bank
;----------------------------------------------------------------

	;.incbin "tiles.chr"
