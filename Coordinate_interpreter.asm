
#Note that this file only contains a function xyCoordinatesToAddress
#As such, this function should work independent of any caller funmction which calls it
#When using regisetrs, you HAVE to make sure they follow the register usage convention in RISC-V as discussed in lectures.
#Else, your function can potentially fail when used by the autograder and in such a context, you will receive a 0 score for this part

xyCoordinatesToAddress:
	#(x,y) in (a0,a1) arguments
	#a2 argument contains base address
	#returns pixel address in a0
	
	#since this is leaf function, no need to preserve ra 
	
	#Enter code below!
	#make sure to return to calling function after putting correct value in a0!
	
	addi t5, a1, 0		# frees a1 register to use functions
	
	li a1, 4		# multiplier of 4 for x coordinate
	
	j multiply		# finds x pixel cordinate by multiply 4 with given x coordinate
a_m1:	
	addi t6, a0, 0 		#t6 holds the x pixel coordinate
	
	addi a0, t5, 0		# a0 holds y coordinate
	
	addi t5,zero,0
	
	addi a1, zero, 128 	# multiplier of 128 for y coordinate
	
	j multiply 		# gives y pixel coordinate by mmultiplying 128 with given y coordinate
a_m2:
	addi a1, a0, 0		# a1 is now y pixel coordinate
	
	addi a0, t6, 0		# a0 is now x pixel coordinate
	
	j sum_a
finish:	
	add a0,a2,a0
	addi a2,a0,0
	ret
 
sum_m:

	add a0 , a0, a1

	j a_sum_m
		
sum_a:

	add a0 , a0, a1

	j finish
		
multiply: #ennter multiply function

#accepts a0 and a1 as arguments for n1,m2
#retrurns n1*n2 in a0

#multiply in our example is callee to main but is itself caller to sum funciton
#using sum function herely is purely for demonstrational purposes only
#in reality , we would not need to call a funciton just to add 2 numbers!

#in this function, we are not using any s registers.
#so we are not concerned with preserving them to stack before we change modify them
#however, we need to preserve ra
	addi sp, sp, -8
	sd ra, 0(sp)

#trasnsfer a0,a1 to t0,t1
	addi t0,a0,0
	addi t1,a1,0

	#counter i=0
	addi t3,zero,0
	#result =0
	addi t4,zero, 0
	
loop:	beq t3,t1, loop_exit #exit loop when i=n2
	
#let's call function sum to compute: t4+t0

	#preserve t0,t1,t2,t3,t4 to stack as caller funciton
	addi sp, sp, -40
	sd t0, 0(sp)
	sd t1, 8(sp)
	sd t2, 16(sp)
	sd t3, 24(sp)
	sd t4, 32(sp)
	
	#place arguments in a0,a1
	addi a0, t4, 0
	addi a1, t0, 0
	
	j sum_m
	#a0 returns with n1+n2
a_sum_m:	
	#restore stack values as caller 
	ld t0, 0(sp)
	ld t1, 8(sp)
	ld t2, 16(sp)
	ld t3, 24(sp)
	ld t4, 32(sp)
	addi sp, sp, 40
	
	#acumulate a0 in  t4
	addi t4, a0, 0
	
loop_update:
	addi, t3,t3,1
	b loop
	
loop_exit:
	#restore ra fo the convenience of multiply's caller
	ld ra, 0(sp)
	addi sp, sp, 8

#done with multiply function!
	beq zero,t5, a_m2
	j a_m1
	
done:
	addi a0,a0,0
