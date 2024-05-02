; https://github.com/DenisParyshev/Apple1_2048/blob/main/2048.asm
    PROCESSOR 6502
    ORG $280

    jmp start

N0
  BYTE $20
  BYTE $20
  BYTE $20
  BYTE $20
N1 
  BYTE $20
  BYTE $20
  BYTE $20
  BYTE $32
N2 
  BYTE $20
  BYTE $20
  BYTE $20
  BYTE $34
N3 
  BYTE $20
  BYTE $20
  BYTE $20
  BYTE $38
N4 
  BYTE $20
  BYTE $20
  BYTE $31
  BYTE $36
N5 
  BYTE $20
  BYTE $20
  BYTE $33
  BYTE $32
N6 
  BYTE $20
  BYTE $20
  BYTE $36
  BYTE $34
N7 
  BYTE $20
  BYTE $31
  BYTE $32
  BYTE $38
N8 
  BYTE $20
  BYTE $32
  BYTE $35
  BYTE $36
N9 
  BYTE $20
  BYTE $35
  BYTE $31
  BYTE $32
N10 
  BYTE $31
  BYTE $30
  BYTE $32
  BYTE $34
N11 
  BYTE $32
  BYTE $30
  BYTE $34
  BYTE $38

A11
  BYTE 1
A12
  BYTE 1
A13
  BYTE 0
A14
  BYTE 1
A21
  BYTE 2
A22
  BYTE 2
A23
  BYTE 2
A24
  BYTE 2
A31
  BYTE 3
A32
  BYTE 3
A33
  BYTE 3
A34
  BYTE 3
A41
  BYTE 4
A42
  BYTE 4
A43
  BYTE 10
A44
  BYTE 10

longLine
 BYTE $2B
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2B
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2B
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2B
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2D
 BYTE $2B
 BYTE $8D

g0mes
 BYTE $47
 BYTE $41
 BYTE $4D
 BYTE $45
 BYTE $20
 BYTE $4F
 BYTE $56
 BYTE $45
 BYTE $52

w1mes
 BYTE $59
 BYTE $4F
 BYTE $55
 BYTE $20
 BYTE $57
 BYTE $49
 BYTE $4E

logo
  BYTE $32
  BYTE $30
  BYTE $34
  BYTE $38
  BYTE $8D
  BYTE $8D
  BYTE $57
  BYTE $2D
  BYTE $55
  BYTE $50
  BYTE $8D
  BYTE $41
  BYTE $2D
  BYTE $4C
  BYTE $45
  BYTE $46
  BYTE $54
  BYTE $8D
  BYTE $44
  BYTE $2D
  BYTE $52
  BYTE $49
  BYTE $47
  BYTE $48
  BYTE $54
  BYTE $8D
  BYTE $53
  BYTE $2D
  BYTE $44
  BYTE $4F
  BYTE $57
  BYTE $4E
  BYTE $8D
  BYTE $8D
  BYTE $43
  BYTE $4F
  BYTE $44
  BYTE $45
  BYTE $3A
  BYTE $20
  BYTE $44
  BYTE $45
  BYTE $4E
  BYTE $49
  BYTE $53
  BYTE $20
  BYTE $50
  BYTE $41
  BYTE $52
  BYTE $59
  BYTE $53
  BYTE $48
  BYTE $45
  BYTE $56
  BYTE $8D
;special thanks
  BYTE $53 
  BYTE $50 
  BYTE $45 
  BYTE $43 
  BYTE $49 
  BYTE $41 
  BYTE $4C 
  BYTE $20 
  BYTE $54 
  BYTE $48 
  BYTE $41 
  BYTE $4E 
  BYTE $4B 
  BYTE $53 
  BYTE $20 
  BYTE $54 
  BYTE $4F 
  BYTE $8D 
  BYTE $49 
  BYTE $47 
  BYTE $4F 
  BYTE $52 
  BYTE $20 
  BYTE $4D 
  BYTE $55 
  BYTE $4B 
  BYTE $48 
  BYTE $41 
  BYTE $4E 
  BYTE $4F 
  BYTE $56 
  BYTE $20 
  BYTE $41 
  BYTE $4E 
  BYTE $44 
  BYTE $20 
  BYTE $43 
  BYTE $4C 
  BYTE $41 
  BYTE $55 
  BYTE $44 
  BYTE $49 
  BYTE $4F 
  BYTE $20 
  BYTE $50 
  BYTE $41 
  BYTE $52 
  BYTE $4D 
  BYTE $49 
  BYTE $47 
  BYTE $49 
  BYTE $41 
  BYTE $4E 
  BYTE $49 
  BYTE $8D 
  BYTE $46 
  BYTE $4F 
  BYTE $52 
  BYTE $20 
  BYTE $54 
  BYTE $45 
  BYTE $53 
  BYTE $54 
  BYTE $49 
  BYTE $4E 
  BYTE $47 
  BYTE $20 
  BYTE $41 
  BYTE $4E 
  BYTE $44 
  BYTE $20 
  BYTE $49 
  BYTE $4D 
  BYTE $50 
  BYTE $52 
  BYTE $4F 
  BYTE $56 
  BYTE $49 
  BYTE $4E 
  BYTE $47 
  BYTE $20 
  BYTE $54 
  BYTE $48 
  BYTE $45 
  BYTE $20 
  BYTE $47 
  BYTE $41 
  BYTE $4D 
  BYTE $45 
  BYTE $21
  BYTE $8D
;press any key
pressakey
  BYTE $8D
  BYTE $50
  BYTE $52
  BYTE $45
  BYTE $53
  BYTE $53
  BYTE $20
  BYTE $41
  BYTE $4E
  BYTE $59
  BYTE $20
  BYTE $4B
  BYTE $45
  BYTE $59

lastKey
 BYTE $0

clrsrc
  ldx #$0
  lda #$8D
clrnxtln
  inx
  jsr $FFEF
  cpx #$24
  beq doneclr
  jmp clrnxtln
doneclr
    rts

putplus
  lda #$2B
  jsr $FFEF
  lda #$20
  jsr $FFEF
    rts

put8D
  lda #$8D
  jsr $FFEF
    rts

prnnum
  asl
  rol
  tay 
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  lda #$20
  jsr $FFEF
  jsr putplus
    rts

lline
  jsr put8D
  ldx #0
nxtchar
  lda longLine,x
  jsr $FFEF
  inx 
  cpx #$1E
  beq linedone
  jmp nxtchar
linedone
    rts

print
  jsr showscore
  jsr lline
  jsr putplus
  lda A11
  jsr prnnum
  lda A12
  jsr prnnum
  lda A13
  jsr prnnum
  lda A14
  jsr prnnum
  jsr lline
  jsr putplus
  lda A21
  jsr prnnum
  lda A22
  jsr prnnum
  lda A23
  jsr prnnum
  lda A24
  jsr prnnum
  jsr lline
  jsr putplus
  lda A31
  jsr prnnum
  lda A32
  jsr prnnum
  lda A33
  jsr prnnum
  lda A34
  jsr prnnum
  jsr lline
  jsr putplus
  lda A41
  jsr prnnum
  lda A42
  jsr prnnum
  lda A43
  jsr prnnum
  lda A44
  jsr prnnum
  jsr lline
    rts 

startscreen
  ldx #0
snchr
  lda logo,x
  jsr $FFEF
  inx 
  cpx #$A0
  beq snchrdone
  jmp snchr
snchrdone  
  lda $D011        
  bpl snchrdone
  lda $D010
  sta lastKey
    rts  
  
gameover
  jsr print
  jsr put8D
  ldx #$0
gnxt1
  lda g0mes,x
  jsr $FFEF
  inx 
  cpx #$9
  beq gdn1
  jmp gnxt1
gdn1
  ldx #$0
gnxt2
  lda pressakey,x
  jsr $FFEF
  inx 
  cpx #$0E
  beq gdn2
  jmp gnxt2
gdn2
  lda $D011        
  bpl gdn2
  lda $D010
    jmp start 

putrand
  ldy #$0
  lda lastKey
  and #$0F
  tax
trynextpos
  iny
  cpy #$11
  beq gameover
  lda A11,x
  cmp #$0
  beq prnddone
  inx
  cpx #$10
  bne trynextpos
  ldx #$0 
  jmp trynextpos
prnddone
  lda #$1
  sta A11,x
  stx lastKey
    rts

init
  ldx #$0
  lda #$0
init1
  sta A11,x
  inx
  cpx #$10
  bne init1
  lda #$1
  sta A11 
    rts

field
fld0
 BYTE 0
fld1
 BYTE 0
fld2
 BYTE 0
fld3
 BYTE 0
from
  BYTE 0
to
  BYTE 0

shiftOne
  ldx to
  lda field,x
  cmp #$0
  bne s1
  ldx from
  lda field,x
  ldx to
  sta field,x
  lda #$0
  ldx from
  sta field,x
s1
    rts   

shift
  lda #$3
  sta to
  lda #$2
  sta from
  jsr shiftOne
  lda #$2
  sta to
  lda #$1
  sta from
  jsr shiftOne
  lda #$1
  sta to
  lda #$0
  sta from
  jsr shiftOne
  lda #$3
  sta to
  lda #$2
  sta from
  jsr shiftOne
  lda #$2
  sta to
  lda #$1
  sta from
  jsr shiftOne
  lda #$3
  sta to
  lda #$2
  sta from
  jsr shiftOne
    rts 

youwin
  jsr put8D
  ldx #$0
wnxt1
  lda w1mes,x
  jsr $FFEF
  inx 
  cpx #$7
  beq wnn1
  jmp wnxt1
wnn1
  ldx #$0
wnxt2
  lda pressakey,x
  jsr $FFEF
  inx 
  cpx #$0E
  beq wnnx2
  jmp wnxt2
wnnx2
  lda $D011        
  bpl wnnx2
  lda $D010
    jmp start 

sumOne  
  ldx from
  lda field,x
  cmp #0
  beq s2
  ldx to
  cmp field,x
  bne s2
  tay
  iny
  tya
  ldx to
  sta field,x
  cmp #$0B
  beq youwin
  lda #0
  ldx from
  sta field,x
s2
    rts

sum
  lda #$2
  sta from
  lda #$3
  sta to
  jsr sumOne
  lda #$1
  sta from
  lda #$2
  sta to
  jsr sumOne
  lda #$0
  sta from
  lda #$1
  sta to
  jsr sumOne
    rts

getmove
  jsr shift
  jsr sum
  jsr shift
    rts

upKey
  lda A11
  sta fld3
  lda A21
  sta fld2
  lda A31
  sta fld1
  lda A41
  sta fld0
  jsr getmove
  lda fld0
  sta A41
  lda fld1
  sta A31
  lda fld2
  sta A21
  lda fld3
  sta A11
  lda A12
  sta fld3
  lda A22
  sta fld2
  lda A32
  sta fld1
  lda A42
  sta fld0
  jsr getmove
  lda fld0
  sta A42
  lda fld1
  sta A32
  lda fld2
  sta A22
  lda fld3
  sta A12
  lda A13
  sta fld3
  lda A23
  sta fld2
  lda A33
  sta fld1
  lda A43
  sta fld0
  jsr getmove
  lda fld0
  sta A43
  lda fld1
  sta A33
  lda fld2
  sta A23
  lda fld3
  sta A13
  lda A14
  sta fld3
  lda A24
  sta fld2
  lda A34
  sta fld1
  lda A44
  sta fld0
  jsr getmove
  lda fld0
  sta A44
  lda fld1
  sta A34
  lda fld2
  sta A24
  lda fld3
  sta A14
    rts

downKey
  lda A11
  sta fld0
  lda A21
  sta fld1
  lda A31
  sta fld2
  lda A41
  sta fld3
  jsr getmove
  lda fld3
  sta A41
  lda fld2
  sta A31
  lda fld1
  sta A21
  lda fld0
  sta A11
  lda A12
  sta fld0
  lda A22
  sta fld1
  lda A32
  sta fld2
  lda A42
  sta fld3
  jsr getmove
  lda fld3
  sta A42
  lda fld2
  sta A32
  lda fld1
  sta A22
  lda fld0
  sta A12
  lda A13
  sta fld0
  lda A23
  sta fld1
  lda A33
  sta fld2
  lda A43
  sta fld3
  jsr getmove
  lda fld3
  sta A43
  lda fld2
  sta A33
  lda fld1
  sta A23
  lda fld0
  sta A13
  lda A14
  sta fld0
  lda A24
  sta fld1
  lda A34
  sta fld2
  lda A44
  sta fld3
  jsr getmove
  lda fld3
  sta A44
  lda fld2
  sta A34
  lda fld1
  sta A24
  lda fld0
  sta A14
    rts

leftKey
  lda A14
  sta fld0
  lda A13
  sta fld1
  lda A12
  sta fld2
  lda A11
  sta fld3
  jsr getmove
  lda fld3
  sta A11
  lda fld2
  sta A12
  lda fld1
  sta A13
  lda fld0
  sta A14
  lda A24
  sta fld0
  lda A23
  sta fld1
  lda A22
  sta fld2
  lda A21
  sta fld3
  jsr getmove
  lda fld3
  sta A21
  lda fld2
  sta A22
  lda fld1
  sta A23
  lda fld0
  sta A24
  lda A34
  sta fld0
  lda A33
  sta fld1
  lda A32
  sta fld2
  lda A31
  sta fld3
  jsr getmove
  lda fld3
  sta A31
  lda fld2
  sta A32
  lda fld1
  sta A33
  lda fld0
  sta A34
  lda A44
  sta fld0
  lda A43
  sta fld1
  lda A42
  sta fld2
  lda A41
  sta fld3
  jsr getmove
  lda fld3
  sta A41
  lda fld2
  sta A42
  lda fld1
  sta A43
  lda fld0
  sta A44  
    rts

rightKey
  lda A14
  sta fld3
  lda A13
  sta fld2
  lda A12
  sta fld1
  lda A11
  sta fld0
  jsr getmove
  lda fld0
  sta A11
  lda fld1
  sta A12
  lda fld2
  sta A13
  lda fld3
  sta A14
  lda A24
  sta fld3
  lda A23
  sta fld2
  lda A22
  sta fld1
  lda A21
  sta fld0
  jsr getmove
  lda fld0
  sta A21
  lda fld1
  sta A22
  lda fld2
  sta A23
  lda fld3
  sta A24
  lda A34
  sta fld3
  lda A33
  sta fld2
  lda A32
  sta fld1
  lda A31
  sta fld0
  jsr getmove
  lda fld0
  sta A31
  lda fld1
  sta A32
  lda fld2
  sta A33
  lda fld3
  sta A34
  lda A44
  sta fld3
  lda A43
  sta fld2
  lda A42
  sta fld1
  lda A41
  sta fld0
  jsr getmove
  lda fld0
  sta A41
  lda fld1
  sta A42
  lda fld2
  sta A43
  lda fld3
  sta A44
    rts

getkey
  lda $D011        
  bpl getkey
  lda $D010
  sta lastKey
  cmp #$D7
  bne oth1
  jsr upKey
  rts
oth1
  cmp #$D3
  bne oth2
  jsr downKey
  rts
oth2
  cmp #$C1
  bne oth3
  jsr leftKey
  rts
oth3
  cmp #$C4
  bne oth4
  jsr rightKey
  rts
oth4  
    jmp getkey

scoremes
 BYTE $53
 BYTE $43
 BYTE $4F
 BYTE $52
 BYTE $45
 BYTE $3A
 BYTE $20

showscore
  ldx #0
nxtscorechar
  lda scoremes,x
  jsr $FFEF
  inx 
  cpx #$6
  beq scoredone
  jmp nxtscorechar
scoredone
  lda A11
  cmp A12
  bcs na13
  lda A12
na13
  cmp A13
  bcs na14
  lda A13
na14
  cmp A14
  bcs na21
  lda A14
na21
  cmp A21
  bcs na22
  lda A21
na22
  cmp A22
  bcs na23
  lda A22
na23
  cmp A23
  bcs na24
  lda A23
na24
  cmp A24
  bcs na31
  lda A24
na31
  cmp A31
  bcs na32
  lda A31
na32
  cmp A32
  bcs na33
  lda A32
na33
  cmp A33
  bcs na34
  lda A33
na34
  cmp A34
  bcs na41
  lda A34
na41
  cmp A41
  bcs na42
  lda A41
na42
  cmp A42
  bcs na43
  lda A42
na43
  cmp A43
  bcs na44
  lda A43
na44
  cmp A44
  bcs na50
  lda A44
na50
  asl
  rol
  tay 
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  iny
  lda #$0
  adc N0,y
  jsr $FFEF
  rts

start
  jsr init 
  jsr clrsrc
  jsr startscreen
mainloop
  jsr clrsrc
  jsr putrand
  jsr print
  jsr getkey
    jmp mainloop 
