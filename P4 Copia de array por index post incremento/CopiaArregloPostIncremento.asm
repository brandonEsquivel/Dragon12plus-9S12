;==============================================================================
;Un arreglo es un conjunto de posiciones de memoria con direcciones consecutivas
;Considere un arreglo de N datos a partir de la direccion DATOS, donde N es un valor
;numérico conocido (no es una variable) con N<200. Los valores en el arreglo son
;de 1 byte con signo. Escriba un programa en lenguaje ensamblador para el 9S12
;que revise los N valores y copie los valores que siendo mayores de -50 sean
;impares, a las localizaciones de memoria a partir de la posición MAYORES.
;Utilice direccionamiento indexado de post incremento tanto para la lectura de
;los valores como para su movimiento.
;==============================================================================
;                        Estructuras de Datos
                        org $1000
N               EQU     10              ;tamano del arreglo
UMBRAL          EQU     -50             ;umbral definido por la aplicacion
PROG            EQU     $2000           ;Direccion inicio del programa
ADRS            db      $07,$01,$03,$00,$04,$06,$05,$07,$08,$09    ;un arreglo de 10 datos para prueba, podria definirse como ADRS ds N
                        org $1200
MAYORES         ds      N               ; arreglo destino de los datos, de tamano maximo N
;;==============================================================================
                        org PROG
                ldx  #ADRS               ;cargar direccion inicio del arreglo en indice X
                ldab #N                 ;cargar 10 en acumulador B, usado como contador
                ldy  #MAYORES            ;cargar en Y direcicon de arreglo destino para los datos que cumplen las condiciones
                
Lazo:
                ldaa 1,X+               ;carga X y luego, suma X+1 a pos
                cmpa UMBRAL             ;Primer condicion, Se compara con el umbral establecido (-50)
                blt FIN                 ;si es menor que -50(no cumple) salta a fin para siguiente dato o final
                brclr -1,X,$01,FIN      ;segunda condicion, si no tiene el seteado el primer bit (LSB=0) significa que es par, por tanto se salta a FIN
                dex                     ;Si no salta, es impar(LSB=1), para usar der index post incremento, se decrementa al valor analizado del array
                movb 1,X+,1,Y+          ;se aplica la copia/el traslado de los datos a la posicion destino
                bra FIN                 ;salta a comprobacion de fin
FIN:
                dbne b,lazo             ;se comprueba si se llego al final del arreglo, si b no es cero aun, se salta a lazo para siguiente dato
                bra *                   ;fin de programa