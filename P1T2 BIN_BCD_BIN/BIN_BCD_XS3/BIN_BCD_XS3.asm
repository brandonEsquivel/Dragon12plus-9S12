 ;----------------------------------------------------------------------------
 ;                Conversor BIN_BCD , BCD_BIN
 ;                EIE, UCR
 ;                Brandon Esquivel Molina
 ;                brandon.esquivel@ucr.ac.cr
 ;                TAREA 2 - bin bcd bin
 ;--------------------------------------------------------------------------
 ;                Declaracion de estructuras de datos                                                     ;
 ;----------------------------------------------------------------------------
                                Org $1000

Bin             dw %010101010101   ; constante, mantiene el valor del numero binario a convertir en $1000-1
L               dB 11     ; constante, numero de desplazamientos para BCD de 12 bits

LOW              ds $1    ; variable temporal 1 BYTE, para trabajar a nivel nibble
BCD_HIGH         ds $1    ; variables de resultado intermedio para trabajar a nivel de Byte
BCD_LOW          ds $1    ; variables de resultado intermedio para trabajar a nivel de Byte

MASK_L          EQU $0F   ; mascara para nibble inferior
MASK_H          EQU $F0   ; mascara para nibble superior
                                Org $1010
NUM_BCD          ds $10  ; variable de resultado final BCD , inicia en $1010
TEMP             ds $2   ; variable temporal de 2 Bytes, resultados de desplazamientos
;-----------------------------------------------------------------------------
;
;         Programa principal - Conversion
;
;--------------------------------------------------------------------------
                        Org $2000
                clra          ; LIMPIEZA MEM
                clrb
                clr LOW
                clr BCD_HIGH
                clr BCD_Low
                clr TEMP
                ldd Bin       ; se carga en D el numero BIN a convertir a BCD
                lsld          ; como es un numero de 12 bits, y D es de 16 bits
                lsld          ; se desplazan los nibbles hasta la parte superior
                lsld          ; del registro, para iniciar correctamente los
                lsld          ; desplzamientos
;--------------------------------------------------------------------------
;------------------------- Conversion BIN a BCD ---------------------------
cBIN_BCD
;Realiza la conversión de un número Binario de 12 bits
;a BCD utilizando el algoritmo XS3. El número binario está en el acumulador D.
;La rutina coloca el resultado en la variable NUM_BCD ubicada en la memoria a
; partir de la posición $1010.


shift           lsld            ; Se despl c << D << 0
                rol BCD_LOW     ; Se rota el byte inferior: c << BCD_LOW << c
                rol BCD_HIGH    ; Se rota el byte superior: c << BCD_HIGH << c
                std TEMP        ; se guarda el desp actual de D -> TEMP
nibble_L0
                ldab BCD_LOW    ; se carga en b el byte bajo
                andb #MASK_L     ; se aplica mascara para primer nibble
                cmpb #$05       ; se compara >= 5
                bhs  Sumar_03L  ; Si se cumple, suma 03, cmparacion para numeros sin signo

nibble_L1       stab LOW        ; guarda el valor temporal del nibble inferior en LOW
                ldab BCD_LOW    ; vuelve a cargar el byte inferior para siguiente nibble
                andb #MASK_H     ; mascara para nibble superior del byte inferior
                cmpb #$50       ; se compara el nibble superior
                bhs  Sumar_30L  ; si se cumple, suma 03 a este nibble

nibble_H0       addb LOW        ; a este resultado se le suma el resultado del nibble inferior
                stab BCD_LOW    ; se guarda en BCL_LOW el resultado en B

                ldaa BCD_HIGH   ; se analiza ahora el byte superior, primer nibble
                anda #MASK_L     ; mascara 0F, primer nibble unicamente
                cmpa #$05       ; comparacion con 05
                bhs  Sumar_03H  ; suma o salto siguiente, para # sin signo

nibble_H1       staa LOW
                ldaa BCD_HIGH
                anda #MASK_H     ; mascara F0, nibble ALTO unicamente
                adda LOW
                staa BCD_HIGH   ; Guardo en la variable byte temporal
                ldd  TEMP       ; retomo el valor de D actual desplazado
                dec  L          ; decremento el contador
                tst  L          ; verifico que no halla llegado a cero para continuar, sino finalizara
                bne  shift      ; salta a un nuevo desplazamiento
                
output          lsld            ; Se despl c << D << 0      final
                rol BCD_LOW     ; Se rota el byte inferior: c << BCD_LOW << c final
                rol BCD_HIGH    ; Se rota el byte superior: c << BCD_HIGH << c final
                std TEMP        ; se guarda el desp actual de D -> TEMP final, para debug, deberia ser $0000
                ldaa BCD_HIGH   ; cargo byte alto del resultado
                ldab BCD_LOW    ; cargo byte bajo del resultado
                std NUM_BCD     ; guardo el resultado de D en la variable solicitada por el enunciado
                bra *     ; salta a la converion de BCD a BI
                
; branches de suma: estos procesos de sumar 3 al nibble correspondiende forman parte del
; algoritmo xs3, se pudieron sustituir por una instruccion daa de ajuste en suma BCD
Sumar_03L       addb #$03
                bra nibble_L1

Sumar_30L       addb #$30
                bra nibble_H0

Sumar_03H       adda #$03
                bra nibble_H1