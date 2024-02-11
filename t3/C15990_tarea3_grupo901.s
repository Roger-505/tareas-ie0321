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
msgError:		.asciiz "Porfavor, digite únicamente números mayores que 0\n"
msgSolicitud_a: 	.asciiz "Ingrese el primer número para obtener el MCD: "
msgSolicitud_b:		.asciiz "Ingrese el segundo número para obtener el MCD: "
msgMCD:			.asciiz "El MCD entre los números ingresados es: "
saltoDeLinea:		.asciiz "\n"
# sección de texto
.text
############################################################################################################
#						MAIN
############################################################################################################	
main:
	jal solicitudMCD		# saltar a la función solicitudMCD para obtener a y b del usuario
	
	add $a0, $v0, 0 		# inicializar $a0 = a para la función mcd
	add $a1, $v1, 0			# inicializar $a1 = b para la función mcd
	jal mcd				# saltar a la función mcd para calcular mcd(a,b)

	add $a0, $v0, 0			# inicializar $a0 = mcd(a,b) para imprimir mcd(a,b) 
	la $a1, msgMCD    		# inicializar $a1 = Dir[msgMCD]
	jal printStr			# saltar a la función printStr para imprimir mensaje para desplegar mcd(a,b)
	jal printInt 			# saltar a la función para imprimir mcd(a,b)
	
	j main				# volver a solicitar a y b para calcular mcd(a,b)

############################################################################################################
#			SOLICITUD DE INTS DEL USUARIO, E IMPRESIÓN DE STRINGS E INTS  
############################################################################################################	
solicitudMCD:
	addi $sp, $sp, -4		# ajustar stack pointer para apilar un word
	sw $ra, 0($sp)			# apilar $ra, ya que se utilizará la función jal en solicitudMCD

	addi $t2, $0, 1			# $t2 = 1
	
	solicitudLoop_a:
	la $a0, msgSolicitud_a 		# inicializar $a0 = Dir[msgSolicitud_a]
	jal printStr			# saltar a la función printStr para imprimir msgSolicitud_a
	jal readInt			# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = a
	add $t0, $v0, $0		# cargar en $t0 = $v0 = a, después de haber sido leido de la terminal
	
	la $a3, solicitudLoop_a		# cargar en $a3 = solicitudLoop_a, para saltar a esa etiqueta en caso en que el usuario digite un número menor que 0.
	slt $t3, $t0, $t2 		# $t3 = 1 si a < 1
	beq $t3, $t2, errorSolicitud	# si a < 1, saltar a errorSolicitud para desplegar un mensaje de error

	solicitudLoop_b:
	la $a0, msgSolicitud_b		# incializar $a1 = Dir[msgSolicitud_b]
	jal printStr			# saltar a la función printStr para imprimir msgSolicitud_b
	jal readInt			# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = b
	add $t1, $v0, $0		# cargar en $t1 = $v0 = b, después de haber sido leido de la terminal
	
	la $a3, solicitudLoop_b		# cargar en $a3 = solicitudLoop_b, para saltar a esa etiqueta en caso en que el usuario digite un número menor que 0.
	slt $t3, $t1, $t2 		# $t3 = 1 si b < 1
	beq $t3, $t2, errorSolicitud	# si b < 1, saltar a errorSolicitud para desplegar un mensaje de error
	
	add $v0, $t0, $0		# cargar en $v0 = $t0 = a para ser devuelto por la función
	add $v1, $t1, $0		# cargar en $v1 = $t1 = b para ser devuelto por la función
	
	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# ajustar stack pointer a su valor previo al llamado de la función
	jr $ra				# volver al punto de llamado
printStr:
	addi $v0, $0, 4			# cargar código (4) en $v0 para imprimir string en $a0 = Dir[string]
	syscall				# syscall para imprimir string
	jr $ra
readInt:
	addi $v0, $0, 5			# cargar código (5) en $v0 para leer un int de la terminal y guardar en $v0 = integer
	syscall
	jr $ra				# syscall para leer int 
errorSolicitud:
	addi $sp, $sp, -4		# ajustar stack pointer para apilar un word
	sw $ra, 0($sp)			# apilar $ra, ya que se utilizará la función jal en solicitudMCD
	
	la $a0, msgError		# inicializar $a0 = Dir[msgError]
	jal printStr			# saltar a la función printStr para imprimir msgError
	
	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# ajustar stack pointer a su valor previo al llamado de la función
	jr $a3				# saltar a la instrucción en la dirección $a3, para volver a solicitar al usuario a, o b

printInt:
	
mcd:

# prueba, para verificar main y terminar el programa (no se va a terminar con un syscall en el programa final)
li $v0, 10
syscall 	 		# EXIT
