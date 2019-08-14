.data
List: .word 67,49,73,2,	

.text

Main:
la $a0, List
li $a1, 0
li $a2, 3				# Set initial high index to length of List - 1
jal QuickSort


j Exit

QuickSort:				# Takes 3 args: $a0: Array, $a1: Low index, $a2: High Index			

addi $sp, $sp, -12 			# Create space on the stack for 3 words
sw $ra, 4($sp) 				# save return address
sw $a1, 0($sp) 				# save arg 1
sw $a2, 8($sp)				# save arg 2

Blt $a1, $a2, IsSmaller			# Branches if the low index is bigger than the high

j EndOfSort				# Terminate current sort process

IsSmaller:

jal Partition				# Jump to partition process. Args are the same as current QuickSort args

add $t1, $v0, $zero			# Store temp variable to hold Partition return value

add $t2, $a2, $zero			# Store $a2 value in a temp to preserve through recursive call

addi $a2, $t1, -1			# Change the high index arg to value returned by partition - 1

jal QuickSort

add $a2, $t2, $zero			# Restore $a2 value after recursive call	
addi $a1, $t1, 1			# Change the High index arg to value returned by partition + 1

jal QuickSort

EndOfSort:
lw $ra 4($sp)				# Load previous return address
lw $a1, 0($sp)				# Load previous arg 1
lw $a2, 8($sp)				# Load previous arg 2
		
addi $sp, $sp, 12			# Remove current stack frame from the stack
jr $ra					# Jump to return address

Partition:				# Takes 3 args: $a0: Array, $a1: Low index, $a2: High Index

addi $sp, $sp, -8 			# Create space for two words
sw $ra, 4($sp) 				# save return address

mul $t2, $a2, 4				# Calculates offset of the High Index
add $t3, $a0, $t2 # $t3 High address	# Calculates the address of the Pivot
lw $t4, 0($t3)				# Loads the value thats stored in the address List[High Index] int $t4 Pivot

addi $t5, $a1, -1			# Get index of the smaller element i 
mul $t2, $t5, 4				# Calulates i offset
add $t7, $a0, $t2 # $t7 I address	# Calculates the address of the ith element

add $t0, $a1, $zero			# Initialize loop counter j

ForLoop:
bge $t0, $a2, ForLoopExit		# Loop condition: Branch if inex is greater than the high Index

mul $t2, $t0, 4				# Calulates loop counter offset
add $t6, $a0, $t2 # $t6 J address	# Calculates the address of the jth element
lw $t8, 0($t6)				# Loads value stored in the jth element

bgt $t8, $t4, EndLoopIf			# Branch if List[j] >= Pivot

addi $t5, $t5, 1			# increment i
addi $t7, $t7, 4			# increment i

lw $t9, 0($t7)				# temp = List[i]
sw $t8, 0($t7)				# List[i] = List[j]
sw $t9, 0($t6)				# List[j] = temp
EndLoopIf:

addi $t0, $t0, 1			# Increment i
j ForLoop

ForLoopExit:

lw $t9, 4($t7)				# temp = arr[i+1];
sw $t4, 4($t7)				# arr[i+1] = arr[high];
sw $t9, 0($t3)				# arr[high] = temp;

addi $v0, $t5, 1			# Load return value

EndOfPartition:
lw $ra 4($sp)				# Restore previous return address
addi $sp, $sp, 8			# Remove current stack frame from the stack
jr $ra					# Jump to return address

Exit: