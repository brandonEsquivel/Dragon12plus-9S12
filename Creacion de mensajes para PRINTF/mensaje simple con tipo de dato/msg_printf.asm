;===============================================================================
;              Creación de Mensajes para Printf en Ensamblador:
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                LLamado a subrutina PRINTF y manejo de pila
;==============================================================================
CR:                 EQU $0D
LF:                 EQU $0A
PrintF:         EQU $EE88
GETCHAR:        EQU $EE84
FINMSG:         EQU $0

                org $1000
MSG1             FCC " Ingrese un valor entre 0 y 9"
                 dB CR,CR,LF
                 dB FINMSG

MSG2             FCC " El -valor ingresado HEX es: %u"
                 dB CR,CR,LF
                 dB FINMSG
;==============================================================================
;                Programa principal
;==============================================================================
                 org $2000
         lds #$3BFF
         ldx #$0
         ldd #MSG1
        jsr [PrintF,X]

         ldx #$0
         jsr [GETCHAR,X]

         subb #$30
         negb
         sex b,d
 
         pshd
         ldx #$0000
         ldd #MSG2
         jsr [PrintF,X]
         bra *