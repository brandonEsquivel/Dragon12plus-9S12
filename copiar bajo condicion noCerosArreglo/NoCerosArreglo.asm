;=============================================================================
;       PROBLEMA #2 - MODOS DE DIRECCIONAMIENTO
; A partir de la posición de memoria Tabla_ADRS se han colocado las direcciones de L
; variables, donde L es una cantidad menor que 2500. Estas variables tienen datos de 1
; byte sin signo. Se deben colocar aquellas variables que contienen al menos 1 uno en
; un arreglo ubicado a partir de la posición UNOS. Realice un programa que satisfaga
; este requerimiento utilizando direccionamiento indirecto indexado
;
;============================================================================
; Notas:
;===========================================================================
; VERSION B:

                        org $1000
L               EQU     10              ; cantidad de datos a analizar, tamano de arreglo  < 2500
Tabla_ADRS      ds 	L               ; arreglo fuente de datos ;
temp            ds      1
                        org $1100
UNOS		ds	L               ; arreglo destino para valores que cumplen la condicion
                        org $1500
        ldx #Tabla_ADRS
        ldy #UNOS     			; direccionamiento inmediato
        ldab L                          ; Se carga en b L, como contador
        stab temp
	ldd #$00        		; se inicializa acum a para direccionamiento

fin:
        ldab temp
        dbne b,siguiente
        bra *
        
Siguiente:
        stab temp
	ldd #$00
        ldaa 1,x+
        dex
	cmpa
	bne tiene_unos
        inx                             ; Si no se cae en ningu caso, se pasa al siguiente dato
        bra fin
        
tiene_unos;
        movb 0,X,0,Y               ; Mueve el byte dato analizado al arreglo patron almacenado en Y con direciconamiento indexado ;
        iny
        inx
	bra fin