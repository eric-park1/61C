.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0 1
    blt a2 t0 invalid_size
    blt a3 t0 invalid_stride
    blt a4 t0 invalid_stride
    slli t2 a3 2
    slli t3 a4 2
    li t4 0


loop_start:
    lw t5 0(a0)
    lw t6 0(a1)
    mul t0 t5 t6
    add t4 t4 t0
    add a0 a0 t2
    add a1 a1 t3
    

loop_continue:
    li t0 1
    beq a2 t0 loop_end
    addi a2 a2 -1
    j loop_start
    
loop_end:
    mv a0 t4
    jr ra
    
invalid_size:
    li a0 36
    j exit

invalid_stride:
    li a0 37
    j exit
