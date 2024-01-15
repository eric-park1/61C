.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# =============================================================================
 write_matrix:

    # Prologue
    addi sp, sp, -20
    sw s0, 0(sp)  
    sw s1, 4(sp)  
    sw s2, 8(sp)  
    sw s3, 12(sp)  
    sw s4, 16(sp) 
    mv s1, a1
    mv s2, a2
    mv s3, a3

    addi sp, sp, -4
    sw ra, 0(sp)
    li a1, 1
    jal fopen 
    li t0, -1
    beq a0, t0, fopen_err

    lw ra, 0(sp)
    addi sp, sp, 4
    mv s0, a0 
    addi sp, sp, -8
    sw s2, 0(sp)
    sw ra, 4(sp)

    mv a0, s0 
    mv a1, sp 
    li a2, 1
    slli a3 a2 2
    jal fwrite 
    li t0, 1
    bne a0, t0, fwrite_err

    lw s2, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    addi sp, sp, -8
    sw s3, 0(sp)
    sw ra, 4(sp)
    mv a0, s0 
    mv a1, sp
    li a2, 1  
    slli a3 a2 2
    jal fwrite 
    li t0, 1
    bne a0, t0, fwrite_err

    lw s3, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    mv a0, s0 
    mul s4, s2, s3 
    mv a1, s1          
    mv a2, s4
    li a3, 4 
    addi sp, sp, -4
    sw ra, 0(sp)
    
    jal fwrite 
    bne a0, s4, fopen_err 
    lw ra, 0(sp)
    addi sp, sp, 4
    
    addi sp, sp, -4
    sw ra, 0(sp)
    mv a0, s0 
    jal fclose
    bne a0, x0, fclose_err
    lw ra, 0(sp)
    addi sp, sp, 4 


    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp) 
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20
    mv a1, s1

    jr ra

fopen_err:
    li a0 27
    j exit

fclose_err:
    li a0 28
    j exit

fwrite_err:
    li a0 30
    j exit



