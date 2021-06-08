;******************************************************************---------
; codigo ejemplo adaptado: Clase 4.2-3 Escribir un programa que busque el numero mas
; grande de una coleccion de N numeros con signo, ubicados en la memoria a
; partir de la posicion ARRAY y lo coloque en la posicion Valor_Max
; Se realiza con barrido ascendente, direccionamiento indexado post-incremento
;******************************************************************---------
                        ;org $1000 ; INICIA MEM RAM
;ARRAY                 ds 2        ; variable direccion inicio del arreglo, dirrecion de 16 bits
                        ;luego se sobreescribe con la direccion de los datos
                        
                        org $1000
Valor_Max       ds 1     ; variable donde almacenar el valor maximo del arreglo
N               EQU 9    ; constante tamano del arreglo

                        org $2000
ARRAY           db 3,2,3,11,4,7,2,4,10  ; valores de la tabla, direccion de array

                        org $4000 ; seccion para el codigo de programa, en FLASH
        ldaa ARRAY                ; se usa acum A como indice pos del arreglo
        staa Valor_Max            ; se carga el primer valor del arreglo
        ldx #ARRAY                ; Carga primer posicion del arreglo
        ldab #N                   ; cargar tamano de arreglo N en B
lazo:
    ldaa Valor_Max          ; cargamos el valor maximo actual
    cmpa 1,x+               ; Comparamos A con X , luego lo decrementa
    bge chk_Fin             ; Salta comparando mayor que, A con X, luego de la comparacion, si es mayor A(maximo actual) que el dato en X. Si no es asi, entonces modifica el nuevo valor maximo.
    movb -1,x,Valor_Max      ; Guarda el nuevo valor maximo
chk_Fin:
    dbne b,lazo
siga: bra siga          ; bucle infinito para control de final de programa