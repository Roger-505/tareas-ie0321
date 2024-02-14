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

#########################################################################################################################
#					EXPLICACIÓN DE LA IMPLEMENTACIÓN						#		   		   
#########################################################################################################################
#
# Se implementó 1 subrutina para resolver el problema indicado en el enunciado de la tarea:
# 
# 	      farey: Calcula la sucesión de farey F_n (de orden n) por medio de los pasos 
#		     indicados en el enunciado de la tarea.
#		     	- Argumentos: $a0 = n 
#			- Returns: $v0 = F_n (string con la sucesión)
#
# A continuación, se muestra un ejemplo del funcionamiento de la subrutina anterior. Si $a0 = 5, farey devolvería:
#
#	$v0 = "{0/1, 1/5, 1/4, 1/3, 2/5, 1/2, 3/5, 2/3, 3/4, 4/5, 1/0}"
# 
# Se reutilizaron 3 subrutinas diseñadas en la tarea #3 del curso:
#
#          printStr: Imprime en la terminal un string por medio de un syscall.						
#			- Argumentos: $a0 = Dir[string]										
#		        - Returns: Impresión de string en la terminal								
#															
# 	    readInt: Lee de la terminal un int por medio de un syscall.							
#			- Argumetnos: No posee argumentos de entrada.								
#			- Returns: $v0 = integer		
#	
# 	        mcd: Calcula el máximo común divisor de dos números enteros mayores a cero,  por medio 
#		     del algoritmo de Euclides tradicional, implementado de manera recurrente.						
#			- Argumentos: $a0 = a (primer número), $a1 = b (segundo número)						
#			- Returns: $v0 = mcd(a,b) (el máximo común divisor de a y b)	
#	

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

	lw $ra, 0($sp)			# recuperar valor de $ra apilado
	addi $sp, $sp, 4		# reajustar el valor del stack pointer
	jr $ra				# volver al punto de llamado

