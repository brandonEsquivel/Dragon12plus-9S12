;--------------------------------------------------------------------
; Programa que convierte un numero de 16-bit almacenado en
; $1000-$1001 a BCD y lo almacena en $1010-$1014. Luego
; convierte cada digito BCD en formato ASCII en un byte
;---------------------------------------------------------------------
                org $1000
data         dw 12345         ; data to be tested
                org $1010
result         ds.b 5                 ; reserve bytes to store the result
                org $2000
        ldd data         ;D = the number to be converted
        ldy #result         ;Y = the first address of result
        ldx #10         ;X = 10
        idiv                 ;D/X ? X, R?D
        
        addb #$30         ;convert the digit into ASCII code
        stab 4,Y        ;save the least significant digit
        xgdx
        ldx #10
        idiv
        
        addb #$30         ;convert the digit 2 into ASCII code
        stab 3,Y         ;save the second to least significant digit
        xgdx
        ldx #10
        idiv
        
        addb #$30
        stab 2,Y         ;save the middle digit
        xgdx
        ldx #10
        idiv

        addb #$30
        stab 1,Y         ;save the second most significant digit
        xgdx
        addb #$30
        stab 0,Y         ;save the most significant digit
FIN        bra *