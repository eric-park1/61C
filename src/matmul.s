.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
li t0 1
blt a1 t0 invalid_size
blt a2 t0 invalid_size
blt a4 t0 invalid_size
blt a5 t0 invalid_size
bne a2 a4 invalid_size

addi sp sp -40
sw s0 0(sp) # a0 ( matrix 1)
sw s1 4(sp) # a1 rows a
sw s2 8(sp) # a2 cols a
sw s3 12(sp) # a3 matrix b pointer
sw s4 16(sp) # row s b
sw s5 20(sp) # cols b
sw s6 24(sp) # a6 result matrix
sw s7 28(sp) # counter of curr row
sw s8 32(sp) # counter of curr col
sw ra 36(sp)
li s8 0
li s7 0 
mv s0 a0
mv s1 a1
mv s2 a2
mv s3 a3
mv s4 a4
mv s5 a5
mv s6 a6

rows_outer_loop:
beq s7 s1 finished

cols_inner_loop: 
mv a0 s0
mv a1 s3
mv a2 s2
li a3 1
mv a4 s5
jal dot
sw a0 0(s6) # set result array = to dot coli, rowj
addi s6 s6 4 # increment result array ptr
addi s3 s3 4 # increment matrix b ptr
addi s8 s8 1
bne s8 s5 cols_inner_loop

cols_reset:
li s8 0 # num cols = 0 
addi t0 s5 0
slli t0 t0 2
sub s3 s3 t0 # reset matrix b pointer
addi s7 s7 1 # inc row your on 
slli t0 s2 2
add s0 s0 t0 # inc matrix a ptr
j rows_outer_loop

finished:
mv a6 s6
lw s0 0(sp) # a0 ( matrix 1)
lw s1 4(sp) # a1 rows a
lw s2 8(sp) # a2 rows b
lw s3 12(sp) # a3 matrix b pointer
lw s4 16(sp) # row s b
lw s5 20(sp) # cols b
lw s6 24(sp) # a6 result matrix
lw s7  28(sp) # counter of curr row
lw s8 32(sp) # counter of curr col
lw ra 36(sp)
addi sp sp 40
jr ra

invalid_size:
li a0 38
j exit