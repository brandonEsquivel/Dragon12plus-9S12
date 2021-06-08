;----------------------------------------------------------------------------
;                Sumar buffer num por PILA
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;--------------------------------------------------------------------------
;                Declaracion de estructuras de datos
;--------------------------------------------------------------------------
DATA    EQU $1100              ; etiqeuta inicio de declaracion de datos
PROG    EQU $1500              ; inicio de codigo de programa
PILA 	EQU $4000              ; inicio de PILA
NUM     EQU 10
                ORG DATA
BUFFER  dB 3,6,55,65,49,78,95,21,14,122 ; arreglo de daots a sumar (ojo no cabe en A 8 bits, LOL)
;--------------------------------------------------------------------------
;               Programa Principal
;--------------------------------------------------------------------------
                ORG PROG
        lds #PILA             ; inicializar puntero de pila
        ldab #NUM             ; inicialziar contador de iteraciones
        ldx #BUFFER           ; inicializar puntero de buffer a sumar

; se pasan los parametros por medio de la pila, para ello primero se deben apilar todos:

Cargar: ldaa 1,X+             ; se carga en A el valor correspondiente del arreglo
        psha                  ; se apila
        Dbne B,Cargar         ; revisar cantidad de datos apilados
        
        jsr CALCSUM           ; se llama a subrutina una vez apilados todos los valores
        leas NUM,SP           ; Se reestablece el puntero de pila una vez terminado el procesamiento
        bra *                 ; FIN
        
;--------------------------------------------------------------------------
;                Subrutinas
;--------------------------------------------------------------------------
CALCSUM:
        leas 2,SP    	     ; al llamar a subrutina, se apila la direcicon de retorno,(al final, despues de los datos) por ello, aca se saltan esos 2 bytes almacenados;   l  o  a  d     e  f  f  e  c  t  i  v  e     a  d  d  r  e  s  s
        pula                 ; se desapila el; primer valor del arreglo apilado, y se posiciona el sp en el siguiente dato apilado
        ldab #NUM-1          ; se carga en B el num-1 ya que ya se cargo el primer valor
        
sume    adda 1,SP+           ; se suma el siguiente dato apilado y se aumenta el puntero para siguiente, hasta llegar al ultimo.
        Dbne b,Sume          ; revisa si ya se procesaron/suamron y desapilaron todos los datos
        
        leas 0-NUM-2,SP      ; se recarga el puntero de pila apuntando a la direccion de retorno que se habia almacenado en los dos bytes siguientes al primer dato analizado
        rts                  ; ahora como se apunta a la EA de retorno, se llama rts y se desapila, ojo que la pila quedo en una posicion diferente a la de inicio
        
