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
parValido	.asciiz "parentesis validos"
parInvalido	.asciiz "parentesis invalidos"

arreglo		.asciiz "yo voy a pasar estructuras (){}([{RRR}])"

# sección de texto
.text

#función principal
main:
	la $a0, arreglo			# cargar en $a0 la direccion del arreglo de caracteres por analizar 
	
	# jal parentesisValidos		# ejecutar parentesisValidos
	
	#addi $a0, $v0, $0		# $a0 = 1 si los parentesis son validos, por lo contrario, $a0 = 0
	
	#jal stringParValido		# obtener dirección del string que se imprimirá
	
	#addi $a0, $v0, $0		# $a0 la dirección de parValido o de parInvalidp
	
	#jal printAsciiArray		# imprimir string en la terminal
	
	#li $v0, 10			# cargar código (10) en $v0 para hacer exit
	
	#syscall			# EXIT		

parentesisValidos:
