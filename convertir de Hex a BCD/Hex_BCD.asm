; ===========================================================================
; Programa/subrutina que convierte un valor en HEX a BCD
; por el metodo de divisiones
; funciona para valores menores a 100 ( no funciona para mas bytes o # > 99)
; El resultado se almacena/retorna en B
; Registros usados: A, B, X  (ojo almacenar en temporales o pila antes de llamar)
; El valor a convertir debe estar en B
; ===========================================================================

Hex_BCD:
	clra                    ; clear A (high order of D[a:b])
        ldx     #$000A          ; Store 10 in Reg X
	idiv                    ; Unsigned D/X.  Quot in X, rem in D
        tfr     x,a             ; transfer quotient from low order
                                ; byte of X to A
        lsla                    ; shift low order nibble of A into
        lsla                    ; high order
        lsla
        lsla

        aba                     ; add A and B (high and low order nibbles)
        tfr     a,b             ; copy A into B for output
        rts