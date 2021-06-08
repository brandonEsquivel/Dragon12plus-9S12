;----------------------------------------------------------------------------
;                Excepcion RTI
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                Uso de Real-time Interrupt
;--------------------------------------------------------------------------
;                Encabezado - Header
;--------------------------------------------------------------------------
#include "C:\Program Files (x86)\HCS12Text\registers.inc"   ; SE INCLUYE EL ARCHIVO CON ETIQUETAS DE REGISTROS DE PERIFERICOS Y OTROS


;==============================================================================
;                Relocalizacion de vector de interrupciones
;==============================================================================
                        org $3E70             ; este espacio de vectores de interrupciones es por word, en este caso para la Dragon 12+ que se remapea por el debug12
                        dw RTI_ISR            ; se cambia la direccion de la RTI para que se maneje en la subrutina implementada
;==============================================================================
;                 Configuracion de hardware
;==============================================================================
                           org $2000
                          bset DDRB,$FF    ; Se inicializan los bits 7-0( LEDS) del puerto B como salida
                          bset DDRJ,$02    ; Se inicializa el bit 1 del puerto J como salida(es el habilitador, para escribir en el)
                          bclr PTJ,$02     ; Se activan el bit 1 del registro J (CATODO COMUN DE LOS LEDS) habilitador

                          bset DDRP,$0F    ; Se habilitan los bits del primer byte como salida, para escribir su inhabilitacion (ENABLES de los 7Seg display)
                          movb #$0F,PTP  ; Se apagan los enables del display de 7 segmentos conectado en bus comun con los LEDs


                          movb #$80,CRGINT  ; Activacion  de la bandera de las interrupciones RTI en el registro de control general de interrupciones (bit 7)
                          movb #$17,RTICTL  ; Se configura el periodo de tiempo real de interrupcion a 1ms, con M=1,N=7 ($17)

;==============================================================================
;                 Estructuras de Datos
;==============================================================================
LEDS            ds 1    ; Variable que contiene el patron a desplegar en los LEDs
Cont_RTI        ds 1    ; variable que contiene la cuenta de interrupciones RTI
;==============================================================================
;                 Programa principal
;==============================================================================
                          lds #$3BFF            ; Cuando se procesen interrupciones SIEMPRE se debe inicializar la pila
                          cli                   ; Se activan las interrupciones mascarables
                          movb #$01,LEDS        ; Se carga el valor que habilita el primer LED en el registro desplazante LED
                          movb #250,Cont_RTI    ; Se inicializa la variable dcontadro de interrupciones RTI para 250 veces el T_rti seteado en 1ms, para un total de 250ms, aproximadamente un cuarto de segundo por LED
                          bra *                 ; Simplemente se espera a que se ejecute una interrupcion.
;==============================================================================
;                 RTI_ISR
;==============================================================================
RTI_ISR                   ; esta es la subrutina de manejo de la interrupcion que se ha REmapeado en el vector de interrupciones
         bset CRGFLG,$80  ; Se desactiva el flag de interrupciones del registro de control general de interrupciones para evitar reentrance en interrupcion
         inc Cont_RTI     ; Se incrementa el contador de RTIs
         tst Cont_RTI     ; Se evalua el contador para ver si es cero
         bne Retornar     ; Hasta que llegue a cero se sale de la RTI y pasado un segundo, se vuelve a entrar, hasta que le contador llegue a cero
         movb #250,Cont_RTI  ; Se reestablece el contador a 250
         ldaa LEDS           ; Se carga el contenido de LED en Acumulador A para pasarlo al puerto B
         staa PORTB          ; Se desplega el valor
         cmpa #$80
         bne Despl
         movb #$01,LEDS
         bra Retornar
Despl:	 lsl LEDS           ; Se rota el registro desplazante de 8 bits
Retornar:         rti         ; se retorna de la INTERRUPCION OJO
 ;----------------------------------------------------------------------------