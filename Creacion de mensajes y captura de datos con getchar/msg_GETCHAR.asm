;===============================================================================
; Obtencion de caracter por teclado y Creación de Mensajes para Printf en Ensamblador:
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                LLamado a subrutina GETCHAR y manejo de parametros
;==============================================================================
                        org $1000
; valores de control de ASCII
CR:             EQU $0D
LF:             EQU $0A
NP:             EQU $0C
PrintF:         EQU $EE88
GETCHAR:        EQU $EE84
FIN_MSG:        EQU $0

TEMP:           ds 2
               ; 103 caracteres por linea en terminal?
MSG1            db NP
		FCC " Seleccione el Mensaje (1,2) "
                FCB CR,LF,CR,LF
                dB FIN_MSG

MSG2             FCC " Se selecciono el mensaje: %i"
                 FCB CR,LF,CR,LF
                 FCC " Presione la tecla espaciadora para continuar "
                 FCB CR,LF,CR,LF
		 dB FIN_MSG

MSG3            FCC "ERROR! Presione la tecla espaciadora para continuar "
		FCB CR,LF,CR,LF
		dB FIN_MSG


;==============================================================================
;                Programa principal
;==============================================================================
                 org $2000
         lds #$3BFF

CICLO:   ldx #$0
         ldd #MSG1
         jsr [PrintF,X]

         ldx #$0
         jsr [GETCHAR,X]

         subb #$30

         cmpb #1
         beq  Mensaje
         cmpb #2
         beq  Mensaje
ERROR:   ldx #$0
         ldd #MSG3
print:   jsr [PrintF,X]
         ldx #0
         jsr [GETCHAR,X]
         cmpb #$20
         bne ERROR
	 bra CICLO


Mensaje:  pshd
          ldx #0
          ldd #MSG2
          bra print