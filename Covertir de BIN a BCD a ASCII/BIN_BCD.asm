;-----------------------------------------------------------------------------
; Programa que convierte un numero Binario de 16-bit almacenado en
; $1000-$1001 a BCD y lo almacena en $1010-$1014. Una propuesta distinta.
; utiliza el metodo de divisiones. Se podria hacer mas sencillo con un loop
;-----------------------------------------------------------------------------
                org $1000
dato         dw %01010101         ; valor a convertir
                org $1010
resultado   ds.b 5             ; Se reserva memora para el resultado final
                org $2000
        ldd dato        ;D = numero a convertir
        ldy #resultado  ;Y = apuntando a la primer posicion de resultado
        ldx #10         ;X = 10
        idiv            ;D/X  V->X, R->D
        stab 4,Y        ;guardando el digito menos significativo
        xgdx            ;se intercambian valores, nueva division
        ldx #10         ;x=10
        idiv            ;Segunda division
        stab 3,Y        ;guardando el segundo digito
        xgdx            ;se intercambian valores, nueva division
        ldx #10         ;x=10
        idiv            ;tercera division
        stab 2,Y        ;salvando el digito siguiente, de en medio en este caso (n=5)
        xgdx            ;se intercambian valores, nueva division
        ldx #10         ;x=10
        idiv            ;cuarta division,
        stab 1,Y        ;se guarda el segundo digito mas significativo
        xgdx            ;se intercambian valores, nueva division
        stab 0,Y        ;bit mas significativo
        bra *           ;Fin del programa