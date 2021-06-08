;----------------------------------------------------------------------------
;                GPIO Excepcion mascarable IRQ
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                ReMapeado de vectores de excepciones
;--------------------------------------------------------------------------
;                Encabezado - Header
;--------------------------------------------------------------------------
#include "C:\Program Files (x86)\HCS12Text\registers.inc"   ; SE INCLUYE EL ARCHIVO CON ETIQUETAS DE REGISTROS DE PERIFERICOS Y OTROS


;==============================================================================
;                Relocalizacion de vector de interrupciones
;==============================================================================
                        org $FFF2             ; este espacio de vectores de interrupciones es por word
                        dw IRQ_ISR            ; se cambia la direccion de la interrupcion IRQ para que se maneje en la subrutina implementada
;==============================================================================
;                 Configuracion de hardware
;==============================================================================
                           org $2000
                          bset DDRB,$01    ; Se inicializa el bit 0( LED 0) del puerto B como salida
                          bset DDRJ,$02    ; Se inicializa el bit 0 del puerto J como salida(es el habilitador, para escribir en el)
                          bclr PTJ,$02     ; Se activan el bit 1 del registro J (CATODO COMUN DE LOS LEDS) habilitador
                          movb #$C0,IRQCR  ; Modo de activacion de las interrupciones, en este caso por flanco decreciente (negedge)
;==============================================================================
;                 Programa principal
;==============================================================================
  			lds #$3BFF            ; Cuando se procesen interrupciones SIEMPRE se debe inicializar la pila
         		cli                   ; se activan las interrupciones mascarables
         		bra *                 ; simplemente se espera a que se ejecuteuna interrupcion
;==============================================================================
;                 IRQ_ISR
;==============================================================================
IRQ_ISR                 ; esta es la subrutina de manejo de la interrupcion que se ha mapeado en el vector de interrupciones
         ldaa PORTB     ; se carga el contenido del puerto B en acumulador A
         eora #$01      ; se aplica una OR exclusiva(hacer toggle al bit 0)
         staa PORTB     ; se guarda el cambio
         RTI            ; se retorna de la INTERRUPCION OJO
 ;----------------------------------------------------------------------------