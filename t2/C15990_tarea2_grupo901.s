########################################
#		Tarea 2		       #
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

# sección de data
.data
parValido:	.asciiz "parentesis validos"
parInvalido:	.asciiz "parentesis invalidos"

arreglo:	.asciiz "yo voy a pasar estructuras"

# sección de texto
.text

# programa principal
main:
	la $a0, arreglo			# cargar en $a0 la direccion del string por analizar	
	jal parentesisValidos		# ejecutar parentesisValidos
	
	add $a0, $v0, $0		# $a0 = 1 si los parentesis son validos, por lo contrario, $a0 = 0
	jal stringParValido		
	
	add $a0, $v0, $0		# $a1 la dirección de parValido o de parInvalido
	jal printString		

	li $v0, 10			# cargar código (10) en $v0 para hacer exit
	syscall				# EXIT		

# función paréntesisVálidos
# recibe en $a0	la dirección de un string asciiz
# devuelve en $v0 = 1 si el string tiene paréntesis válidos. 
# $v0 = 0 si los paréntesis son inválidos
#
# se tienen en los registros desde el $s0 hasta el $s5 los
# delimitadores correspondientes guardados
# $s0 = "(" , $s1 = ")" , $s2 = "[" , $s3 = "]" , $s4 = "{" , $s5 = "}"
parentesisValidos:
	# apilar valores previos de los registros $s0 hasta el $s5
	add $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	# cargar el valor en ascii 
	# para cada registro
	li $s0, 40			# 40  = "("	
	li $s1, 41			# 41  = ")"
	li $s2, 91			# 91  = "["	
	li $s3, 93			# 93  = "]"
	li $s4, 123			# 123 = "{"	
	li $s5, 125			# 125 = "}"
	
	add $t0, $0, $0			# $t0 = i = 0
parentesisLoop:
	add $t1, $a0, $t0		# $t1 = DireccionString + i
	lbu $t2, 0($t1)			# $t2 = string[i]	
	
	beq $t2, $s0, parentesis	# saltar si A[i] = "("
	beq $t2, $s2, corchetes		# saltar si A[i] = "["	
	beq $t2, $s4, llaves		# saltar si A[i] = "{"		
	
	# hay que hacer la verificacion si se tienen elementos del string en el stack
	
	sub $t3, $t2, $s1		# $t3 = 0 si A[i] = ")"
	sub $t4, $t2, $s3		# $t4 = 0 si A[i] = "]"
	sub $t5, $t2, $s5		# $t5 = 0 si A[i] = "}"
	
	# verificar si se encontró algún paréntesis que cierra sin
	# haber encontrado primero un paréntesis que abre
	
	beq $t3, $0, endInvalido	# saltar si A[i] = ")"
	beq $t4, $0, endInvalido	# saltar si A[i] = "]"	
	beq $t5, $0, endInvalido	# saltar si A[i] = "}"	
	
	# verificar si se llega al final del string sin haber determinado
	# que tiene paréntesis inválidos
	
	beq $t2, $0, endValido		# saltar si A[i] = "\0"
	
	# si no se tomó ninguno de los saltos anteriores, el caracter
	# no afecta si los paréntesis son válidos o no. se sigue al siguiente
	# caracter
	
	addi $t0, $t0, 1		# i++
	j parentesisLoop		
	 
corchetes:

parentesis:

llaves:

endValido:
	li $v0, 1			# cargar en $v0 = 1 si los paréntesis fueron válidos
	j endParentesis			# saltar para terminar la función
endInvalido:
	li $v0, 0			# cargar en $v0 = 0 si los paréntesis fueron inválidos
	j endParentesis			# saltar para terminar la función
	
endParentesis:
	# desapilar valores de los registros $s0 a $s5
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	add $sp, $sp, 24		# reajustar stack pointer
	
	jr $ra				# volver al punto de llamado

# función stringParValido
# recibe en $a0 = 1 si los paréntesis de un string son válidos. $a0 = 0 si los paréntesis de un string son inválidos
# devuelve en $v0 = parValido si $a0 = 1, $v0 = parInvalido si $a0 = 0
stringParValido:
	beq $a0, $0, endstringParValido	# si $a0 = 0, el string es invalido y se realiza el branch
	la $v0, parValido		# $a0 = 1, entonces se carga en $v0 parValido
	jr $ra				# volver al punto de llamado
endstringParValido:
	la $v0, parInvalido		# $a0 = 0, entonces se carga en $v0 parInvalido
	jr $ra				# volver al punto de llamado

# función printString
# recibe en $a0 la dirección en memoria de un string asciiz
# imprime en la terminal dicho string
printString:
	li $v0, 4			# cargar código (4) en $v0 para imprimir un string en la terminal
	syscall
	jr $ra				# volver al punto de llamado
