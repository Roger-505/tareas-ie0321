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

# seccion de data
.data
msgFarey:	.asciiz "Ingrese un número natural para entregar la sucesión de Farey:\n"
Fn:		.asciiz "SUCESION FAREY POR IMPLEMENTAR\n"

# sección de texto
.text
main:
	la $a0, msgFarey 		# inicializar $a0 = Dir[msgFarey]
	jal printStr			# saltar a la función printStr para imprimir msgFarey
	jal readInt			# saltar a la función readInt para leer un int de la terminal, y devolver $v0 = n
	
	add $a0, $v0, $0		# cargar en $a0 = n digitado por el usuario
	jal farey			# saltar a la subrutina farey, para calcular la F_n
	
	la $a0, Fn			# carga en $a0 = F_n
	jal printStr			# saltar a la subrutina printStr, para imprimir F_n
	
	j main				# volver a solicitar n para calcular F_n
	
printStr:
	addi $v0, $0, 4			# cargar código (4) en $v0 para imprimir string en $a0 = Dir[string]
	syscall				# syscall para imprimir string
	jr $ra				# volver al punto de llamado
readInt:
	addi $v0, $0, 5			# cargar código (5) en $v0 para leer un int de la terminal y guardar en $v0 = integer
	syscall				# syscall para leer un int
	jr $ra				# volver al punto de llamado
	
farey:
	jr $ra

