;==================================================
;       PROBLEMA #1 - MODOS DE DIRECCIONAMIENTO
; Una posici�n de memoria ADRS contiene una direcci�n. A partir de dicha direcci�n
; hay un conjunto de L valores tipo byte con L<$A. Se debe realizar un programa para
; buscar en el conjunto de datos aquellos que tengan unos en al menos las posiciones
; 11001100 y trasladarlos al sector de la memoria que inicia en la direcci�n PATRON,
; adem�s aquellos valores que tengan un 0 en el LSB o en el MSB hay que trasladarlos
; al sector de memoria que inicia en la posici�n CEROS.
; Se deben realizar dos versiones de este programa considerando:
; 1. Versi�n A: Hacer el movimiento de datos usando direccionamiento indexado de
; post incremento.
; 2. Versi�n B: Se debe hacer el movimiento de datos usando direccionamiento
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
; VERSION B:

                        org $1000
ADRS            ds      $2
L               dB      $A

                        org $1010
PATRON          ds      L               ; arreglo destino para valores que cumplen el patron, se definen L bytes de espacio, ya que es el mayor caso posible de alocamiento

                        org $1020
CEROS           ds         L              ; arreglo destino para valores que cumplen mask de bits, se definen L bytes de espacio, ya que es el mayor caso posible de alocamiento

                        org $1500
DATOS           db      $CC,$FF,$54,$65,$98,$A6,$B7,$79,$84,$A7         ; datos a procesar, no se instancio el vector directamente, por lo que hay que pasar esa direccion de inicio

                        org $2000
                        
        movw #DATOS,ADRS   ;movw #$1500,ADRS   Se inicializa en runtime la direccion de inicio
        ldx ADRS        ;direccionamiento extendido porque usa 2 bytes
        ldy #PATRON     ;direccionamiento inmediato
        lds #CEROS      ;direccionamiento inmediato
        ldab L
        ldaa #$00        ; se inicializa acum a para direccionamiento


Siguiente:
        brset A,X,$CC,Mover_a_patron 	; Verifica la mascara sobre el dato en el arreglo
	brclr A,X,$01,Mover_a_ceros 	; Verifica si hay un cero en LSB
        brclr A,X,$10,Mover_a_ceros 	; Verifica si hay un cero en MSB
        movb 0,SP,1,SP-                 ; si no se cumple ninguno, se agrega un espacio en la pila para evitar nulls (guardado de ceros)
	inx                             ; Si no se cae en ningu caso, se pasa al siguiente dato
continue:
        inca
        Dbne B,siguiente            ; decrementa si es distinto de cero y salta a siguiente, si es cero, ejecuta la siguiente instr FIN;
        lds #CEROS                  ; el puntero de pila se retorna a su posicion original
	bra *                       ; Fin del programa
                
Mover_a_patron:
        movb A,X,A,Y                ; Mueve el byte dato analizado al arreglo patron almacenado en Y con direciconamiento indexado por acumulador A;
        brset A,X,$01,continuee     ; Si tiene seteado el LSB, entonces salta a continuar, ya que no cumple la condicion de ceros.;

Mover_a_ceros:
        movb A,X,A,SP               ; condicion de ceros, se mueve al valro de pila cargado con la direccion del arreglo CEROS, con dir index por acumulador A;
        bra continue                ;
continuee:
        movb 0,SP,1,SP-
        bra continue
        