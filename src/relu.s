.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:    
    li t0 1
    blt a1 t0 invalid_size
    # Prologue


loop_start:
    lw t0 0(a0) # t0 - current value at index i
    blt t0 x0 set_zero
    addi a0 a0 4
    addi a1 a1 -1

loop_continue:
    beq a1 x0 loop_end
    j loop_start

set_zero:
    sw x0 0(a0)
    addi a0 a0 4
    addi a1 a1 -1
    j loop_continue
    # Epilogue

invalid_size:
    li a0 36
    j exit

loop_end:
    jr ra
