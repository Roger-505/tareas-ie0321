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

#####################################################################################################################
#					EXPLICACION DE LA IMPLEMENTACION
#####################################################################################################################
# Se define que un string posee parentesis validos si todo parentesis que abre (, [, ó {, posee un parentesis que 
# cierra en el orden respectivo, o si el string no posee ningún paréntesis, que abra o cierre.
#
# Se implementaron tres funciones:
# parentesisValidos: Comprueba la validez de los paréntesis de un string. $a0 = DireccionString, $v0 = 0 si los parentesis
# son invalidos, $v0 = 1 si son validos.
#
# Esta función primero carga de la memoria string[i], y recorre el string hasta llegar al caracter "\0"- 
# - Si no se encuentran ningun parentesis, $v0 = 1. 
# - Si se encuentra un parentesis que cierra, sin haber encontrado un parentesis que abra, $v0 = 0
# - Si se encuentra un parentesis que abre, se apila el parentesis que cierra correspondiente, se le suma uno al contador
#   de parentesis que cierran apilados, stackCounter, y se sigue al siguiente caracter.
# - Si se encuentra un parentesis cierra, y hay elementos apilados (stackCounter != 0), primero se comprueba si string[i] = parentesisQueCierra.
# - Si se cumple la condición del punto anterior, se desapila el parentesis que cierra, stackCounter--, y se continua al siguiente caracter.
# - Si no se cumple la condición, se comprueba cual parentesis que cierra es el que está actualmente más arriba en la pila, y se obtienen los
#   parentesis Que no cierran (por ejemplo: si está apilado ")", los parentesis que no cierran son "]" y "}")
# - Se comparan los parentesis que no cierran con string[i] y "\0". Si alguno de ellos es equivalente a string[i], los parentesis no van a ser válidos y entonces $v0 = 0.
# - Si string[i] no es equivalente a los parentesis que cierran o a "\0", se sigue al siguiente caracter 
# 
# Note que el único caso en el que se devuelve $v0 = 1 es al terminar de analizar el string, lo cual permite detectar cadenas de parentesis válidos que son disjuntas en un mismo
# string.
# 
# stringParValido: Devuelve la direccion en memoria de "parentesis validos" si $a0 = 1, o la dirección en memoria de "parentesis invalidos" si $a0 = 0.
# Las direcciones se devuelven en $a0. Esta decisión se realiza por medio de un salto condicional. 
#
# printString: Recibe en $a0 la dirección de un string. Imprime el string en la terminal por medio de un syscall.
#
#####################################################################################################################

# sección de data
.data
parValido:	.asciiz "parentesis validos"
parInvalido:	.asciiz "parentesis invalidos"

arreglo:	.asciiz "((((((((((((((((((((((((((((((((((((((((((((((((((((((((("

# sección de texto
.text

#####################################################################################################################
# 						MAIN
#####################################################################################################################
main:
	la $a0, arreglo			# cargar en $a0 la direccion del string por analizar	
	jal parentesisValidos		# ejecutar parentesisValidos
	
	add $a0, $v0, $0		# $a0 = 1 si los parentesis son validos, por lo contrario, $a0 = 0
	jal stringParValido		
	
	add $a0, $v0, $0		# $a1 la dirección de parValido o de parInvalido
	jal printString		

	li $v0, 10			# cargar código (10) en $v0 para hacer exit
	syscall				# EXIT		
#####################################################################################################################
#		APILAR Y DEFINIR REGISTROS GUARDADOS PARA PARENTESIS QUE ABREN Y CIERRAN, Y DEFINIR CONTADORES
#####################################################################################################################
# función paréntesisVálidos
# recibe en $a0	la dirección de un string asciiz
# devuelve en $v0 = 1 si el string tiene paréntesis válidos. 
# $v0 = 0 si los paréntesis son inválidos
#
# se tienen en los registros desde el $s0 hasta el $s5 los
# delimitadores correspondientes guardados
# $s0 = "(" , $s1 = ")" , $s2 = "[" , $s3 = "]" , $s4 = "{" , $s5 = "}"
#####################################################################################################################
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
	
	add $a1, $0, $0 		# $a1 = stackCounter = 0. para saber cuantos parentesis que cierran están apilados hasta el momento
	add $t0, $0, $0			# $t0 = i = 0
#####################################################################################################################
#					LOOP PARA RECORRER STRING
#####################################################################################################################
parentesisLoop:
	add $t1, $a0, $t0		# $t1 = DireccionString + i
	lbu $t2, 0($t1)			# $t2 = string[i]	
	
	beq $t2, $s0, parentesis	# saltar si A[i] = "("
	beq $t2, $s2, corchetes		# saltar si A[i] = "["	
	beq $t2, $s4, llaves		# saltar si A[i] = "{"		
	
	# si hay algún paréntesis apilado, puede ser que A[i]
	# corresponda a un paréntesis que no le corresponda
	
	bne $a1, $0, verificarParentesis	#si stackCounter != 0, hay elementos apilados y hay que saltar para verificar la validez de los paréntesis
	 
	# verificar si se encontró algún paréntesis que cierra sin
	# haber encontrado primero un paréntesis que abre
	
	beq $t2, $s1, endInvalido	# saltar si A[i] = ")"
	beq $t2, $s3, endInvalido	# saltar si A[i] = "]"	
	beq $t2, $s5, endInvalido	# saltar si A[i] = "}"	
	
	# verificar si se llega al final del string sin haber determinado
	# que tiene paréntesis inválidos
	
	beq $t2, $0, endValido		# saltar si A[i] = "\0"
	
	# si no se tomó ninguno de los saltos anteriores, el caracter
	# no afecta si los paréntesis son válidos o no. se sigue al siguiente
	# caracter

siguienteCaracter:
	addi $t0, $t0, 1		# i++
	j parentesisLoop

#####################################################################################################################		
#					APILAR ACORDE CON EL PARENTESIS QUE ABRE
#####################################################################################################################
# se encontró un paréntesis que abre. se va a apilar
# el paréntesis que cierra correspondiente para seguir 
# la busqueda de otros paréntesis que abren en el resto
# del string
#####################################################################################################################
parentesis:
	addi $sp, $sp, -1		# ajustar stackpointer para apilar 1 byte
	sb $s1, 0($sp)			# apilar ")"
	addi $a1, $a1, 1		# stackCounter++
	j siguienteCaracter		
corchetes:
	addi $sp, $sp, -1		# ajustar stackpointer para apilar 1 byte
	sb $s3, 0($sp)			# apilar "]"
	addi $a1, $a1, 1		# stackCounter++
	j siguienteCaracter
llaves:
	addi $sp, $sp, -1		# ajustar stackpointer para apilar 1 byte
	sb $s5, 0($sp)			# apilar "}"
	addi $a1, $a1, 1		# stackCounter++
	j siguienteCaracter

#####################################################################################################################
#				COMPARAR PARENTESIS APILADOS CON EL string[i] ACTUAL
######################################################################################################################
# hay paréntesis apilados y se debe comprobar si los caracteres que siguen poseen parentesis que abren o cierran
# congruentes. si no son congruentes, los paréntesis van a ser inválidos. por ejemplo:
#
# está apilado ")" y string[i]="]". por tanto, los paréntesis son inválidos
# está apilado ")" y string[i]="(". por tanto, los paréntesis pueden ser válidos
# está apilado ")" y string[i]="\0". por tanto, los paréntesis son inválidos
#####################################################################################################################

verificarParentesis:
	# $t2 = string[i]
	
	# cargar de la pila el parentesis que cierra correspondiente
	
	lbu $t3, 0($sp)			# $t6 = parentesisQueCierra
	
	beq $t2, $t3, desapilarYcontinuar # si  A[i] = parentesisQueCierra, se procede a desapilar 
	
	# si string[i] != parentesisQueCierra, hay que comprobar si string[i] corresponde a un
	# parentesis que cierra que no le corresponde o "\0", ya que en estos casos los parentesis seran invalidos
	
	beq $t3, $s1, parentesisCierra	# saltar si parentesisQueCierra == ")"
	beq $t3, $s3, corcheteCierra	# saltar si parentesisQueCierra == "]"
	beq $t3, $s5, llaveCierra	# saltar si parentesisQueCierra == "}"
	
desapilarYcontinuar:
	addi $sp, $sp, 1		# reajustar el stack pointer debido al elemento que se va a desapilar
	addi $a1, $a1, -1		# stackCounter--
	j siguienteCaracter

parentesisCierra:
	beq $t2, $s3, endInvalidoSP	# saltar si A[i] = "]"	
	beq $t2, $s5, endInvalidoSP	# saltar si A[i] = "}"	
	beq $t2, $0,  endInvalidoSP	# saltar si A[i] = "\0"	
	j siguienteCaracter
	
corcheteCierra:

llaveCierra:
#####################################################################################################################
# 					FINALIZAR LOOP Y DEVOLVER VALIDEZ DE PARENTESIS
#####################################################################################################################
endValido:
	li $v0, 1			# cargar en $v0 = 1 si los paréntesis fueron válidos
	j endParentesis			# saltar para terminar la función
endInvalido:
	li $v0, 0			# cargar en $v0 = 0 si los paréntesis fueron inválidos
	j endParentesis			# saltar para terminar la función
	
endParentesis:
	# desapilar valores de los registros $s0 a $s6
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	add $sp, $sp, 24		# reajustar stack pointer
	
	jr $ra				# volver al punto de llamado	

# si se terminó abrubtamente el analisis de la palabra debido a que se identificó que sus parentesis eran invalidos,
# se debe reajustar el stack pointer debido a los posibles elementos apilados actualmente por parentesis que abren
# que han aparecido anteriormente
endInvalidoSP:
	# $a1 = stackCounter mantiene el registro de la cantidad de elementos apilados
	add $sp, $sp, $a1
	j endInvalido			# se salta con seguridad a endInvalido, habiendo corregido el stack pointer

#####################################################################################################################
# 						IMPRIMIR STRING
#####################################################################################################################
# función stringParValido
# recibe en $a0 = 1 si los paréntesis de un string son válidos. $a0 = 0 si los paréntesis de un string son inválidos
# devuelve en $v0 = parValido si $a0 = 1, $v0 = parInvalido si $a0 = 0
#####################################################################################################################
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
#####################################################################################################################