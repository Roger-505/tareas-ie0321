#####################################################################
#				Tarea 1				    #
#		Estructuras de Computadores Digitales I, IE0321     #
#		Estudiante: Roger Daniel Piovet García		    #
#		Carné: C15990					    #
#		Ciclo: III, 2023				    #
#####################################################################

.data
Array: .word 87, 216, -54, 751, 1, 36, 1225, -446,
-6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1,
544, 6, 7899, 74, -42, -9, 0
separator:  .asciiz ","
newLine:    .asciiz "\n"
startArray: .asciiz "Array en este momento:\n"
MinMax:     .asciiz "Valores mínimos y máximos del array(respectivamente):\n"

.text
#función principal
main:
	jal printArrayAndGetSize
	add $s0, $v0, $0	#$s0=len(A)
	
	la $a0, Array 	        #Cargar en $a0 la dirección del elemento A[0] del array
	jal sortAndMinMax	#sort del array y obtener elementos mínimo y máximo
	
	add $a1, $v0, $0	#$a1=min(Array)
	add $a2, $v1, $0	#$a2=max(Array)
	
	jal printMinMax		#imprimir el valor mínimo y máximo del array
	
	jal printArrayAndGetSize #imprimir el array original, que no ha sido modificado
	
	li $v0, 10              #Código de salida (10) en $v0
	syscall                 #Exit

#print del Array y obtener el tamaño del array, returns: $v0=len(A)
printArrayAndGetSize:
	#Impresión de mensaje en startArray
	
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, startArray        #Cargar en $a0 la dirección del string "Array original:\n" 
	syscall		          #Imprimir "Array original:\n"
	add $t0, $0, $0          #$t0=i=0
	la  $t1, Array		 #Cargar en $t1 la dirección del elemento A[0] del array
	add $t3, $0, $0          #$t3=i para obtener el tamaño del array
loopPrint:
	#Impresión de cada caracter del string
	
	sll $t2, $t0, 2          #$t2=i*4
	addu $t2, $t2, $t1       #$t2=A+i*4
	addi $v0, $0, 1          #Imprimir entero código (1) en $v0
	lw $a0, 0($t2) 	         #Cargar en $a0=A[i] el entero por imprimir
	syscall			 #Imprimir entero $a0=A=[i]
	beq $a0, $0, printEnd    #Branch si se llega al último elemento del array
	addi $t0, $t0, 1         #i++
	
	#Impresión de coma
	
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, separator        #Cargar en $a0 la dirección del string ","
	syscall		         #Imprimir string ","
	addi $t3, $t3, 1	 #i++
	j loopPrint		         #Saltar a la etiqueta loopP
printEnd:
	#Imprsesión de nueva línea 
	
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, newLine          #Cargar en $a0 la dirección del string "\n" 
	syscall		         #Imprimir "\n"
	add $v0, $t3, $0	 #devolver en $v0 len(A)+1 
	jr $ra		         #Volver al punto de llamado en main:

#sort del array y obtener min(Array) y max(Array) , con $s0=len(A)+1, y $a0=Mem[Array]
sortAndMinMax:
	addi $sp, $sp, -4	 #preparar stack pointer para apilar $ra
	sw   $ra, 0($sp)	 #apilar $ra para retornar a main: al finalizar de esta función
	
	# apilar una copia del array en la pila para hacer bubbleSort
	add $t1, $0, $0		  #$t1=i=0
	apilarArray:
	addi $sp, $sp, -4	  #crear un espacio para un elemento 0 en la pila para realizar bubbleSort
	sw $0, 0($sp)		  #este cero va servir para detectar cuando termina el array
	apilar:
	sll $t2, $t1, 2		  #$t2=4*i	 
	add $t2, $t2, $a0	  #$t2=A+4*i
	lw  $t3, 0($t2)	    	  #$t3=A[i]
	beq $t3, $0, bubbleSortInit	#si se llega al final del array, iniciar el bubbleSort
	addi $sp, $sp, -4	  #ajustar $sp para apilar elemento del array en el stack
	sw $t3, 0($sp)
	addi $t1, $t1, 1	  #i++
	j apilar
	
	# bubbleSort y obtener valores máximos y mínimos del array
	bubbleSortInit: 	  
	add $a0, $0, $0 	  #$a0=i=0 para recorrer el array en bubbleSort
	add $a2, $0, $0 	  #$a2=j=0 para saber si se realizó swap en una iteración 
	
	jal bubbleSortLoop

	lw $ra, 0($sp)		 #desapilar $ra para volver a main:
	addi $sp, $sp, 4	 #restaurar valor del stack pointer
	jr $ra			 #volver al punto de llamado en main:
	 

#ordenar el array, apilandolo en memoria, argumentos: $a0=i=0 $sp=Mem[ArrayCopia] $a2=j=0 $s0=len(A)	
bubbleSortLoop:
	#cargar en $t2=A[i] y $t3=A[i+1]
	sll $t0, $a0, 2     		#$t0=4*i
	add $t1, $t0, $sp   		#$t1=A+4*i para acceder a los elementos de la copia del array en el stack
	lw  $t2, 0($t1)	    		#$t2=A[i]
	lw  $t3, 4($t1)     		#$t3=A[i+1]
	
	#verificar si hay que terminar el sort, o hacer swap
	beq $t3, $0, bubbleSortEndLoop	#si A[i+1]==0, finalizar loop
	addi $a0, $a0, 1		#i++
	slt $t4, $t3, $t2 		#$t4=1 si A[i+1]<A[i]
	beq $t4, $0, bubbleSortLoop	#si $t4=0, no hay que hacer swap
	
	#hacer swap por medio de $sp
	sw $t3, 0($t1)			#A[i+1]=A[i]
	sw $t2, 4($t1)			#A[i]=A[i+1]		 
	addi $a2, $0, 1			#j=1, se hizo swap
	j bubbleSortLoop

#returns $v0=min(Array) $v1=max(Array)
bubbleSortEndLoop:
	bne $a2, $0, bubbleSortInit	#verificar si se hicieron swaps
	lw $v0, 0($sp)			#devolver el valor mínimo del array en $v0 
	lw $v1, 0($t1)			#devolver el valor máximo del array en $v1 
					#(última memoria calculada en $t1 al finalizar de ordenar el array corresponde al max)		
	sll $t0, $s0, 2			#$t0=4*len(A)
	addi $sp, $sp, 4		#$t0=4*len(A)+4
	add $sp, $sp, $t0		#reajustar stack pointer. se le debe sumar len(A)+4 debido al tamaño del array, y el
					#elemento 0 que se agregó en la pila
					
	jr $ra				#volver al punto de llamada de bubbleSortLoop:
	
#print del valor máximo y mínimo del array, argumentos $a1=min(Array) $a2=max(Array)	
printMinMax:
	#Impresión de mensaje en MinMax
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, MinMax       	  #Cargar en $a0 la dirección del string "Valores maximos y minimos del array:\n" 
	syscall		          #Imprimir "Valores maximos y minimos del array:\n" 
	
	#Impresión de min(Array)
	addi $v0, $0, 1          #Imprimir entero código (1) en $v0
	add $a0, $a1, $0	 #Cargar en $a0 min(Array)
	syscall			 #Imprimir entero $a0=A=[i]
	beq $a0, $0, printEnd    #Branch si se llega al último elemento del array
	
	#Impresión de nueva línea
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, newLine           #Cargar en $a0 la dirección del string "\n" 
	syscall		
	
	#Impresión de max(Array)
	addi $v0, $0, 1          #Imprimir entero código (1) en $v0
	add $a0, $a2, $0	 #Cargar en $a0 max(Array)
	syscall			
	
	#Imprsesión de nueva línea 
	addi $v0, $0, 4           #Imprimir string código (4) en $v0
	la $a0, newLine          #Cargar en $a0 la dirección del string "\n" 
	syscall		         #Imprimir "\n"
	
	jr $ra		   	 #volver al main:
