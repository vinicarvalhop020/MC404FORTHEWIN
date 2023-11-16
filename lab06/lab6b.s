_start:

.data
input_1: .skip 12 # buffer
input_2:  .skip 20 
output: .skip 20

.text
read_in_1:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_1 #  buffer to write the data
    li a2, 12  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_2 #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

readYb:
    la a1, input_1
    lb t0, 0(a1) #sinal
    lb t1, 1(a1)
    lb t2, 2(a1)
    lb t3, 3(a1)
    lb t4, 4(a1)
    addi t1, t1, -48
    addi t2, t2, -48
    addi t3, t3, -48
    addi t4, t4, -48
    li t5,1000
    li t6,100
    li a7,10
    mul t1, t1, t5
    mul t2, t2, t6
    mul t3, t3, a7
    add t1, t1, t2
    add t1, t1, t3
    add t1, t1, t4 #t1 = YB
    li s0, '-'
    beq t0, s0, mult_men1
    j readXc
    #se tiver um '-' no primeiro valor do vetor salta para multmenos1
mult_men1:
    li s0, -1
    mul t1, t1, s0

readXc:
    li t5,1000
    li t6,100
    li a7,10
    #NAO USAR T1
    lb t0, 6(a1)
    lb t2, 7(a1)
    lb t3, 8(a1)
    lb t4, 9(a1)
    lb s1, 10(a1)
    addi t2, t2, -48
    addi t3, t3, -48
    addi t4, t4, -48
    addi s1, s1, -48
    mul t2, t2, t5
    mul t3, t3, t6
    mul t4, t4, a7
    add t2, t2, t3
    add t2, t2, t4
    add t2, t2, s1 #t2 = XC
    mv s9, t2 
    li s0, '-' 
    beq t0, s0, mult_men1xc
    j readTime
mult_men1xc:
    li  s0, -1
    mul t2, t2, s0
    mv s9, t2 


readTime:
    li t5,1000
    li t6,100
    li a7,10
    la a1, input_2
    lb s0, 0(a1)
    lb s1, 1(a1)
    lb s2, 2(a1)
    lb s3, 3(a1)
    addi s0, s0, -48
    addi s1, s1, -48
    addi s2, s2, -48
    addi s3, s3, -48
    mul s0, s0, t5
    mul s1, s1, t6
    mul s2, s2, a7
    add s0, s0, s1
    add s0, s0, s2
    add s0, s0, s3#s0 = TA
    #readTB
    lb s1, 5(a1)
    lb s2, 6(a1)
    lb s3, 7(a1)
    lb s4, 8(a1)
    addi s1, s1, -48
    addi s2, s2, -48
    addi s3, s3, -48
    addi s4, s4, -48
    mul s1, s1, t5
    mul s2, s2, t6
    mul s3, s3, a7
    add s1, s1, s2
    add s1, s1, s3
    add s1, s1, s4#s1 = TB
    #readTC
    lb s2, 10(a1)
    lb s3, 11(a1)
    lb s4, 12(a1)
    lb s5, 13(a1)
    addi s2, s2, -48
    addi s3, s3, -48
    addi s4, s4, -48
    addi s5, s5, -48
    mul s2, s2, t5
    mul s3, s3, t6
    mul s4, s4, a7
    add s2, s2, s3
    add s2, s2, s4
    add s2, s2, s5#s2 = TC
    #readTR
    lb s3, 15(a1)
    lb s4, 16(a1)
    lb s5, 17(a1)
    lb s6, 18(a1)
    addi s3, s3, -48
    addi s4, s4, -48
    addi s5, s5, -48
    addi s6, s6, -48
    mul s3, s3, t5
    mul s4, s4, t6
    mul s5, s5, a7
    add s3, s3, s4
    add s3, s3, s5
    add s3, s3, s6#s3 = TR

calc_dist:
    #diferenca de tempo
    sub s0, s3, s0#s3 - s0(TR- TA)
    sub s1, s3, s1#s3 - s1(TR- TB)
    sub s2, s3, s2#s3 - s2(TR- TC)
    #multiplica por 3 e divide por 10 (1.10^8 * 1.10^-9 = 1.10â»1)
    li s3, 3
    li s4, 10
    mul s0, s0, s3
    div s0, s0, s4#s0 = dA
    mul s1, s1, s3
    div s1, s1, s4#s1 = dB
    mul s2, s2, s3
    div s2, s2, s4#s2 = dC
    mv s3, s2

calc_posicao:
#usados s0, s1, s3, t1 e t2
    #equacao 4
    mul s0, s0, s0 #s0  = da ao quadrado
    mul s1, s1, s1 #s1 = db ao quadrado
    mul t3, t1, t1 #t3 = Yb ao quadrado
    add s4, s0, t3 #da^2 + yb^2
    sub s4, s4, s1 #s4 = da^2 + yb^2 - db^2
    li s5, 2
    mul s5, t1, s5#s5 = 2*yb
    div s4, s4, s5 #s4 = Y 
    #equacao 5
    mul s5, s4, s4#y ao quadrado
    mv t2, s5
    #numero da raiz
    sub s5, s0, s5 # da^2 - y^2, s5 = numero que vai aplicar o metodo da raiz

Babylonian_method:
    li t0, 2
    div t4, s5, t0 #k(t4)

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k
    
    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k

    div t3, s5, t4 #y/k
    add t4, t4, t3 # superior(k + y/k)
    div t4, t4, t0 #k1 atualiza k


    #opcao raiz negativa
    li s7, -1
    mv t5, t4
    mul t5, t5, s7 


#X = T4
#X = -T5
#Y = S4
#y ao 1
#t2 y ao q
#XC = s9
#dc = s3


la s7, output


equacao5:   
    mul s3, s3, s3
    li t0, -1

    debug1:
    sub s1, t4, s9 #(x - xc)
    mul s1, s1, s1 #(x-xc)Â²
    add s1, s1, t2 #(x-xc) aoq + yaoq
    sub s1, s1, s3 #opcao positiva

    sub s2, t5, s9 #(x - xc)
    mul s2, s2, s2 #(x - xc)^2
    add s2, s2, t2 #(x - xc)^2 + y^2
    sub s2, s2, s3 #opcao negativa


    ajusta_modularizacaos1:
        blt s1, zero, modularizas1
        j ajusta_modularizacaos2

    modularizas1:
        mul s1,s1, t0
    
    ajusta_modularizacaos2:
        blt s2, zero, modularizas2
        j continua
    
    modularizas2:
        mul s2, s2, t0


    continua:


    blt s1, s2, sinmais #se s1 < s2 coloca sinal de mais, sen pula para sin men
    j sinmen


sinmais:
    li t0, '+'
    sb t0, 0(s7)
    j siny

sinmen:
    li t0, '-'    
    sb t0, 0(s7)


siny:
blt s4, zero, add_sy
    li t0, '+'
    sb t0, 6(s7)
    j setwrite
add_sy:
    li t0, '-'    
    sb t0, 6(s7)
    li t0, -1
    mul s4, s4, t0
    j setwrite


setwrite:
    li t0, 1000
    li t1, 100
    li t2, 10


##x
    div a0, t4, t0
    rem t4, t4, t0
    addi a0, a0, 48
    sb a0, 1(s7)

    div a1, t4, t1
    rem t4, t4, t1
    addi a1, a1, 48
    sb a1, 2(s7)


    div a2, t4, t2
    addi a2, a2, 48
    sb a2, 3(s7)

    rem a3, t4, t2 
    addi a3, a3, 48
    sb a3, 4(s7)

    li t5, 32
    sb t5, 5(s7)


##y
    div a4, s4, t0
    rem s4, s4, t0
    addi a4, a4, 48
    sb a4, 7(s7)

    div a5, s4, t1
    rem s4, s4, t1
    addi a5, a5, 48
    sb a5, 8(s7)

    div a6, s4, t2
    addi a6, a6, 48
    sb a6, 9(s7)

    rem a7, s4, t2
    addi a7, a7, 48
    sb a7, 10(s7)

    li t5, 10
    sb t5, 11(s7)


write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output   # buffer
    li a2, 15           # size
    li a7, 64           # syscall write (64)
    ecall    






 