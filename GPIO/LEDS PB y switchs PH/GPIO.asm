;----------------------------------------------------------------------------
;                Ejemplo de GPIO por polling
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;               DRAGON 12+ asmIDE
;--------------------------------------------------------------------------
;                Encabezado - Header
;--------------------------------------------------------------------------
#include "C:\Program Files (x86)\HCS12Text\registers.inc"   ; SE INCLUYE EL ARCHIVO CON ETIQUETAS DE REGISTROS DE PERIFERICOS Y OTROS


;--------------------------------------------------------------------------
;                Declaracion de estructuras de datos
;--------------------------------------------------------------------------

PROG            EQU         $2000         ; direccion de inicio de programa/codigo

;==============================================================================
;                 Programa principal
;==============================================================================
                        org PROG
          movb #0,DDRH          ; Se inicializa en cero el registro DDR del puerto H,e s decir, se configura como entrada
          movb #$FF,DDRB        ; Se inicializan el registro DDR del puerto B, todos como salidas (los 8 LEDS)
          bset DDRJ,$02        ; Se configura como salida el bit 1 del DDR del puerto J, para controlar los LEDs de B. COMO ES MASK, NO NECESITA # DE INMEDITAO
          bclr PTJ, $02        ; Se coloca en bajo (0) el bit 1 de la salida del puerto J, que es el catodo comun de los LEDs de B (habilitador)
LOOP:
          movb PTH,PORTB        ; bucle infinito de lectura y escritura: se escribe en el puerto B lo que se lee de las entradas del puerto H (los deep switch en rojo en la dragon12+)
          bra Loop
 ;----------------------------------------------------------------------------