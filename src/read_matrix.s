.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)             
    sw s1, 4(sp)               
    sw s2, 8(sp)             
    sw s3, 12(sp)          
    sw s4, 16(sp)  
    sw s5, 20(sp)             
    sw ra, 24(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2

    mv a0 s0            
    li a1 0
    jal fopen
    li t0 -1
    beq t0, a0, fopen_err
    mv s3 a0   

    mv a0 s3
    mv a1 s1
    li a2 4
    jal fread  
    li t3 4               
    bne a0, t3, fread_err   

    mv a0 s3
    mv a1 s2
    li a2 4
    jal fread   
    li t3 4            
    bne a0, t3, fread_err 

    lw t0, 0(s1)            
    lw t1, 0(s2)               
    mul a0 t0 t1            
    mv s4 a0   
    slli a0 a0 2   
    jal malloc
    beqz a0 malloc_err

    mv s5 a0

    mv a0 s3
    mv a1 s5
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul a2, t0, t1
    slli a2 a2 2
    mv s4 a2
    jal fread
    bne a0 s4 fread_err

    mv a0 s3
    call fclose
    bne a0, x0, fclose_err

    mv a0 s5

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    jr ra

fread_err:
    li a0 29
    j exit

fopen_err:
    li a0 27
    j exit

malloc_err:
    li a0 26
    j exit

fclose_err:
    li a0 28
    j exit