.data

k: .word  4
A: .word  -15, -63, -17, -29     # A [1xk] vector
B: .word  1, -87, -91, 68, -54, -46, 24, 100, -73, -58, 12, -2, 80, 2, 83, 97, 51  # B[4x4] matrix stored in row major
C: .word  -99, -5, 29, 62    # C[1 x k] initialized to some random values.


msg1:     .string "C = "
spc:      .string "  "
newln:    .string "\n"


# .text means the rest of the stuff is a program or instructions to the computer
.text
.globl main                         # make main available to all project files

main:                               # There should be one main

la x2, A 
la x3, B 
la x4, C 
lw x5, k      # x5 contains the dimension of your vector/matrix


# Step 1. call the function mvmult
jal x1, mvmult

#  Step 2. call the function printResult
jal x1, printResult



# Exit the program gracefully. Don't modify anything below this.  
   la a1, newln
    li a0, 4
    ecall

exit:
    addi a0, zero, 10 
    ecall


#YOUR CODE GOES HERE 
mvmult:
    # x2 = A, x3 = B, x4 = C, x5 = k

    li x6, 0           # x6 = j (outer loop index)

outer_loop:
    beq x6, x5, end_mvmult

    li x7, 0           # x7 = i (inner loop index)
    li x8, 0           # x8 = accumulator (C[j])

inner_loop:
    beq x7, x5, store_cj

    slli x9, x7, 2         # x9 = i * 4
    add x10, x2, x9        # x10 = &A[i]
    lw x11, 0(x10)         # x11 = A[i]

    mul x12, x7, x5        # x12 = i * k
    add x12, x12, x6       # x12 = i * k + j
    slli x12, x12, 2       # x12 = word offset
    add x13, x3, x12       # x13 = &B[i][j]
    lw x14, 0(x13)         # x14 = B[i][j]

    mul x15, x11, x14      # x15 = A[i] * B[i][j]
    add x8, x8, x15        # x8 += product

    addi x7, x7, 1
    j inner_loop

store_cj:
    slli x9, x6, 2         # x9 = j * 4
    add x10, x4, x9        # &C[j]
    sw x8, 0(x10)

    addi x6, x6, 1
    j outer_loop

end_mvmult:
    jalr x0, 0(x1)         # return



#END of your CODE

# Don't Touch this (BEGIN)

printResult:
# Code to print "C = "
    la a1, msg1
    li a0, 4
    ecall 

     la x4, C 
     lw x5, k      # x5 contains the dimension of your vector/matrix
      li x6, 0     # forloop index variable
forloop: 
      slli x7, x6, 2         # x7 has the offset
      add  x8, x4, x7       # x8 points to C[i]
      lw a1, 0(x8)          # a1 has element C[i]
      li a0, 1
      ecall                 #print C[i]

      la a1, spc           # print space
      li a0, 4
      ecall 

      addi x6, x6, 1   
      beq  x6, x5, L
      j forloop

L:  jalr x0, 0(x1)

