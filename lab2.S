.data

k: .word 4
A: .word -52, 47, 36, 36 # A [1x4] vector
B: .word -68 -83 -72 40, 31 20 -2 45, -14 -79 55 23, -83 21 54 22 # B[4x4] matrix stored in row major
C: .word 97, -94, 52, 45 # C[1 x 4] initialized to some random values.


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

    li x6, 0           

outer_loop:
    beq x6, x5, end_mvmult

    li x7, 0           
    li x8, 0           

inner_loop:
    beq x7, x5, store_result

    slli x9, x7, 2         
    add x10, x2, x9        
    lw x11, 0(x10)         

    mul x12, x7, x5        
    add x12, x12, x6       
    slli x12, x12, 2       
    add x13, x3, x12       
    lw x14, 0(x13)         

    mul x15, x11, x14     
    add x8, x8, x15        

    addi x7, x7, 1
    j inner_loop

store_result:
    slli x9, x6, 2         
    add x10, x4, x9        
    sw x8, 0(x10)

    addi x6, x6, 1
    j outer_loop

end_mvmult:
    jalr x0, 0(x1)        



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

