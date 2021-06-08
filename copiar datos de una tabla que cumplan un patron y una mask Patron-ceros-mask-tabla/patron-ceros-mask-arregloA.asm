;==================================================
;       PROBLEMA #1 - MODOS DE DIRECCIONAMIENTO
; Una posición de memoria ADRS contiene una dirección. A partir de dicha dirección
; hay un conjunto de L valores tipo byte con L<$A. Se debe realizar un programa para
; buscar en el conjunto de datos aquellos que tengan unos en al menos las posiciones
; 11001100 y trasladarlos al sector de la memoria que inicia en la dirección PATRON,
; además aquellos valores que tengan un 0 en el LSB o en el MSB hay que trasladarlos
; al sector de memoria que inicia en la posición CEROS.
; Se deben realizar dos versiones de este programa considerando:
; 1. Versión A: Hacer el movimiento de datos usando direccionamiento indexado de
; post incremento.
; 2. Versión B: Se debe hacer el movimiento de datos usando direccionamiento
;indexado por acumulador
;
;==================================================================================================
;=================================================================
; ------ NOTAS
;tipos de archivos:
;@octal
;$hex
;%bianrio
;nada decimal
;"" ASII

;Algunas instrucciones
        ; BrSet EA,MASK,OFFSET
        ; decx decy decrementa el indice
        ; Inx Iny incrementa el indice
        ; brset EA,mask,OFFSET ;direccionamiento relativo
;=================================================================
; VERSION A:

                        org $1000
ADRS    	ds      $2
L               dB	$A

                        org $1010
PATRON          ds      L               ; arreglo destino para valores que cumplen el patron, se definen L bytes de espacio, ya que es el mayor caso posible de alocamiento

                        org $1020
CEROS           ds 	L              ; arreglo destino para valores que cumplen mask de bits, se definen L bytes de espacio, ya que es el mayor caso posible de alocamiento

                        org $1500
DATOS           db      $CC,$FF,$54,$65,$98,$A6,$B7,$79,$84,$A7         ; datos a procesar, no se instancio el vector directamente, por lo que hay que pasar esa direccion de inicio

                        org $2000
                        
        movw #DATOS,ADRS   ;movw #$1500,ADRS   Se inicializa en runtime la direccion de inicio
	ldx ADRS        ;direccionamiento extendido porque usa 2 bytes
        ldy #PATRON     ;direccionamiento inmediato
        lds #CEROS      ;direccionamiento inmediato
        ldab L


Siguiente:
	brset 0,X,$CC,Mover_a_patron ;Verifica la mascara sobre el dato en el arreglo
        brclr 0,X,$01,Mover_a_ceros ;Verifica si hay un cero en LSB
        brclr 0,X,$10,Mover_a_ceros ;Verifica si hay un cero en MSB
        inx
        	
continue:
	Dbne B,siguiente            ;decrementa si es distinto de cero y salta a siguiente, si es cero, ejecuta la siguiente instr FIN;
        bra *
        	
Mover_a_patron:
	movb 1,X+,1,Y+                ;Mueve el byte dato analizado al arreglo patron almacenado en Y;
        brset -1,X,$01,continue       ;si tiene seteado el LSB, entonces salta a continuar, ya que no cumple la condicion de ceros.;
        dex
Mover_a_ceros:
        movb 1,X+,1,SP+              ;condicion de ceros, se mueve al valro de pila cargado con la direccion del arreglo CEROS;
	bra continue