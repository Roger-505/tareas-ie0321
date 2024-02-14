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
	addi $sp, $sp, -4		# ajustar stack pointer para apilar un elemento
	sw $ra, 0($sp)			# apilar $ra, ya que se utilizará jal en la subrutina farey
	
	jal fareyFraccion		# saltar a la subrutina fareyFraccion para formar la serie de fracciones inicial en la pila
	
	jal fareyMayorAuno		# saltar a la subrutina fareyMayorAuno para eliminar los elementos mayores a 1 de la serie
	
	jal fareySimplificar		# saltar a la subrutina fareySimplificar para simplificar las fracciones de la serie
	
	jal fareyRepetidos		# saltar a la subrutina fareyRepetidos para eliminar los elementos repetidos de la serie
	
	jal fareySort			# saltar a la subrutina fareySort para ordenar los elementos de la serie en orden ascendente
	
	jal fareyExtremos		# saltar a la subrutina fareyExtremos para agregar el término 0/1 al inicio de la serie, y 1/0 al final
	
	
	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# reajustar el valor del stack pointer
	jr $ra				# volver al punto de llamado

fareyFraccion:
	jr $ra

fareyMayorAuno:
	jr $ra

fareySimplificar:
	jr $ra
	
fareyRepetidos:
	jr $ra
	
fareySort:
	jr $ra

fareyExtremos:
	jr $ra 