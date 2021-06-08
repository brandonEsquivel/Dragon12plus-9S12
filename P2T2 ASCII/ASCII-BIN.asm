;----------------------------------------------------------------------------
;                Conversor ASCII BIN
;                EIE, UCR
;                Brandon Esquivel Molina
;                brandon.esquivel@ucr.ac.cr
;                TAREA 2 - bin bcd bin AScII
;--------------------------------------------------------------------------
;                Declaracion de estructuras de datos
;--------------------------------------------------------------------------
PILA            EQU         $3C00         ; etiqueta direccion de inicializacion del puntero de pila
MASK            EQU         $0F           ; mascara para nibble inferior
PROG            EQU         $2000         ; direccion de inicio de programa/codigo
DATA            EQU         $1000
                      org DATA
CANT         ds         $1             ; Variable tipo byte para almacenar la cantidad de datos a procesar
CONT         ds         $1             ; Variable tipo byte para almacenar el contador de datos procesados
OFFSET       ds         $1             ; Variable tipo byte para barrer la tabla de datos por byte
ACC          ds         $2             ; variable tipo word para almacenar los resultados parciales
                        org $1500
DATOS_IOT            fcc "0129"        ; tabla de datos ASCII desde IOT a convertir a binario
Dato2                fcc "0753"
Dato3                fcc "3954"
Dato4                fcc "1875"
Dato5                fcc "0076"
Dato6                fcc "1536"
Dato7                fcc "0534"
Dato8                fcc "2755"
Dato9                fcc "2021"
Dato10               fcc "0389"
                        org $1530
DATOS_BIN       ds   CANT            ; direccion de arreglo destino para los datos convertidos a binario
;==============================================================================
;                 Programa principal
;==============================================================================
                        org PROG
              movb #10,CANT            ********* ya deberia estar pasado por getchar(), se inicializa aca
              lds #PILA                ********** usado en modo subrutina solamente
              movb #0,CONT             ; Se limpia el contador


NEXT:         ldx #1                  ; Se carga multiplicador en indice X
              movw #0,ACC             ; Se limpia el acumulador de resultados parciales
              movb #3,OFFSET          ; Se carga en OFFSET 3, ya que son 4 bytes por dato, para barrerlo de forma decreciente (cola-cabeza)

CONVERT:      ldaa CONT               ; Ciclo de conversion, se carga el contador actual, para indicar cual dato de la tabla se esta procesando
              ldab #4                 ; Cada vez que haya un nuevo dato, se multiplica por 4 para apuntar a su correspondiente posicion en la tabla
              mul                     ; Se multiplica CONT x 4 = POSICION DEL DATO EN LA TABLA
              addb OFFSET             ; Se suma el offset para apuntar al ultimo byte de ese dato apuntado
              ldy #DATOS_IOT          ; Se carga la direccion base de la tabla
              ldab B,Y                ; Se carga la direcicon efectiva completa del byte correspondiente
              subb $30                ; se convierte de ASCII a BCD
              leay 0,X                ; Se carga en Y el valor de X (multiplicador)
              emul                    ; Se multiplica (conversion BCD - binario por multiplicacion de und-dec-cent-Mil... )
              addd ACC                ; Se recupera el valor parcial calculado de multiplicaciones anteriores
              std ACC                 ; Se guarda el resultado parcial
              xgdx                    ; Se intercambia D con X para nueva multiplicacion, ahora del multiplicando
              ldaa #10                ; se carga 10 (cada vez se multiplica el multiplicando por 10 para obtener el siguiente multiplicando, desde 1 hasta 1000, 4 digitos)
              mul
              xgdx                    ; se intercambian de nuevo para cargar en X el nuevo multiplicando obtenido
              dec OFFSET              ; se decremente el OFFSET para siguiente byte del dato y se prueba si llego al ultimo
              tst OFFSET
              blt MOVE                ; si ya se proceso el ultimo byte(que seria el primero en memoria, con OFFSET = 0) Se salta a mover los datos convertidos y siguiente dato
              bra CONVERT
                                      ; se carga el contador actual en A
MOVE:         ldaa CONT               ; se carga 2 en B para multiplicar por Contador y obtener el Offset correspondiente en memoria al dato binario convertido
              ldab #2                 ; Ya que siempre se tendran 2 bytes del numero convertido(y se usan solo 12 bits, primer nibble superior es cero)
              mul
              ldy #DATOS_BIN          ; se carga direccion de arreglo destino
              movw ACC,B,Y            ; se guarda en esa EA el valor acumulado convertido
              inc CONT                ; se incrementa el contador
              ldaa CONT
              cmpa CANT               ; Se verifica si se alcanzo el numero de datos a convertir
              blo NEXT
FIN:
        bra *
 ;----------------------------------------------------------------------------