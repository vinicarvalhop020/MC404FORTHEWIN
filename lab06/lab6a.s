.data
input_address: .skip 20  # buffer
output: .skip 20

start:
.text
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall


str_decn1:

    #carrega nso registradores os bytes do primeiro numero
    la a1, input_address
    lb a2, 0(a1) 
    lb a3, 1(a1)
    lb a4, 2(a1)
    lb a5, 3(a1)


    #soma o valor -48 nos bytes (converte de caracter para decimal tabela ascii)
    addi a2, a2, -48
    addi a3, a3, -48
    addi a4, a4, -48
    addi a5, a5, -48

    #carrega valor das potencias necessarias para converter o valor para decimal
    li t1, 1000
    li t2, 100
    li t3, 10

    #multiplica por cada potencia
    mul a2, a2, t1
    mul a3, a3, t2
    mul a4, a4, t3

    add a2, a2, a3
    add a2, a2, a4
    add s0, a2, a5


Babylonian_methon1:

    li t0, 2
    div t1, s0, t0 #k(t1)


    div t2, s0, t1 #y/k
    add t1, t1, t2 # superior(k + y/k)
    div t1, t1, t0 #k1 atualiza k

    div t2, s0, t1
    add t1, t1, t2
    div t1, t1, t0 #k2

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k3

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k4

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k5

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k6

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k7

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k8

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k9

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k10

    mv s0, t1


organizan1:

    li t1, 1000
    li t2, 100
    li t3, 10

    div a1, s0, t1 #divide o numero por 1000 e pega o primeiro byte
    rem s0, s0, t1 #pega o resto do primeiro numero

    div a2, s0, t2 #divide o resto do primeiro numero por 100 e pega o segundo byte
    rem s0, s0 ,t2 #resto2


    div a3, s0, t3 #divide o resto do 2 numero por 10 e pega o terceiro byte
    rem a4, s0, t3 #resto do ultimo numero 4 byte


    #converte o numero que esta em a7 para caracter e salva no registrador a2
    la s2, output

    addi a1, a1, 48
    sb a1, 0(s2) # output[1] (s2 + 1) = a2

    addi a2, a2, 48
    sb a2, 1(s2)

    addi a3, a3, 48
    sb a3, 2(s2)

    addi a4, a4, 48
    sb a4, 3(s2)

    li t1, 32 #add o \n na ultima posicao
    sb t1, 4(s2)


#######################################fim do n1
str_decn2:

    #carrega nso registradores os bytes do primeiro numero
    la a1, input_address
    lb a2, 5(a1) 
    lb a3, 6(a1)
    lb a4, 7(a1)
    lb a5, 8(a1)


    #soma o valor -48 nos bytes (converte de caracter para decimal tabela ascii)
    addi a2, a2, -48
    addi a3, a3, -48
    addi a4, a4, -48
    addi a5, a5, -48

    #carrega valor das potencias necessarias para converter o valor para decimal
    li t1, 1000
    li t2, 100
    li t3, 10

    #multiplica por cada potencia
    mul a2, a2, t1
    mul a3, a3, t2
    mul a4, a4, t3

    add a2, a2, a3
    add a2, a2, a4
    add s0, a2, a5


Babylonian_methodn2:

    li t0, 2
    div t1, s0, t0 #k(t1)


    div t2, s0, t1 #y/k
    add t1, t1, t2 # superior(k + y/k)
    div t1, t1, t0 #k1 atualiza k

    div t2, s0, t1
    add t1, t1, t2
    div t1, t1, t0 #k2

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k3

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k4

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k5

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k6

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k7

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k8

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k9

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k10

    mv s0, t1


organizan2:

    li t1, 1000
    li t2, 100
    li t3, 10

    div a1, s0, t1 #divide o numero por 1000 e pega o primeiro byte
    rem s0, s0, t1 #pega o resto do primeiro numero

    div a2, s0, t2 #divide o resto do primeiro numero por 100 e pega o segundo byte
    rem s0, s0 ,t2 #resto2


    div a3, s0, t3 #divide o resto do 2 numero por 10 e pega o terceiro byte
    rem a4, s0, t3 #resto do ultimo numero 4 byte


    #converte o numero que esta em a7 para caracter e salva no registrador a2
    la s2, output

    addi a1, a1, 48
    sb a1, 5(s2) # output[1] (s2 + 1) = a2

    addi a2, a2, 48
    sb a2, 6(s2)

    addi a3, a3, 48
    sb a3, 7(s2)

    addi a4, a4, 48
    sb a4, 8(s2)

    li t1,32 #add o ' ' na ultima posicao
    sb t1, 9(s2)

########################################################################

#######################################fim do n2
str_decn3:

    #carrega nso registradores os bytes do primeiro numero
    la a1, input_address
    lb a2, 10(a1) 
    lb a3, 11(a1)
    lb a4, 12(a1)
    lb a5, 13(a1)


    #soma o valor -48 nos bytes (converte de caracter para decimal tabela ascii)
    addi a2, a2, -48
    addi a3, a3, -48
    addi a4, a4, -48
    addi a5, a5, -48

    #carrega valor das potencias necessarias para converter o valor para decimal
    li t1, 1000
    li t2, 100
    li t3, 10

    #multiplica por cada potencia
    mul a2, a2, t1
    mul a3, a3, t2
    mul a4, a4, t3

    add a2, a2, a3
    add a2, a2, a4
    add s0, a2, a5


Babylonian_methodn3:

    li t0, 2
    div t1, s0, t0 #k(t1)


    div t2, s0, t1 #y/k
    add t1, t1, t2 # superior(k + y/k)
    div t1, t1, t0 #k1 atualiza k

    div t2, s0, t1
    add t1, t1, t2
    div t1, t1, t0 #k2

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k3

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k4

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k5

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k6

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k7

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k8

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k9

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k10

    mv s0, t1


organizan3:

    li t1, 1000
    li t2, 100
    li t3, 10

    div a1, s0, t1 #divide o numero por 1000 e pega o primeiro byte
    rem s0, s0, t1 #pega o resto do primeiro numero

    div a2, s0, t2 #divide o resto do primeiro numero por 100 e pega o segundo byte
    rem s0, s0 ,t2 #resto2


    div a3, s0, t3 #divide o resto do 2 numero por 10 e pega o terceiro byte
    rem a4, s0, t3 #resto do ultimo numero 4 byte


    #converte o numero que esta em a7 para caracter e salva no registrador a2
    la s2, output

    addi a1, a1, 48
    sb a1, 10(s2) # output[1] (s2 + 1) = a2

    addi a2, a2, 48
    sb a2, 11(s2)

    addi a3, a3, 48
    sb a3, 12(s2)

    addi a4, a4, 48
    sb a4, 13(s2)

    li t1,32 #add o ' ' na ultima posicao
    sb t1, 14(s2)

#############################################fim do n4

str_decn4:

    #carrega nso registradores os bytes do primeiro numero
    la a1, input_address
    lb a2, 15(a1) 
    lb a3, 16(a1)
    lb a4, 17(a1)
    lb a5, 18(a1)


    #soma o valor -48 nos bytes (converte de caracter para decimal tabela ascii)
    addi a2, a2, -48
    addi a3, a3, -48
    addi a4, a4, -48
    addi a5, a5, -48

    #carrega valor das potencias necessarias para converter o valor para decimal
    li t1, 1000
    li t2, 100
    li t3, 10

    #multiplica por cada potencia
    mul a2, a2, t1
    mul a3, a3, t2
    mul a4, a4, t3

    add a2, a2, a3
    add a2, a2, a4
    add s0, a2, a5


Babylonian_methodn4:

    li t0, 2
    div t1, s0, t0 #k(t1)


    div t2, s0, t1 #y/k
    add t1, t1, t2 # superior(k + y/k)
    div t1, t1, t0 #k1 atualiza k

    div t2, s0, t1
    add t1, t1, t2
    div t1, t1, t0 #k2

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k3

    div t2,s0, t1
    add t1,t1, t2
    div t1, t1, t0 #k4

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k5

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k6

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k7

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k8

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k9

    div t2,s0, t1
    add t1,t1, t2
    div t1,t1, t0 #k10

    mv s0, t1


organizan4:

    li t1, 1000
    li t2, 100
    li t3, 10

    div a1, s0, t1 #divide o numero por 1000 e pega o primeiro byte
    rem s0, s0, t1 #pega o resto do primeiro numero

    div a2, s0, t2 #divide o resto do primeiro numero por 100 e pega o segundo byte
    rem s0, s0 ,t2 #resto2


    div a3, s0, t3 #divide o resto do 2 numero por 10 e pega o terceiro byte
    rem a4, s0, t3 #resto do ultimo numero 4 byte


    #converte o numero que esta em a7 para caracter e salva no registrador a2
    la s2, output

    addi a1, a1, 48
    sb a1, 15(s2) # output[1] (s2 + 1) = a2

    addi a2, a2, 48
    sb a2, 16(s2)

    addi a3, a3, 48
    sb a3, 17(s2)

    addi a4, a4, 48
    sb a4, 18(s2)

    li t1, 10 #add o '\n' na ultima posicao
    sb t1, 19(s2)

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output   # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall    