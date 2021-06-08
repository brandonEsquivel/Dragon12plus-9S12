;==============================================================================
;Dado un arreglo de datos llamado NODO con ciertos parametros, copiar estos a
;un arreglo BUFFER en el orden inverso (cola-head), para ello use
;direccionamiento indirecto indexado para la lectura y porst-decremento para
;la escritura. El rpograma deberia solucionar el problema o no mas de 12 lineas
;==============================================================================
;                        Estructuras de Datos
                        org $1000
N               EQU     $04             ;tamano del arreglo, numero de parametros en cada NODO
PROG            EQU     $2000           ;Direccion inicio del programa
ID              EQU     $01
Location        EQU     $BA
Baud_Rate       EQU     $22
Throughput      EQU     $AF

NODO            db      #ID,#Location,#Baud_Rate,#Throughput               ;direccion inicial del arreglo NODO y sus valroes de parametros
Cont_PAR        ds      $1              ;variable de conteo de parametros transferidos

                        org $1010
BUFFER          ds      N               ; arreglo destino de los datos, de tamano maximo N
;==============================================================================
                        org PROG
                ldx  #NODO              ;cargar direccion inicio del arreglo fuente en indice X
                ldab #N                 ;se inicializa el contador CON EL ACUMULADOR B = 0
                decb                    ;se inicia en N-1, ultima posicion del array fuente
                ldy  #BUFFER            ;cargar en Y direcicon de arreglo destino para los datos que cumplen las condiciones
                aby                        ;Se coloca el puntero Y en la ultima posicion del arreglo destino;
                ldab #0                 ;se inicializa b en cero
Lazo:
                movb b,X,1,Y-           ;se aplica la copia/el traslado del parametro a la posicion destino, por acumulador b y por post-decremento
		inc Cont_PAR            ;Se incrementa el contador
		incb                    ;se incrementa acumulador b
                cmpb #N                 ;se realiza comparacion con signo
		blt lazo                ;se comprueba si se llego al final del arreglo, si b es menor quel tamano del arreglo, se salta a lazo para siguiente dato
		bra *                   ;fin de programa