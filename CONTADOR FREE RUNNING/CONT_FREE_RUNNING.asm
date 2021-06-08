;----------------------------------------------------------------------------
;                Contador en free running con delay
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                LLamado a subrutinas y manejo de pila
;
;	realiza un free running desde cero hasta CUENTA y de regreso,
; sin detenerse, se implementa un delay para poder apreciar el valor
; incrementandose, se utilizan dos subrutinas para la implementacion
;
;--------------------------------------------------------------------------
;                Declaracion de estructuras de datos
;--------------------------------------------------------------------------
DATA    	EQU  $1000     ;etiquetas de valores fijos
PROG    	EQU  $1100
sr_DELAY 	EQU $1200
sr_BIN_BCD 	EQU $1300
PILA    	EQU $3C00
VALI            EQU $19      ; estos valores son parametros para el delay
VALM            EQU $22      ; donde el delay = retardo(NOP) x VALI x VALM x VALE
VALE            EQU $0F

		org DATA
CONT_BIN        ds $1       ; Contador ascendente o decreciente segun modo de operacion
BCD_H           ds $1       ; valor de los dos nibbles superiores del numero BCD a mostrar
BCD_L           ds $1       ; valor de los dos nibbles inferiores del numero BCD a mostrar
CUENTA          db 12       ; valor final de cuenta, admite cuenta hasta de 3 digitos
INCRE           ds $1       ; bandera de modo de operacion, 1 para Up, 0 para Down
LAZO_INT       ds $1        ; valores de control de lazos del delay
LAZO_MED       ds $1
LAZO_EXT       ds $1
;--------------------------------------------------------------------------
;                Programa Principal
;--------------------------------------------------------------------------
                org PROG
        movw #$0000,CONT_BIN    ; se inicializa el contador en cero
        movb #$01,INCRE         ; Se carga en la bandera de modo el modo 1 (incremental)
        lds #PILA               ; Se inicialzia la PILA

        
next:   ldx #INCRE              ; bucle principal, se analiza el modo de operacion
	brset 0,X,$01,UP

Down:   ldaa CONT_BIN           ; modo descendente, se carga el valor actual del contador
	dbne A,apilar           ; Se decrementa si no es cero
        staa CONT_BIN           ; Se guarda el ultimo valor rpocesado
	bra  cambio             ; Se llego a limite, se procede a cambiar de modo ;

UP:     inc CONT_BIN            ; modo ascendente, se incrementa el contador
        ldaa CONT_BIN           ; se analiza para determianr si llego al limite de cuenta indicado
        cmpa CUENTA
        bhs  cambio
        
apilar:                        ; proceso de llamado a funciones de conversion a bcd y delay
       staa CONT_BIN
       psha                    ; Se apila el valor para pasarselo a bin_bcd
       jsr BIN_BCD             ; llamada a subrutina
       leas 1,sp               ; se reestablece el puntero de pila
       movb #VALI,LAZO_INT     ; se recargan los valores de lazo delay  para pasarselos por memoria a la subrutina
       movb #VALM,LAZO_MED
       movb #VALE,LAZO_EXT
       jsr Delay               ; Se llama a subrutina Delay
       bra next                ; Siguiente iteracion
       
cambio:
	ldaa INCRE             ; Se realiza el cambio de modo ;
	coma                   ; Se obtiene el complemento a uno de todo el byte               ;
	anda #$01              ; Se obtiene solo el primer bit, bit bandera de modo                ;
	staa INCRE             ; Se almacena ya con toggle                                                                   ;
        ldaa CONT_BIN          ; se reestablece el valor del contador actual
	bra apilar             ; siguiente paso
;--------------------------------------------------------------------------
;                Subrutinas
;--------------------------------------------------------------------------
                        ORG sr_BIN_BCD
BIN_BCD:
        leas 2,SP       ; Se devuelve el puntero de pila dos posiciones, saltandose la EA de retorno apilada
        ldaa #0         ; limpia acum A
	pulb            ; se desapila en b el valor de cont_bin apilado para su conversion ;
	ldy #BCD_H	; Y = apuntando a la primer posicion de BCD_H ;
        ldx #10         ; X = 10
        idiv            ; D/X  V->X, R->D
        stab 1,Y        ; guardando el digito menos significativo en BCD_L
        xgdx            ; se intercambian valores, nueva division
        ldx #10         ; x=10
        idiv            ; Segunda division
        lslb            ; Se obtuvo el siguiente digito, pero se desplaza al nibble superior de BCD_H para una correcta visualizacion natural
        lslb
        lslb
        lslb
        addb 1,Y        ; Se suman los dos valores anteriores, dos digitos en BCD_L
	stab 1,Y        ; guardando el segundo digito + LSD
        xgdx            ; se intercambian valores, nueva division
        ldx #10         ; x=10
        idiv            ; tercera division, DIGITO MAS SIGNIFICATIVO, OJO LIMITADO A 3 DIGITOS
        stab 0,Y        ; salvando el digito MS
        leas -3,SP      ; Se reestablece el puntero de pila hacia la EA de retorno
        rts             ; retorno

                ORG sr_DELAY
Delay:
        movb #VALE,LAZO_EXT
LazoE:
        movb #VALM,LAZO_MED
LazoM:
         movb #VALI,LAZO_INT
LazoI:
        NOP
        NOP
        NOP
	NOP
	NOP
        NOP
        NOP
	NOP
	NOP
        NOP
        NOP
	NOP
	NOP
        NOP
        
        DEC LAZO_INT
        ldaa LAZO_INT
        cmpa #1
        bhs LAZOI
        
        DEC LAZO_MED
        ldaa LAZO_MED
        cmpa #1
        bhs LazoM
        
        DEC LAZO_EXT
        ldaa LAZO_EXT
        cmpa #1
        bhs LazoE
        
	rts            ; retorno, no se apilo nada, por lo que no hay que manipular el puntero de pila;