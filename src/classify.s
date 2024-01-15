.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

classify:
    addi sp, sp, -52
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

   
    addi t0, x0, 5 #incorrect args exception
    bne a0, t0, incorrect_args_err

    mv s0, a1
    mv s1, a2


    # Load pretrained m0
    lw t0, 4(s0)
    addi sp, sp, -8
    mv a1, sp
    addi a2, sp, 4
    mv a0, t0
    jal ra, read_matrix
    mv s2, a0       
    lw s5, 0(sp)       
    lw s6, 4(sp)       
    addi sp, sp, 8

    # Load pretrained m1

    lw t0, 8(s0)
    addi sp, sp, -8
    mv a1, sp
    addi a2, sp, 4
    mv a0, t0
    jal ra, read_matrix
    mv s3, a0    
    lw s7, 0(sp)      
    lw s8, 4(sp)      
    addi sp, sp, 8

    # Load input matrix
    lw t0, 12(s0)
    addi sp, sp, -8
    mv a1, sp
    addi a2, sp, 4  
    mv a0, t0
    jal ra, read_matrix
    mv s4, a0      
    lw s9, 0(sp)      
    lw s10, 4(sp)      
    addi sp, sp, 8
    
    
    #matmul
    mul t0, s5, s10
    slli t2, t0, 2
    mv a0, t2
    jal malloc
    beqz a0 malloc_err
    mv s11, a0     

    

    mv a0, s2
    mv a1, s5
    mv a2, s6
    mv a3, s4
    mv a4, s9
    mv a5, s10
    mv a6, s11

    jal ra, matmul

    #ReLU
    mv a0, s11
    mul a1, s5, s10 
    jal ra, relu     

    mul t0, s7, s10 
    slli t2, t0, 2

    #o = matmul(m1, h) where h = relu(h)
    mv a0, t2
    jal ra, malloc

    beqz a0 malloc_err

    mv t0, a0  

    addi sp, sp, -4
    sw t0, 0(sp)

    mv a0, s3
    mv a1, s7
    mv a2, s8
    mv a3, s11
    mv a4, s5
    mv a5, s10
    mv a6, t0

    jal ra, matmul
    
    lw t0, 0(sp)
    addi sp, sp, 4

    mv a0, s11 
    mv s11, t0
    jal ra, free
    

    lw a0, 16(s0)
    mv a1, s11
    mv a2, s7
    mv a3, s10
    jal ra, write_matrix
   
    
    mul t0, s7, s10
    mv a1, t0
    mv a0, s11
    jal ra, argmax
    mv s0, a0  
    
    

    # Print classification
   
    bne s1, x0, end
    mv a0, a0
    jal ra, print_int
    li a0, '\n'
    jal ra, print_char

    # Epilogue
end:
    mv a0 s11
    jal ra, free
    
    mv a0, s2
    jal ra, free
    
    mv a0, s3
    jal ra, free
    
    mv a0, s4
    jal ra, free

    mv a0, s0


	lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    jr ra


incorrect_args_err:
	li a0 31
    j exit

malloc_err: 
	li a0 26
    j exit
