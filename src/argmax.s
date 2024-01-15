.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    li t0 1
    blt a1 t0 invalid_size
    beq a1 t0 length_one
    li t2 0 # t2 = current index
    li t3 0 # t3 = current largest index
    lw t4 0(a0) # t4 = current largest integer
    addi a0 a0 4
    
loop_start:
    lw t0 0(a0) # t0 = current value at array[i]
    addi t2 t2 1
    blt t4 t0 set_new
    
loop_continue:
    li t0 1
    addi a1 a1 -1
    beq a1 t0 loop_end
    addi a0 a0 4
    j loop_start

loop_end:
    mv a0 t3
    jr ra
    
invalid_size:
    li a0 36
    j exit

set_new: # update largest index & integer
    mv t3 t2
    mv t4 t0
    j loop_continue
    
length_one:
    li a0 0
    jr ra


