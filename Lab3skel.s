##
## Your Name:
## Last Four Digits of SID:
## EEC 170
## Lab 3
###

.data
quot:     .string "Quotient =  "
remain:   .string "Remainder = "
dividend: .string "Dividend =  "
divisor:  .string "Divisor =  "
newln:    .string "\n"
spc:      .string "       "
thank:    .string "Thank You\n"

#These are just sample values. Your program should work for all values  0 <= X <=40955 and 0 < Y <= 4095
X:  .word  189       #dividend   
Y:  .word  189        #divisor    


.text
.globl main                         # make main available to all project files

main:                               # There should be one main

  
    jal printInput

    lw a1, X                        # a3 = X
    lw a2, Y                        # a4 = Y

    # Divisor = a2, Dividend = a1

    jal myDiv

    jal printResults  
       
# Exit Politely with a Thank You Message

    la a1   thank
    li a0, 4
    ecall
    jal zero, exit                  # Exit program

# How to divide (from lecture slides)
# 1. Subtract division from remainder and put result into remainder
# 2. Test remainder, if bigger than 0, then shift quotient to left, 
# if less than 0, restore the original value by adding the divisor to the remainder
# and place sum in the remainder, shift quotient left
# 3. Shift divisor register right by 1
# 4. repeat


myDiv:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Initialize quotient (s2) and remainder (s3)
    li s2, 0              # Quotient = 0
    mv s3, a1             # Remainder = Dividend

loop:
    blt s3, a2, end       #done is when remainder < divisor
    sub s3, s3, a2 #subtract divisor from remainder
    addi s2, s2, 1 #increase quotient
    jal zero, loop

end:
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

#Make sure you return from the procedure


# Print Routines are provided. Don't Modify!!!

printInput:
        #print dividend=
            li a0, 4
            la a1, dividend
            ecall
            li a0, 1
            lw a1, X
            ecall
            li a0, 4
            la a1, spc
            ecall

        #print divisor=
            li a0, 4
            la a1, divisor
            ecall
            li a0, 1
            lw a1, Y
            ecall
            li a0, 4
            la a1, spc
            ecall
            jalr ra

printResults:
        #print Quotient=
            li a0, 4
            la a1, quot
            ecall
            li a0, 1
            mv a1, s2
            ecall
            li a0, 4
            la a1, spc
            ecall
        #print Remainder=
            li a0, 4
            la a1, remain
            ecall
            li a0, 1
            mv a1, s3
            ecall
            li a0, 4
            la a1, newln    
            ecall
            jalr ra

exit:
    addi a0, zero, 0xA 
    ecall
