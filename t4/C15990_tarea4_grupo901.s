########################################
#		Tarea 4		       #
#	Estructuras de Computadores    #
#		Digitales I	       #
#	      Ciclo III 2023	       #
#		Grupo 901	       #
#	Roger Daniel Piovet García     #
#		C15990		       #
########################################

# El siguiente repositorio de GitHub posee el código de esta 
# tarea, al igual que el resto de las tareas del curso:
#
# https://github.com/Roger-505/tareas-ie0321.git

#################################################################################################################################
#						EXPLICACIÓN DE LA IMPLEMENTACIÓN						#		   		   
#################################################################################################################################
#																#
# Se implementaron 2 subrutinas para resolver el problema indicado en el enunciado de la tarea:					#
# 																#
# 	      farey: Calcula la sucesión de farey F_n (de orden n) recursivamente.						#
#		     	- Argumentos: $a0 = n 											#
#			- Returns: Impresión de F_n en la terminal								#
#																#
# A continuación, se muestra un ejemplo del funcionamiento de la subrutina anterior. Si $a0 = 5, farey imprimiría:		#
#																#
#	"{0/1, 1/5, 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 1/0}"								#
# 																#
# La demostración matemática asociada a este algoritmo recursivo para calcular Fn se explica a fondo en el siguiente 		#
# artículo: https://en.wikipedia.org/wiki/Farey_sequence#Next_term. 								#
#																#
# Dadas dos elementos de la secuencia Fn, a/b y c/d, es posible calcular el próximo elemento de la sucesión, p/q, por medio	#
# de las siguiente ecuaciones:													#
#																#
#	p = floor( (n + b)/d ) * c - a												#
#	q = floor( (n + b)/d ) * d - b												#
#																#
# Y para calcular el elemento siguiente a p/q, se debe realizar la reasignación de variables, tal que:				#
#																#
#	a/b <- c/d														#
# 	c/d <- p/q														#
#																#
# La condición de parada es p > n. En dicho caso, se para de generar elementos de la sucesión, y se coloca el 			#
# elemmento 1/0 al final de la sucesión.											#
#																#
# Ya que se necesitan dos elementos de Fn para calcular el próximo elemento, se inicia la generación de los elementos		#
# de Fn con los valores iniciales a/b = 0/1, y c/d = 1/n. 									#
#																#
# El valor inicial de c/d es el indicado debido a que la sucesión de Farey de orden n es una secuencia 				#
# de fracciones reducidas, y de estos elementos, el segundo menor elemento será 1/n, seguido por 0/1. Por tanto, todas 		#
# las secuencias de Farey de orden n tendrán como primeros dos elementos 0/1, seguido por 1/n. 					#
#																#
# Note que este algoritmo genera cada elemento de la sucesión en su forma ya reducida. Por tanto, no es necesario		#
# hacer uso de la función mcd implementada en la tarea 3 del curso para reducir las fracciones de la sucesión 			#
#																#
# La otra subrutina diseñada para obtener Fn es fareyPrint:									#
#																#
# 	 fareyPrint: Imprime en la terminal cada elemento de la secuencia de Farey, 						#
#		     separados por el string ", " además del numerador y el denominador						#
#		     separados por el string "/"										#
#		     - Argumentos: $a0 = numerador, $a1 = denominador								#
#		     - Returns: Impresión en la terminal de "numerador/denominador						#
#																#
# Se reutilizaron 3 subrutinas diseñadas en la tarea #3 del curso:								#
#																#
#          printStr: Imprime en la terminal un string por medio de un syscall.							#
#			- Argumentos: $a0 = Dir[string]										#
#		        - Returns: Impresión de string en la terminal								#
#																#
# 	    readInt: Lee de la terminal un int por medio de un syscall.								#
#			- Argumetnos: No posee argumentos de entrada.								#
#			- Returns: $v0 = integer										#
#																#
#    	   printInt: Imprime en la terminal un int por medio de un syscall							#
#			- Argumentos: $a0 = integer										#
#			- Returns: Impresión de integer en la terminal								#
#																#
#################################################################################################################################

# seccion de data
.data
msgFarey:	.asciiz "Ingrese un número natural para entregar la sucesión de Farey:\n"
Slash:		.asciiz "/"
spaceAndComma:	.asciiz ", "
openBracket:	.asciiz "{"
closeBracket:	.asciiz "}\n"

# sección de texto
.text

#################################################################################################################################
#							MAIN									#
#################################################################################################################################
main:
	la $a0, msgFarey 		# inicializar $a0 = Dir[msgFarey]
	jal printStr			# saltar a la función printStr para imprimir msgFarey
	jal readInt			# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = n
	
	add $a0, $v0, $0		# cargar en $a0 = n digitado por el usuario
	jal farey			# saltar a la subrutina farey, para calcular la F_n
	
	j main				# volver a solicitar n para calcular F_n

#################################################################################################################################
#					IMPRESIÓN DE STRINGS, Y, LECTURA E IMPRESIÓN DE INTS					#
#################################################################################################################################
printStr:
	addi $v0, $0, 4			# cargar código (4) en $v0 para imprimir string en $a0 = Dir[string]
	syscall				# syscall para imprimir string
	jr $ra				# volver al punto de llamado
readInt:
	addi $v0, $0, 5			# cargar código (5) en $v0 para leer un int de la terminal y guardar en $v0 = integer
	syscall				# syscall para leer un int
	jr $ra				# volver al punto de llamado
printInt:
	addi $v0, $0, 1			# cargar código (1) en $v0 para imprimir un int en $a0 = integer
	syscall				# syscall para imprimir int
	jr $ra 				# volver al punto de llamado

#################################################################################################################################
#						OBTENCIÓN DE LA SECUENCIA DE FAREY						#
#################################################################################################################################
farey:
	addi $sp, $sp, -4		# ajustar stack pointer para apilar un elemento
	sw $ra, 0($sp)			# apilar $ra, ya que se utilizará jal en la subrutina farey
	add $t4, $a0, $0		# n = $t4
	
	add $t0, $0, $0			# a = $t0 = 0 (numerador)
	addi $t1, $0, 1			# b = $t1 = 1 (denominador)
	addi $t2, $0, 1			# c = $t2 = 1 (numerador)
	add $t3, $0, $a0		# d = $t3 = n (denominador)
	
	# impresión de "{"
	la $a0, openBracket		# cargar en $a0 = Dir["{"]
	jal printStr			# imprimir "{"	la $a0, basckSlash	
	
	# impresión de "0/1, "
	add $a0, $t0, $0		# $a0 = 0
	add $a1, $t1, $0		# $a1 = 1
	jal fareyPrint			# saltar a fareyPrint para imprimir "0/1, "
	
	# impresión de "1/n, "
	add $a0, $t2, $0		# $a0 = 1
	add $a1, $t3, $0		# $a1 = n
	jal fareyPrint			# saltar a fareyPrint para imprimir "1/n, "
	
	fareyLoop:
	add $t6, $t4, $t1		# $t6 = n + b
	div $t6, $t3			# calcular floor( (n+b)/d ). Es decir, la división entera
	mflo $t6			# $t6 = floor( (n+b)/d )
	
	# cálculo de p = $t7
	mult $t6, $t2			# calcular floor( (n+b)/d ) * c
	mflo $t7			# $t7 = floor( (n+b)/d ) * c
	sub $t7, $t7, $t0		# p = floor( (n+b)/d ) * c - a
	
	# cálculo de q = $t8
	mult $t6, $t3			# calcular floor( (n+b)/d ) * d
	mflo $t8			# $t8 = floor( (n+b)/d ) * d
	sub $t8, $t8, $t1		# q = floor( (n+b)/d ) * d - b
	
	slt $t5, $t7, $t4		# si c < n, $t5 = 1
	beq $t5, $0, endFarey		# si c >= n, terminar de calcular elementos de la sucesión
	
	add $a0, $t7, $0		# $a0 = p
	add $a1, $t8, $0		# $a1 = q
	jal fareyPrint			# saltar a fareyPrint para imprimir "p/q, "
	
	# reasignación de variables
	add $t0, $0, $t2		# a <- c
	add $t1, $0, $t3		# b <- d
	add $t2, $0, $t7		# c <- p
	add $t3, $0, $t8		# d <- q
	
	j fareyLoop			# saltar para calcular el próximo elemento de la sucesión

#################################################################################################################################
#					IMPRESIÓN DE LOS ELEMENTOS DE LA SECUENCIA DE FAREY					#
#################################################################################################################################
fareyPrint:	
	addi $sp, $sp, -4		# ajustar stack pointer para apilar un elemento
	sw $ra, 0($sp)			# apilar $ra, ya que se utilizará jal en la subrutina fareyPrint
	
	jal printInt			# imprimir $a0 = num
	la $a0, Slash			# cargar en $a0 = Dir["/"]
	jal printStr			# imprimir "/"
	add $a0, $0, $a1		# cargar en $a0 = den
	jal printInt			# imprimir $a0 = den
	la $a0, spaceAndComma		# cargar en $a0 = Dir[", "]
	jal printStr			# imprimir ", "
	
	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# reajustar el valor del stack pointer
	jr $ra				# volver al punto de llamado

#################################################################################################################################
#				FINALIZAR LA IMPRESIÓN DE ELEMENTOS DE LA SECUENCIA DE FAREY					#
#################################################################################################################################
endFarey:
	# impresión de "1/0"
	addi $a0, $0, 1			# $a0 = 1
	jal printInt			# imprimir $a0 = 1
	la $a0, Slash			# cargar en $a0 = Dir["/"]
	jal printStr			# imprimir "/"
	addi $a0, $0, 0			# cargar en $a0 = 0
	jal printInt			# imprimir $a0 = 0
	
	# impresión de "}"
	la $a0, closeBracket		# cargar en $a0 = Dir["{"]
	jal printStr			# imprimir "{"		
	
	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# reajustar el valor del stack pointer
	jr $ra				# volver al punto de llamado

#################################################################################################################################