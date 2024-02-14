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

# sección de texto
.text
main:
	jal solicitudFarey		# saltar a la subrutina solicitudFarey, para obtener n del usuario 
	
	jal farey			# saltar a la subrutina farey, para calcular la F_n
	
	jal printStr			# saltar a la subrutina printStr, para imprimir F_n
	
	j main				# volver a solicitar n para calcular F_n

solicitudFarey:
	jr $ra
farey:
	jr $ra
printStr:
	jr $ra
