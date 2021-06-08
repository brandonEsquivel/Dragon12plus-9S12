; 16/05/2021 EIE UCR IE623 MICROPROCESADORES
; Tarea 1 - Problema 3: Escriba el codigo de programa en ensamblador para un 9S12, que
; haga toogle a los bits pares (el LSB es el bit 0) del word en las posiciones
; de memoria cuya direccion efectiva es calculada por direccionamiento indirecto
; indexado por acumulador, utilizando el  X, el cual ser cargado por programa
; con $3000. El	 programa debe cargar el acumulador D con $0100. Ademas el
; resultado debe ser guardado en la direccion apuntada por el indice Y	menos
; 3 sin alterar el puntero Y.
; Asuma los valores en memoria descritos en data0 y data 1, ademas inicialice
; el indice Y en $1500, simulando que ya tenia ese valor antes de correrlo
; ============================================================================
;       		ESTRUCTURAS DE DATOS
				org $1000
EA              ds              $2           ;registro para guardar la dirrecion efectiva del word a procesar
pares           ds              $1           ;registros temporal para almacenar un resultado intermedio de mascara
impares         ds              $1
MASK            EQU             $55          ;mascaras constantes a aplicar
MASKi           EQU             $AA
PROG            EQU             $2100        ;direcicon inicio en memoria del programa

                                org $1FFF
DATA0            db             $00,$B3,$1A,$22,$55,$08,$01        ;algunos datos de prueba
                                org $30FF
DATA1            db      	$10,$20,$00,$02,$43,$55,$AA        ;algunos datos de prueba;

                                org PROG
                ldx #$3000                      ;cargar en X el valor $3000
                ldd #$0100                      ;cargar en D el valor $0100
                ldy #$1500                      ;cargar en Y el valor $1500
CalcEA:
                ldd d,X                         ;se calcula la direccion efectiva $3100
                std EA                          ;se almacena este valor en el registro temporal EA
ToggleH:
                coma                            ;se obtiene el complemento, toggle a todo el byte
                anda #MASK                      ;se aplica mascara para obtener bits pares con toggle
                staa pares                      ;se guarda en el registro temporal pares los bit apres con toggle
                ldd EA                          ;se vuelve a cargar el valor inicial de la palabra
                anda #MASKi                     ;se obtienen solo los bit impares originales
                adda pares                      ;se suman los resultados pares con toggle + impares
                
ToggleL:
                andb #MASK                      ;mismo procedimiento pero parte baja de la palabra, acumulador B
                comb
                andb #MASK
                stab pares
                ldab EA+1
                andb #MASKi
                addb pares
Store:
                std -3,Y                        ; se guarda la palabra (2bytes) A:B (D) apartir de Y-3 ($1500-$03 = $14fd)
                bra *                           ;fin

