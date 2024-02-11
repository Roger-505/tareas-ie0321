########################################
#		Tarea 3		       #
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
msgError:		.asciiz "Porfavor, digite únicamente números mayores que 0"
msgSolicitud_a: 	.asciiz "Ingrese el primer número para obtener el MCD: "
msgSolicitud_b:		.asciiz "Ingrese el segundo número para obtener el MCD: "
msgMCD:			.asciiz "El MCD entre los números ingresados es: "

# sección de texto
.text
############################################################################################################
#						MAIN
############################################################################################################	
main:
	jal solicitudMCD	# saltar a la función solicitudMCD para obtener a y b del usuario
	
	add $a0, $v0, 0 	# inicializar $a0 = a para la función mcd
	add $a1, $v1, 0		# inicializar $a1 = b para la función mcd
	jal mcd			# saltar a la función mcd para calcular mcd(a,b)

	add $a0, $v0, 0		# inicializar $a0 = mcd(a,b) para imprimir mcd(a,b) 
	la $a1, msgMCD    	# inicializar $a1 = Dir[msgMCD]
	jal printStr		# saltar a la función printStr para imprimir mensaje para desplegar mcd(a,b)
	jal printInt 		# saltar a la función para imprimir mcd(a,b)
	
	j main			# volver a solicitar a y b para calcular mcd(a,b)

############################################################################################################
#			SOLICITUD DE INTS DEL USUARIO, E IMPRESIÓN DE STRINGS E INTS  
############################################################################################################	
solicitudMCD:
	addi $sp, $sp, -4	# ajustar stack pointer para apilar un word
	sw $ra, 0($sp)		# apilar $ra, ya que se utilizará la función jal en solicitudMCD
	
	la $a0, msgSolicitud_a 	# inicializar $a0 = Dir[msgSolicitud_a]
	jal printStr		# saltar a la función printStr para imprimir msgSolicitud_a
	jal readInt		# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = a
	
	la $a1, msgSolicitud_b	# incializar $a1 = Dir[msgSolicitud_b]
	jal printStr		# saltar a la función printStr para imprimir msgSolicitud_b
	jal readInt		# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = b
	
	lw $ra, 0($sp)		# recuperar valor de $ra apilado
	addi $sp, $sp, 4	# ajustar stack pointer a su valor previo al llamado de la función
	jr $ra			# volver al punto de llamado
solicitudInt:

printStr:

printInt:

readInt:

mcd:



# prueba, para verificar main y terminar el programa (no se va a terminar con un syscall en el programa final)
li $v0, 10
syscall 	 		# EXIT
