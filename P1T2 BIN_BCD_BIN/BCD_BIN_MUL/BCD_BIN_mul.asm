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

BCD             dw $2601   ; constante, mantiene el valor del numero bcd a convertir, en $1000-1
CONT            dB 3     ; constante, numero de desplazamientos para BCD de 12 bits
MASK            EQU $0F   ; mascara para nibble inferior
                                Org $1020
NUM_BIN         ds $4  ; variable de resultado final binario, inicia en $1020
TEMP            ds $4   ; variable temporal de 4 Bytes, resultados intermedios
MULT            ds $2   ; variable temporal de 2 bytes para resultado de multiplicacion
Multiplicandos  dw 10,100,1000
;-----------------------------------------------------------------------------
;
;         Programa principal - Conversion
;
;--------------------------------------------------------------------------
                        Org $2000
                clra                          ; LIMPIEZA MEM
                clrb
                clr         TEMP
                clr         MULT
;============= PRIMER BLOQUE =====================================
                ldd        BCD       ; se carga en D el numero BCD a convertir a binario
                ldx        #multiplicandos       ;indice X apunta a arreglo de multiplicadores de unidad-dec-cent       **************

                lsrd                  ;se omite el primer nibble, ya que se multiplica por 1, 4 desplazamientos a la derecha = /16;
                lsrd
                lsrd
                lsrd
                std     TEMP            ; guardando valor actual del desplazamiento
;--------------------------------------------------------------------------
;---------------------- Conversion BCD A BIN ---------------------------------
; realiza la conversión de un número BCD a Binario,
; utilizando el método de multiplicación de décadas y suma. El número en BCD es
; menor o igual a 9999 y está ubicado en el acumular D. La subrutina guarda el
; resultado en las posiciones de memoria NUM_BIN ubicadas a partir de la
; dirección $1020.



NEXT:   tst         CONT
        beq     FIN         ; verificacion de condicion de parada
        anda        #0          ; se selecciona solo el primer nibble a multiplicar           *
        andb        #MASK       ; Se obtiene solo el primer nibble
        ldy        2,X+        ; se carga en Y el multiplicando tipo word                            *******************
        emul                    ; Y * D -> Y:D
        addd         NUM_BIN     ; se suma al resultado de mult anterior
        std         NUM_BIN     ; se actualiza con el nuevo resultado;
        dec     CONT        ; decrementar contador
        ldd         TEMP        ; recargando valor
        lsrd                ; se desplaza D cuatro veces a la derecha, para siguiente nibble, es igual a D/16
        lsrd
        lsrd
        lsrd
        std         TEMP
        bra     NEXT        ; salto a siguiente verificacion
FIN:
        ldd        BCD         ; Se recarga el valro original para obtener el primer nibble (unidades)
        anda        #0          ; ignorando el resto de bits;
        andb        #MASK
        addd         NUM_BIN     ; Se suma al resultado parcial para obtener el completo;
        std        NUM_BIN     ; Resultado Final
        bra *