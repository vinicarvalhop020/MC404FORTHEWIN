_start:

.data
input_1: .skip 5 # buffer
input_2:  .skip 8 
output_1: .skip 10
output_2: .skip 10
output_3: .skip 10


.text
read_encoding:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_1 #  buffer to write the data
    li a2, 5  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

encoding:
    la a1, input_1
    lb t0, 0(a1)
    lb t1, 1(a1)
    lb t2, 2(a1)
    lb t3, 3(a1)
    addi t0, t0, -48
    addi t1, t1, -48
    addi t2, t2, -48
    addi t3, t3, -48
parity:
    #p1 = d1,d2,d4
    xor t4, t0, t1
    xor t4, t4 ,t3 #t4 = p1
    #p2 = d1,d3,d4
    xor t5, t0, t2
    xor t5, t5, t3 #t5 = p2
    #p3 = d2d3d4
    xor t6, t1, t2
    xor t6, t6, t3 #t6 = p3
process_write:
    addi t0, t0, 48
    addi t1, t1, 48
    addi t2, t2, 48
    addi t3, t3, 48
    addi t4, t4, 48
    addi t5, t5, 48
    addi t6, t6, 48
    #p1p2d1p3d2d3d4
    la s0, output_1
    sb t4, 0(s0)
    sb t5, 1(s0)
    sb t0, 2(s0)
    sb t6, 3(s0)
    sb t1, 4(s0)
    sb t2, 5(s0)
    sb t3, 6(s0)

    #add \n
    li a5, 10
    sb a5, 7(s0)

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_1   # buffer
    li a2, 10           # size
    li a7, 64           # syscall write (64)
    ecall    


#######decoding
read_decoding:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_2 #  buffer to write the data
    li a2, 8  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

decoding:
    la a1, input_2
    lb t0, 0(a1)#p1
    lb t1, 1(a1)#p2
    lb t2, 2(a1)#d1
    lb t3, 3(a1)#p3
    lb t4, 4(a1)#d2
    lb t5, 5(a1)#d3
    lb t6, 6(a1)#d4
    
process_writedecoding:
    la s0, output_2
    sb t2, 0(s0)
    sb t4, 1(s0)
    sb t5, 2(s0)
    sb t6, 3(s0)
    sb a5, 4(s0)

writedecoding:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_2  # buffer
    li a2, 10           # size
    li a7, 64           # syscall write (64)
    ecall    

found_if_error:
    addi t0, t0, -48#p1
    addi t1, t1, -48#p2
    addi t2, t2, -48#d1
    addi t3, t3, -48#p3
    addi t4, t4, -48#d2
    addi t5, t5, -48#d3
    addi t6, t6, -48#d4

    xor t0, t0, t2#xor p1 d1
    xor t0, t0, t4#xor (p1 d1) d2
    xor t0, t0, t6#xor (p1 d1 d2) d4

    xor t1, t1, t2#xor p2 d1
    xor t1, t1, t5#xor p2 d1 d3
    xor t1, t1, t6#xor p2 d1 d3 d4

    xor t3, t3, t4#xor p3 d2
    xor t3, t3, t5#xor (p3 d2) d3
    xor t3, t3, t6#xor (p3 d2 d3 d4
    #or entre t0 t1 t3
    or t0, t0, t1#or t0 e t1
    or t0, t1, t3#or t1 e t3

    addi t0, t0, 48
    la s0, output_3
    sb t0, 0(s0)
    sb a5, 1(s0)

write_if_error:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output_3   # buffer
    li a2, 10           # size
    li a7, 64           # syscall write (64)
    ecall    