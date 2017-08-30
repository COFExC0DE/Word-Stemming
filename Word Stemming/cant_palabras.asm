;Jose P Barrientos R
;imprimir en pantalla
%macro print  2
        push rax
        push rsi
	mov rax, 1      ;write
	mov rdi, 1      ;strout
	mov rsi, %1     ;Buffer
	mov rdx, %2     ;Bufflen
	syscall
        pop rsi
	pop rax
%endmacro 

%macro limpiar 1
        push rax
	push rsi
        mov bl, 20h
	mov rax, %1
	mov rsi, 80
     ini:
	mov [Palabra + rax], bl
	inc rax
 	cmp rax,rsi
	jnz ini
	pop rsi
	pop rax
%endmacro

%macro print_numero 1
	push r10
	push r15
        mov r10, %1
      	call ItoA
	print RespuestaItoA, r15
	pop r15
	pop r10
%endmacro

;leer en patalla
%macro read  2
	mov rax, 0      ;leer de un texto
	mov rdi, 0      ;strin
	mov rsi, %1     ;Buffer
	mov rdx, %2     ;buflen
	syscall
%endmacro

;exit
%macro exit  0
    mov rax, 60    ;le dice al sisterma que ya va aterminar o a parar la funcionque este realizando
    mov rdi, 0     ;lo imprime
    syscall        ;llama al sistema para ejecutar las anteriores funciones.
%endmacro


section .bss
   Buffer resb 4000              ;resb 4k de memoria
   Buffer2 resb 4000             ;resb 4k de memoria
   Buffer_abc resb 4000          ;resb 4k de memoria
   Repetidas resb 4000		 ;resb 4k de memoria
   Bufflen equ $-Buffer          ;saber el largo del texto 
   Palabra resb 80               ;resb 80b de memoria 
   Espacio resb 1 

section .data

canti: db " - Se repite una cantidad de: "

signos: db 21h, 22h, 23h, 24h, 25h, 26h, 28h, 29h, 2Ah, 2Bh, 2Ch, 2Dh, 2Eh, 2Fh, 30h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 3Ah, 3Bh, 3Ch, 3Dh, 3Eh, 3Fh,40h, 5Bh, 5Ch, 5Dh, 5Eh, 5Fh, 60h, 7Bh, 7Ch, 7Dh, 7Eh, 7Fh ; los signos que se deberian quitar
signos_len equ $-signos ;el largo de los signos que existen en ASCII

abecedario: db 61, 62, 63
abecedario_len equ $ - abecedario


print_porter db "PORTER!!",10
print_porter_len    equ $-print_porter


RespuestaItoA: db "................................................................................"
RespuestaItoA_Len equ $ - RespuestaItoA ;para las respuestas.


cant_pala: db "Cantidad de palabras: ",0  ; salida que va a decir cantidad de palabras
cant_pala_len equ $-cant_pala              ;el largo de los signos

_enter: db " ",10
_enter_len equ $-_enter

cant_pala1: db "Cantidad de palabras repetidas: ",0  ; salida que va a decir cantidad de palabras
cant_pala_len2 equ $-cant_pala1              ;el largo de los signos

Abecedario db "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz"
Abecedario_Len equ $ - Abecedario

Info1: db "PORTER: ", 10
Info1_Len equ $ - Info1

Info2: db "INFO DE PALABRAS. ", 10
Info2_Len equ $ - Info2

Info3: db "Cantidad de palabras repetidas: ", 10
Info3_Len equ $ - Info3

Info4: db "PALABRAS ORDENADAS Y CON PORCENTAJES.", 10
Info4_Len equ $ - Info4

Mierda: db 10, "MIERDA", 10
Mierda_Len equ $ - Mierda

SaltoDeLinea: db 10
SaltoDeLinea_Len equ $ - SaltoDeLinea

SeparadorPrincipal: db "==================================================", 10
SeparadorPrincipal_Len equ $ - SeparadorPrincipal

SeparadorSecundario: db "--------------------------------------------------", 10
SeparadorSecundario_Len equ $ - SeparadorSecundario

section .text

    global _start ;el codigo arranca en _start



_start:

   read Buffer, 4000    ;llama a la macros de leer texto para cargarlo
   mov r9, rax          ;guardar en r9<-rax
   mov bl, 20h          ;espacio
   xor rsi, rsi         ;contador para el Buffer
   xor r10, r10         ;contador para el Buffer2
   mov r15, signos_len


;quitar cualquier signo que no sea letra

_loop:
   mov al, [Buffer + rsi]   ;guardamos la primer letra
   xor r14, r14             ;reiniciar el registro 14
   jmp _signos              ;saltar a _signos

_signos:
 
   mov bl,[signos+r14]      ;guardar la letra o el signo en el bl
   inc r14                  ;incrementar el r14 
   cmp al, bl               ;comparar al = bl y si son iguales jmp to _cambio
   jz _cambio               ;salto a _cambio
   cmp r15, r14             ;en caso que r15,r14 no sean  iguales sigue en el loop de _signos
   jne _signos

_sigue:
   inc rsi                  ;incrementar el rsi
   cmp rsi, r9              ;comparar el rsi si tiene el tamano de len
   jne _loop                ;en caso que tenga el tamano del len saltar al _loop
   xor rsi,rsi              ;se reinicia rsi
   xor r14,r14              ;se reinicia el r14
   jmp loop                 ;salta al loop
      
_cambio:
   mov bl, 00h              ;carga el bl por NONE
   mov [Buffer + rsi], bl   ;mover el bl por el signo encontrado
   jmp _sigue               ;jmp a siguiente


;I'm -> I am, don't-> do not, he's -> he is


loop:
   mov al, [Buffer + rsi]
   ;cmp al, 2ch ;compara con la ,
   ;jz cambio   ;cambia la coma por espacio
   cmp al, 27h ;compara con '
   jz casos    ;brinca a los casos para cual caso es

sigue:
   mov al, [Buffer + rsi]
   mov [Buffer2 + r10], al ;inserta en el Buffer2 el contenido del Buffer
   inc rsi
   inc r10
   cmp rsi, r9
   jne loop
   print _enter,_enter_len
   print Buffer2, Bufflen  ;imprime el Buffer2 con los cambios
   xor rsi,rsi
   xor r10,r10
   mov bl,20h
   jmp cantidad_pal
      

cambio:
   mov [Buffer + rsi], bl    ;cambia la  ' por un espacio
   jmp sigue                 ;salto a siguiente   

casos:
   inc rsi                ;sube una posición
   mov al, [Buffer + rsi] 
   cmp al, 6dh 		  ;compara si el valor que sigue es una m    
   jz am 		  ;salta al caso i'm

   cmp al, 74h 		  ;compara si el valor que sigue es una n    
   jz _not 		  ;salta al caso don't

   cmp al, 73h 		  ;compara si el valor que sigue es una s    
   jz is 		  ;salta al caso He's
   
   ;aqui van los otros casos que el que siga sea una r o t
   jmp sigue


am: ;caso para el i'm = i am
   dec rsi		   ;se devuelve al '
   mov al, 20h 		   ;espacio 
   mov [Buffer2 + r10], al ;coloca un espacio en el Buffer 2 en vez de '
   inc rsi 	           ;sube una pos en el Buffer
   inc r10 	           ;sube una pos en el Buffer2
   mov al, 61h 		   ;mueve una a al al
   mov [Buffer2 + r10], al ;coloca una a en el Buffer2 seguida del espacio
   inc r10                 ;sube pos en el Buffer2
   jnz sigue
   

is: ;caso para el i'm = i am
   dec rsi		   ;se devuelve al '
   mov al, 20h 		   ;espacio 
   mov [Buffer2 + r10], al ;coloca un espacio en el Buffer 2 en vez de '
   inc rsi 	           ;sube una pos en el Buffer
   inc r10 	           ;sube una pos en el Buffer2
   mov al, 69h 		   ;mueve una a al al
   mov [Buffer2 + r10], al ;coloca una a en el Buffer2 seguida del espacio
   inc r10                 ;sube pos en el Buffer2
   jnz sigue


_not: 
   dec rsi  	    	        ;se devuelve al '
   dec r10
   mov al, 20h   		        ;espacio 
   mov [Buffer2 + r10], al      ;coloca un espacio en el Buffer 2 en vez de '
   inc rsi 	                    ;sube una pos en el Buffer
   inc r10 	                    ;sube una pos en el Buffer2
   mov al, 6eh 		            ;mueve una a al al
   mov [Buffer2 + r10], al      ;coloca una a en el Buffer2 seguida del espacio
   inc r10                      ;sube pos en el Buffer2
   mov al, 6Fh 		            ;mueve una a al al
   mov [Buffer2 + r10], al      ;coloca una a en el Buffer2 seguida del espacio
   inc r10
   jnz sigue


;CANTIDAD DE PALABRAS EN EL TEXTO

cantidad_pal:
    mov bl,20h              ;cargar al bl de nuevo 20h(espacio)
    mov al, [Buffer2+rsi]   ;cargar del Buffer2 al rsi
    inc rsi                 ;incrementar el rsi par ver la siguiente palabra
    cmp al, bl              ;cuando se encuantra space hace un salto a contar para llevar la cuenta de la cantidad de palabras que tiene 
    jz contar               ;saltar a contar
    cmp r9,rsi              ;cuando el largo del texto es igual al rsi entonces salta a imp_cantidad_pal
    jz imp_cant_pal     ;imprimir cantidad de palabras que habian en el texto
    jmp cantidad_pal


contar:
     inc r10
     jmp cantidad_pal

;------------------------------
;   PROCEDIMIENTO
;------------------------------
; IN:
; r10 -> toma r10 y lo convierte a Ascii
; OUT
; RespuestaItoA -> respuesta Ascii del procedimiento
; r15 = largo del string
ItoA:
    push r14
    push rax
    push rdx
    push r13

    xor rax, rax
    xor rdx, rdx
    xor r15, r15 ; queda largo del string
    xor r13, r13
    xor r14, r14

    mov r14, 10d ; r14 -> el divisor
    mov rax, r10 ; para trabajar sobre rax

    .CuentaLargoString:
        xor rdx,rdx
        div r14
        mov r14, 10d ; reasigna por si acaso
        inc r15
    cmp rax, 0d ; si r14 (dividendo) > 0
        jg ItoA.CuentaLargoString

    mov rax, r10 ; para trabajar sobre rax
    mov r13, r15 ; guarda r15 porque se va a modificar para recorrer

    .DaRespuesta:
        xor rdx,rdx
        div r14
        mov r14, 10d ; reasigna por si acaso
        add rdx, 30h
        dec r15
        mov [RespuestaItoA + r15], dl
    cmp rax, 0d ; si rax > 0
        jg ItoA.DaRespuesta
    mov r15, r13 ; recupera el largo del string

    pop r13
    pop rdx
    pop rax
    pop r14

ret


imp_cant_pal:
    inc r10                             ;incrementamos el r10 para poder tener toda la salida correcta
    call ItoA                           ;llamamos a la funcion ItoA
    print _enter,_enter_len             ;imprimir un 10(enter o salto de linea)
    print cant_pala, cant_pala_len      ;imprimir texto que quiero imprimir
    print  RespuestaItoA, r15           ;imprime la cantidad de palabras
    print _enter,_enter_len             ;imprimir un 10(enter o salto de linea)
    print _enter,_enter_len             ;imprimir un 10(enter o salto de linea)
    xor r15,r15                         ;reiniciar r15 que quede en 0
    xor r10,r10                         ;reiniciar r15 que quede en 0
    xor rsi,rsi                         ;reiniciar r15 que quede en 0
    xor bl,bl                           ;reiniciar r15 que quede en 0
    jmp porter                          ;cuando termina de imprimir todo lo anterior empezamos con el algoritmo de porter!!


;----------------------------------------------------------------------------------------------------------------;
;----------------------------------------------------------------------------------------------------------------;
;----------------------------------------------------------------------------------------------------------------;
;                                           PORTER!!!!!!!!!!!!!!!!                                               ;
;----------------------------------------------------------------------------------------------------------------;
;----------------------------------------------------------------------------------------------------------------;
;----------------------------------------------------------------------------------------------------------------;


porter:
    mov al, [Buffer2+rsi]       ;guarda Buffer2 -> al
    ;S
    cmp al,73h                  ;compara si al = s
    jz cambiar_s                ;salta a cambiar las s
    ;ATE
    cmp al,61h                  ;comparar si al =a
    jz cambiar_ate              ;saltar a cambiar_ate
    ;BLE
    cmp al,62h                  ;comparar si al =b
    jz cambiar_BLE
    ;t
    cmp al,74h                  ;comparar si al =t
    jz cambiar_IONAL              ;saltar a cambiar_ate
    ;n
    cmp al,6eh                  ;comparar si al =n
    jz cambiar_NCI
    ;IZE
    cmp al,69h                  ;comparar si al =i
    jz cambiar_IZE
    ;ed
    cmp al,64h                  ; compara al = d
    jz cambiar_ed
    inc rsi                     ;inc rsi
    cmp r9,rsi                  ;comparar si rsi = r9 y imprime y termina el programa    
    jne porter                  ;saltar porter_s si rsi es diferente a r9
    jmp exit2                   ;si rsi = r9 salta a exit2 para terminar y imprimir los cambios en Buffer2(cambios de porter etc)  

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "S" "SSES" "SS" "ES"                                          ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_s:
    ;ss
    inc rsi                     ;inc el rsi
    mov al, [Buffer2+rsi]       ;cargar Buffer2->al
    cmp al,73h                  ;comparar si el siguiente es una s    
    jz cambiar_ss               ;salta a cambiar ss ya que es un caso
    ;es
    dec rsi                     ;rsi-1
    dec rsi                     ;rsi-1
    mov al, [Buffer2+rsi]       ;mover al Buffer2->al
    cmp al,65h                  ;comparar si al = "e"(65h) 
    jz cambiar_es               ;saltar a cambiar_es 
    ;s
    inc rsi                     ;rsi+1
    inc rsi
    mov al, [Buffer2+rsi]       ;cargar Buffer2->al
    cmp al,00h                  ;comparar si el siguiente es un espacio   
    jz cambiar_la_s             ;salta a cambiar ss ya que es un caso
    mov al, [Buffer2+rsi]       ;cargar Buffer2->al
    cmp al,00h                  ;comparar si el siguiente es un espacio   
    jz cambiar_la_s             ;salta a cambiar ss ya que es un caso
    jmp porter

cambiar_la_s:    
    dec rsi
    mov al, 00h                 ;cargar al al un NONE(00h)
    mov [Buffer2+rsi],al        ;cargar en el Buffer2 <- al
    inc rsi                     ;incrementar el rsi para continuar con lo que falta del texto
    jmp porter                  ;saltar a porter

cambiar_ss:
    inc rsi                     ;rsi+1
    mov al, [Buffer2+rsi]       ;mover al <-Buffer2
    cmp al,20h                  ;comparar si al = ESPACIO(20h)
    jz porter                   ;si es igual a espacio saltar a porte
    mov al, 00h                 ;mov al <- 00h(NONE)
    mov [Buffer2+rsi],al        ;cargar al<-NONE
    jmp cambiar_ss              ;saltar a cambiar_ss

cambiar_es:
    mov al, 00h                 ;mover al <- 00h
    mov [Buffer2+rsi],al        ;mover Buffer2->al
    inc rsi                     ;rsi+1    
    mov [Buffer2+rsi],al        ;mover Buffer2->al
    inc rsi
    jmp cambiar_s               ;saltar a cambiar s para que quite la s del final    


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "ATE"                                                         ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;


cambiar_ate:
    
    inc rsi                 ;incrementar el rsi
    ;t
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,74h              ;al = t
    jz cambiar_ate          ;al = t salta a cambiar_ate
    ;i
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,69h              ;al = i
    jz cambiar_ATIONAL      ;al = t salta a cambiar_ational
    ;e
    mov al,[Buffer2+rsi]    ;al<-buffer
    cmp al,65h              ;al = e 
    jz cambiar_ate          ;al = e salta a cambiar_ate
    ;d
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,64h              ;al = d
    jz cambiar_ate1         ;al = d cambiar_ate1
    jmp porter              ; si ningua de las anteriores funciono siguiente en porter

cambiar_ate1:
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    inc rsi                 ;incrementar el rsi
    jmp porter              ;saltar a porter cuando termine


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "BLE"                                                         ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;


cambiar_BLE:
    
    inc rsi                 ;incrementar rsi
    mov al,[Buffer2+rsi]    ;al<-buffer2
    cmp al,6Ch              ;al = l
    jz cambiar_BLE          ;si al =l entonces salta a cambiar_ble
    cmp al,65h              ;al = e
    jz cambiar_BLE          ;si al =l entonces salta a cambiar_ble
    cmp al,64h              ;al = d
    jz cambiar_1BLE         ;si al =l entonces salta a cambiar_ble
    jmp porter              ;si ninguna de las anteriores funciono continuar con las demas a la funcion porter

cambiar_1BLE:

    mov al,00h              ;cargar a al <- 00h
    mov [Buffer2+rsi],al    ;guardar en el buffer2<-al
    inc rsi                 ;inc el rsi
    jmp porter              ;regresar a porter

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "IZE"                                                         ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;


cambiar_IZE:
    
    inc rsi                 ;rsi+1
    ;v
    mov al,[Buffer2+rsi]    ;mover al<-buffer2
    cmp al,76h              ;al = v
    jz cambiar_IVENESS      ;si al =z entonces salta a cambiar_IVENESS
    ;z
    cmp al,7Ah              ;al = z
    jz cambiar_IZE          ;si al =z entonces salta a cambiar_ize
    ;e
    cmp al,65h              ;al = e
    jz cambiar_IZE          ;si al =e entonces salta a cambiar_ize    
    cmp al,64h              ;al = d
    ;d
    jz cambiar_1IZE         ;si al =d entonces salta a cambiar_ize
    cmp al,6eh              ;al = n
    ;a
    jz cambiar_ING          ;si al =n entonces salta a cambiar_ing
    cmp al,61h              ;al = a
    jz cambiar_IZA          ;si al =n entonces salta a cambiar_ize
    jmp porter              ;si ninguna de las anteriores funciono siguie con la funcion de porter 
    

cambiar_1IZE:
    mov al,00h              ;al<=00h
    mov [Buffer2+rsi],al    ;cargamos al a buffer2
    inc rsi                 ;rsi+1
    jmp porter              ;saltar a porter para continuar con las demas... 

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "ING"                                                         ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_ING:
    
    inc rsi                 ;rsi +1
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,67h              ;al = g
    jz quitar_ING           ;salta a ing si al =g 
    jmp porter              ;si lo anterior no funciono entonces saltar a porter

quitar_ING:
    
    mov al,00h              ;al<-00h
    mov [Buffer2+rsi],al    ;buffer2 <-al
    dec rsi                 ;rsi -1
    mov [Buffer2+rsi],al
    dec rsi                 ;rsi -1
    mov [Buffer2+rsi],al
    jmp doble_letra_igual   ;saltar a verificar depende existe varias reglas para ing la de verificar es si es doble

doble_letra_igual:
    
    dec rsi                 ;rsi -1
    mov al,[Buffer2+rsi]    ;cargamos el Buffer2->al
    dec rsi                 ;rsi -1
    mov cl,[Buffer2+rsi]    ;cargamos el Buffer2->cl
    inc rsi                 ;rsi +1
    cmp al,cl               ;comparamos si al = cl    
    jz borrar_ing           ;si encontramos que que tenemos 2 letras iguales las vamos a verificar y a cambiar para que la palabra raiz quede en el orden que necesitamos
    add rsi,4               ;rsi +4
    jmp porter              ;si no funciona saltamos a porter!

borrar_ing:
    mov al,00h              ;se carga 00h->al
    mov [Buffer2+rsi],al    ;se cambia al por el Buffer2
    jmp porter              ;termina la funcion y continua con porter     

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "ED"                                                          ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_ed:

    dec rsi                 ;rsi-1
    mov al,[Buffer2+rsi]    ;al->Buffer2
    ;none
    cmp al,00h              ;al = none
    jz subir_d               ;si al=e salta a cambiar_ed
    ;espacio
    cmp al,20h              ;al = espacio
    jz subir_d               ;si al=e salta a cambiar_ed
    ;e
    cmp al,65h              ;al = e
    jz cambiar_ed           ;si al=e salta a cambiar_ed
    ;si tiene antes doble letra igual
    dec rsi                 ;rsi-1
    mov cl, [Buffer2+rsi]   ;mover el buffer2 -> cl
    cmp al, cl              ; compara si al= cl
    jz quitar_ed            ;si al =cl entonces salta a quitar_ed
    jmp revisar_ed          ;si al es diferente de cl entonces salta a revisar_ed

subir_d:
    add rsi,2
    jmp porter

revisar_ed:
    inc rsi                 ;rsi+1
    inc rsi                 ;rsi+1
    mov al, 00h             ;al<-00h
    mov [Buffer2+rsi],al    ;buffer<-al
    inc rsi                 ;rsi+1
    mov [Buffer2+rsi],al    ;mover Buffer2->al
    inc rsi                 ;rsi+1
    jmp porter              ;salta a porter...

quitar_ed:
    inc rsi                 ;rsi +1
    cmp al,69h              ;al = i
    jz subir_d               ;si al=e salta a cambiar_ed
    mov al, 00h             ;al<-00h
    mov [Buffer2+rsi],al    ;carga el al en el Buffer2
    inc rsi                 ;rsi+1
    mov [Buffer2+rsi],al
    inc rsi                 ;rsi+1
    mov [Buffer2+rsi],al
    inc rsi                 ;rsi+1
    jmp porter              ;salta a porter...



;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "ATIONAL"                                                     ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
    
cambiar_ATIONAL:
    
    inc rsi                 ;incrementar el rsi
    ;o
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,6fh              ;al = o
    jz cambiar_ATIONAL          ;al = t salta a cambiar_ate
    ;n
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,6eh              ;al = n
    jz cambiar_ATIONAL          ;al = t salta a cambiar_ate
    ;a
    mov al,[Buffer2+rsi]    ;al<-buffer
    cmp al,61h              ;al = a 
    jz cambiar_ATIONAL          ;al = e salta a cambiar_ate
    ;l
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,6ch              ;al = l
    jz cambiar_1ATIONAL         ;al = d cambiar_ate1
    jmp porter              ; si ningua de las anteriores funciono siguiente en porter

cambiar_1ATIONAL:
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    dec rsi                 ;incrementar el rsi
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    dec rsi                 ;incrementar el rsi
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    dec rsi                 ;incrementar el rsi
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    dec rsi                 ;incrementar el rsi
    mov al,65h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    jmp porter              ;saltar a porter cuando termine


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "TIONAL"                                                     ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
   


cambiar_IONAL:
    inc rsi                 ;incrementar el rsi
    ;i
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,69h              ;al = o
    jz cambiar_IONAL          ;al = t salta a cambiar_ate
    ;o
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,6fh              ;al = n
    jz cambiar_IONAL          ;al = t salta a cambiar_ate
    ;n
    mov al,[Buffer2+rsi]    ;al<-buffer
    cmp al,6eh              ;al = a 
    jz cambiar_IONAL          ;al = e salta a cambiar_ate
    ;a
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,61h              ;al = l
    jz cambiar_IONAL         ;al = d cambiar_ate1
    ;l
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,6ch              ;al = l
    jz cambiar_1IONAL         ;al = d cambiar_ate1
    jmp porter              ; si ningua de las anteriores funciono siguiente en porter

cambiar_1IONAL:
    mov al,00h              ;al<-NONE
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    dec rsi                 ;incrementar el rsi
    mov [Buffer2+rsi],al    ;mover al->Buffer2
    jmp porter              ;saltar a porter cuando termine


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "NCI"                                                     ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_NCI:
    
    inc rsi                 ;incrementar el rsi
    ;c
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,63h              ;al = c
    jz cambiar_NCI          ;al = t salta a cambiar_ate
    ;i
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,69h              ;al = i
    jz cambiar_1ENCI          ;al = t salta a cambiar_ate
    jmp porter              ; si ningua de las anteriores funciono siguiente en porter

cambiar_1ENCI:
    
    mov al, 65h
    mov [Buffer2,rsi],al
    jmp porter

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "IZA"                                                     ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_IZA:
    
    mov al, 65h
    mov [Buffer2,rsi],al
    inc rsi
    mov al, 00h
    mov [Buffer2,rsi],al
    inc rsi
    mov [Buffer2,rsi],al
    inc rsi
    mov [Buffer2,rsi],al
    inc rsi
    mov [Buffer2,rsi],al
    jmp porter

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                        palabras que terminan con "IVENESS"                                                     ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

cambiar_IVENESS:
    
    inc rsi                 ;incrementar el rsi
    ;e
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,65h              ;al = o
    jz cambiar_IVENESS      ;al = t salta a cambiar_ate
    ;n
    mov al,[Buffer2+rsi]    ;guardar en el al <- Buffer2
    cmp al,6eh              ;al = n
    jz cambiar_IVENESS      ;al = t salta a cambiar_ate
    ;e
    mov al,[Buffer2+rsi]    ;al<-buffer
    cmp al,65h              ;al = a 
    jz cambiar_IVENESS      ;al = e salta a cambiar_ate
    ;s
    mov al,[Buffer2+rsi]    ;al<-Buffer2
    cmp al,73h              ;al = l
    jz cambiar_1IVENESS     ;al = d cambiar_ate1
    jmp porter              ; si ningua de las anteriores funciono siguiente en porter

cambiar_1IVENESS:
    inc rsi
    mov al, 00h
    mov [Buffer2+rsi],al
    dec rsi 
    mov [Buffer2+rsi],al
    dec rsi
    mov [Buffer2+rsi],al
    dec rsi
    mov [Buffer2+rsi],al
    jmp porter

;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                                                abecedario                                                      ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

FixCantPalabras: 
   inc r10
jmp InsertarPalabra

;========================================================
;               PALABRAS ORDENADAS
;========================================================
; r15 -> sigue Abecedario
; r14 -> sigue Buffer_abc
; r13 -> recorre Buffer2
OrdenaPalabras:
   xor r13, r13
   mov bl, [Abecedario + r15]
   jmp BuscaInsertaPalabra
   Continuacion_BuscaInserta:   
   inc r15
cmp r15, Abecedario_Len ; mientras recorreAbecedario < Abecedario_Len
   jl OrdenaPalabras
ret

BuscaInsertaPalabra:
   ; Si Bufer y Abecedario
   mov cl, [Buffer2 + r13]
   cmp bl, cl ; si [Buffer] == [Abecedario] 
       jne .ContinuaBuscaInsertarPalabra
   
   ; Si r13 == 0 (Para primer palabra)
   cmp r13, 0
       je InsertarPalabra

   ; Si posicion anterior es espacio (comprobar que es inicio de palabra)
   dec r13
   mov cl, [Buffer2 + r13]
   inc r13
   cmp cl, 32d ; Comrueba que la posicion anterior sea un espacio (verifica inicio de palabra)
       je InsertarPalabra
   cmp cl, 10d ; Comrueba que la posicion anterior sea un espacio (verifica inicio de palabra)
       je FixCantPalabras
   
   ; SINO
   .ContinuaBuscaInsertarPalabra:
   inc r13
cmp r13, r9 ; si recorreBuffer2 < LargoBuffer2
   jl BuscaInsertaPalabra
jmp Continuacion_BuscaInserta ; SINO

InsertarPalabra:
   mov cl, [Buffer2 + r13]
   mov [Buffer_abc + r14], cl ; Inserta caracter en Buffer_abc
   inc r14
   inc r13

   cmp r13, r9 ; si recorreBuffer2 >= r9
       jnl InsertaSaltoLinea

mov cl, [Buffer2 + r13]
cmp cl, 32d ; Si [pos] == espacio
   je InsertaSaltoLinea
cmp cl, 10d ; Si [pos] == salto de linea
   je InsertaSaltoLinea
cmp cl, 00h ; si [pos] == none
    je InsertaSaltoLinea
   jmp InsertarPalabra ; SINO
   
InsertaSaltoLinea:
   mov cl, 10d
   mov [Buffer_abc + r14], cl
   inc r14
jmp BuscaInsertaPalabra


;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
;                                                   EXIT                                                         ;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////;

exit2:

    print _enter,_enter_len
    
   ;------------------------
   ; Llama Ordenar Palabras
   push r15
   push r13
   push rbx
   push rcx

   xor r15,r15
   xor r14, r14
   xor r13, r13
   xor rbx, rbx
   xor rcx, rcx
   call OrdenaPalabras

   pop rcx
   pop rbx
   pop r13
   pop r15
   ;------------------------
   ;=================================================================================
   ;------------------------------------------------
   ;       INICIO INTERFAZ
   ;------------------------------------------------
   ; INTERFAZ INICIAL DEL PROGRAMA
   print SaltoDeLinea, SaltoDeLinea_Len
   print SeparadorPrincipal, SeparadorPrincipal_Len

   ; IMPRIME TEXTO
   print Info1,Info1_Len ; Imprime "TEXTO LEIDO"
   print Buffer2, r9  ;imprime el Buffer2 con los cambios

   print SaltoDeLinea, SaltoDeLinea_Len
   print SeparadorSecundario, SeparadorSecundario_Len

   ; INFORMACION DE PALABRAS
   print Info2, Info2_Len
       ; Cantidad de palabras
       print cant_pala, cant_pala_len
       print  RespuestaItoA, RespuestaItoA_Len
       print SaltoDeLinea, SaltoDeLinea_Len
       ; Cantidad de palabras repetidas
       print Info3, Info3_Len
   ; PALABRAS ORDENADAS Y CON %
   
   print SeparadorSecundario, SeparadorSecundario_Len
   print Info4, Info4_Len   
   ;print Buffer_abc, r14

   print SeparadorPrincipal, SeparadorPrincipal_Len
   print SaltoDeLinea, SaltoDeLinea_Len
   ;------------------------------------------------
   ;       FIN INTERFAZ
   ;------------------------------------------------


   ;------------------------------------------------
   ;      PALABRAS REPETIDAS
   ;------------------------------------------------


   push r14
   xor r10, r10   ;recorre abc
   xor rax, rax   ;recorre palabra
   xor r12, r12   ;contador repetidas
   xor r13, r13   ;contador del ciclo

;AGREGA LA PALABRA
inicio:
   mov bl, 0ah                  ;mueve un salto de linea
   cmp [Buffer_abc + r10], bl   ;compara si hay un salto de linea
   jz  contar_re                ;brinca a contar_re si está al final de una palabra
   mov bl, [Buffer_abc + r10]   ;mueve la letra en la posición
   mov [Palabra + rax], bl      ;la mueve en memoria a Palabra
   inc rax                      
ok:
   inc r10			;incrementa el contador del Buffer_abc
   inc r13                      ;incrementa el contador del ciclo 
   cmp r13, r14                 ;verifica si ya finalizó el ciclo
   jnz inicio
   print _enter,_enter_len 	;imprime salto de línea
   exit                         ;termina la ejecución del programa

contar_re:
   push r13                     ;salva el registro r13
   xor r13, r13                 ;contador global para el nuevo ciclo
   xor r9, r9                   ;contador para Palabra

;VERIFICA CUANTAS VECES SE REPITE LAS PALABRAS
contar_re1: 
   mov bl, 0ah                  ;mueve un salto de linea
   cmp [Buffer_abc + r13], bl   ;compara si hay un salto de linea
   jz verificar                 ;verifica si la palabra completa es la que se busca
   mov bl, [Buffer_abc + r13]   ;mueve la primera letra de las palabras ordenadas
   cmp [Palabra + r9], bl       ;compara cada letra con las de las palabras ordenadas
   jz contar2                   
   jnz contar3

sigue1:
   inc r13			;incrementa el contador del ciclo
   cmp r13, r14			;compara si se termina el ciclo
   jnz contar_re1
   
   ;IMPRIME LAS PALABRAS
   ;--------------------------------------
   mov rax, rsi
   push rax
   push rsi
   push rbx
   mov rbx, rax
   mov rax, 1           ;write
   mov rdi, 1           ;strout
   mov rsi, Palabra     ;Buffer
   mov rdx, rbx         ;Bufflen
   syscall
   pop rbx
   pop rsi
   pop rax
   ;---------------------------------------
   print canti,30   		;imprimie el texto de cantidad
   print_numero r12             ;imprime la cantidad de veces repetidas
   print _enter,_enter_len      ;imprime un salto de línea
   xor rax, rax                 ;inicializa el rax
   xor r12, r12                 ;inicializa el contador de repetidas
   pop r13 			;recupera el contador del primer ciclo
   jmp ok			

verificar:
   cmp r9, rax			;compara si la cantidad de la palabra es igual a la que se busca
   jnz contar3			
   inc r12 			;si es igual se incrementa la veces repetidas
   xor r9, r9			;inicializa el contador de Palabra
   jmp sigue1

contar2:
  inc r9			;si las letras son iguales pasa a la siguiente
  jmp sigue1
contar3:
  mov rsi, rax			;mueve el tamaño de la palabra al rsi
  xor r9,r9			;inicializa el contador de la palabra
  jmp colocar

;COLOCA LA PALBRA EN EL BUFFER ORDENADO A LA SIGUIENTE
colocar:
  mov bl, 0ah			;mueve un salto de linea
  cmp [Buffer_abc + r13], bl	;compara con un salto de linea
  jz sigue1
  inc r13			;coloca el contador al inicio de la siguiente palabra
  jmp colocar			












    
