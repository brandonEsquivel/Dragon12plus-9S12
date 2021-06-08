 ;----------------------------------------------------------------------------
 ;                LLamada a subrutina, ejemplo basico
 ;                EIE, UCR
 ;                Brandon Esquivel Molina
 ;                brandon.esquivel@ucr.ac.cr
 ;                Paso de parametros por memoria, indirecto a memoria,llamado
 ;		  a subrutina
 ;--------------------------------------------------------------------------
 ;                Declaracion de estructuras de datos
 ;--------------------------------------------------------------------------
                        org $1000
CANT            equ 3                   ; Cte, cantidad de datos a copiar(tamano de los arreglos)
FUENTE          db $01,$02,$03          ; arreglo de datos fuente

                        org $1010
Destino         ds CANT                ; arreglo de datos destino
;--------------------------------------------------------------------------
;               Programa principal
;--------------------------------------------------------------------------
                        org $1500
    ldx #FUENTE                        ; se carga la direccion del arreglo fuente
    ldy #DESTINO                       ; se carga la direccion del arreglo destino
    JSR sr_COPIAR                      ; se llama a subrutina, se calcula y apila la EA de retorno
    bra *                              ; fin
;--------------------------------------------------------------------------
;                 SUBRUTINAS
;--------------------------------------------------------------------------
sr_COPIAR:
        movb A,X,A,Y             ; copia el valor de la direccion apuntado por x hacia la dirreccion apuntada por Y, indexado por acumulador
        inca                     ; incrementa acumulador usado como indice contador (offset de los arreglos)
        cmpa #CANT               ; comparacion con valor de referencia, cantidad de datos a copiar
        blo sr_COPIAR            ; si es menor, osea no ha llegado al ultimo dato a copiar, vuelve a copiar siguiente dato
        rts                      ; retorno, notese que no se ha apilado nada, en cuyo caso habria que desapilar esos valores, dejando solo la EA de retorno a desapilar