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
#sección de data
.data
msgError:		.asciiz "Porfavor, digite únicamente números mayores que 0"
msgSolicitud_a: 	.asciiz "Ingrese el primer número para obtener el MCD: "
msgSolicitud_b:		.asciiz "Ingrese el segundo número para obtener el MCD: "
msgMCD:			.asciiz "El MCD entre los números ingresados es: "

# sección de texto
.text
# función principal
main:
	la $a0, msgSolicitud_a 	# inicializar $a0 = Dir[msgSolicitud_a]
	la $a1, msgSolicitud_b	# incializar $a1 = Dir[msgSolicitud_b]
	la $a2, msgError	# inicializar $a2 = Dir[msgError]
	jal solicitudInt	# saltar a la función solicitudInt para obtener a y b del usuario
	
	add $a0, $v0, 0 	# inicializar $a0 = a para la función mcd
	add $a1, $v1, 0		# inicializar $a1 = b para la función mcd
	jal mcd			# saltar a la función mcd para calcular mcd(a,b)

	add $a0, $v0, 0		# inicializar $a0 = mcd(a,b) para imprimir mcd(a,b) 
	la $a1, msgMCD    	# inicializar $a1 = Dir[msgMCD]
	jal print		# saltar a la función print para imprimir mcd(a,b)
	
	j main			# volver a solicitar a y b para calcular mcd(a,b)
	
solicitudInt:
	la $a0, msgSolicitud_a	# inicializar $a0 = Dir[msgSolicitud_a]
	addi $v0, $0, 4		# cargar código (4) para imprimir un string en la terminal
	syscall
	
	addi $v0, $0, 5		# cargar código (5) para leer un int de la terminal
	syscall
	add $t0, $0, $v0	# $t0 = a
mcd:

print:

# prueba, para verificar main y terminar el programa (no se va a terminar con un syscall en el programa final)
li $v0, 10
syscall 	 		# EXIT
