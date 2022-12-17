.include "nes.inc"
.include "global.inc"
.segment "CODE"
.proc draw_bg
  ; Start by clearing the first nametable
  ldx #$20
  lda #$00
  ldy #$AA
  jsr ppu_clear_nt

  ; Draw blocks on the sides, in vertical columns
  lda #VBLANK_NMI|VRAM_DOWN
  sta PPUCTRL
  
  ; At position (2, 20) (VRAM $2282) and (28, 20) (VRAM $229C),
  ; draw two columns of two blocks each, each block being 4 tiles:
  ; 0C 0D
  ; 0E 0F

  ; The attribute table elements corresponding to these stacks are
  ; (0, 5) (VRAM $23E8) and (7, 5) (VRAM $23EF).  Set them to 0.
  ldx #$23
  lda #$E8
  ldy #$00
  stx PPUADDR
  sta PPUADDR
  sty PPUDATA
  lda #$EF
  stx PPUADDR
  sta PPUADDR
  sty PPUDATA

  rts
.endproc

