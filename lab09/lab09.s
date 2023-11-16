.global _start
_start:

.data
input: .skip 6
output: .skip 10

.text
read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    li a2, 6  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall


le_entrada:
    li t0, 0 #conta o tamanho do numero
    li t1, 0 #seta 1 se for negativo
    li t2, '\n'
    li t3, '-'

    lb t6, 0(a1)
    beq t6, t3, negativa
    lb s0, 0(a1)

    tamanho:
    beq s0, t2, encontra_numero
    addi t0, t0, 1
    add s0, a1, t0
    lb s0, (s0)
    j tamanho


    negativa:
        li t1, 1
        j tamanho
    
    encontra_numero:
    li t2, 1
    beq t1, t2, submen1

    continua:
    li t2, 5
    beq t0, t2, milhao
    li t2, 4
    beq t0, t2, milhar
    li t2, 3
    beq t0, t2, centena
    li t2, 2
    beq t0, t2, dezena
    li t2, 1
    beq t0, t2, unidade

    submen1:
        addi t0, t0, -1
        j continua

    milhao:
        li t2, 1
        li a1, 10000
        li t0, 1
        beq t0, t2, mulmen1
        j main
        mulmen1:
        li t0, -1
        mul a1, a1, t0
        j main
    
    milhar:
        li s1, 1000
        li s2, 100
        li s3, 10
        li t2, 1

        li t0, 1
        beq t1, t2, milmen1
        milpositivo:
            lb s0, 0(a1) #milhar
            addi s0, s0, -48
            mul s0, s0, s1

            lb a3, 1(a1) #centema
            addi a3, a3, -48
            mul a3, a3, s2
            add s0, s0, a3

            lb a3, 2(a1) #dezena
            addi a3, a3, -48
            mul a3, a3, s3
            add s0, s0, a3

            lb a3, 3(a1)
            addi a3, a3, -48
            add s0, s0, a3
            j main

        milmen1:
            lb s0, 1(a1) #milhar
            addi s0, s0, -48
            mul s0, s0, s1

            lb a3, 2(a1) #centema
            addi a3, a3, -48
            mul a3, a3, s2
            add s0, s0, a3

            lb a3, 3(a1) #dezena
            addi a3, a3, -48
            mul a3, a3, s3
            add s0, s0, a3

            lb a3, 4(a1)
            addi a3, a3, -48
            add s0, s0, a3
            li t0, -1
            mul s0, s0, t0
            j main
        
    centena:
            li t2, 1
            li s1, 100
            li s2, 10

            li t0, 1
            beq t1, t2, cemmen1
            cemposipositivo:
                lb s0, 0(a1) #centena
                addi s0, s0, -48
                mul s0, s0, s1

                lb a3, 1(a1) #deze
                addi a3, a3, -48
                mul a3, a3, s2
                add s0, s0, a3

                lb a3, 2(a1) #unidade
                addi a3, a3, -48
                add s0, s0, a3

                
                j main

            cemmen1:
                lb s0, 1(a1) #centena
                addi s0, s0, -48
                mul s0, s0, s1

                lb a3, 2(a1) #dezena
                addi a3, a3, -48
                mul a3, a3, s2
                add s0, s0, a3

                lb a3, 3(a1) #unidade
                addi a3, a3, -48
                add s0, s0, a3
                
                li t0, -1
                mul s0, s0, t0
                j main
    
    dezena:

            li s1, 10
            li t2, 1
            li t0, 1
            beq t1, t2, dezmen1
            dezposipositivo:
                lb s0, 0(a1) #dez
                addi s0, s0, -48
                mul s0, s0, s1

                lb a3, 1(a1) #uni
                addi a3, a3, -48
                add s0, s0, a3
                
                j main

            dezmen1:
                lb s0, 1(a1) #centena
                addi s0, s0, -48
                mul s0, s0, s1

                lb a3, 2(a1) #dezena
                addi a3, a3, -48
                add s0, s0, a3

                li t0, -1
                mul s0, s0, t0

                j main


    unidade:
            li t2, 1
            beq t1, t2, unimen1
            umpositivo:
                lb s0, 0(a1) #dez
                addi s0, s0, -48
                j main

            unimen1:
                lb s0, 1(a1) #centena
                addi s0, s0, -48
                li t0, -1
                mul s0, s0, t0

                j main
main:
    #s0 é meu numero
    la s1, head_node
    li a2, 0
    li s2, 0

while:

    beq s2, s0, achou
    beq t3, x0, nao_achou

    addi a2, a2, 1

    lw t1,(s1)
    lw t2,4(s1)
    lw s1,8(s1) #atualiza o endereco de s1
    mv t3, s1
    add s2, t1, t2
    
    j while    
    


    achou:
        addi a2, a2, -1
        j ajusta_output

    nao_achou:
        la s7, output
        li t0, '-'
        sb t0, 0(s7)
        li t0, '1'
        sb t0, 1(s7)
        li t0, '\n'
        sb t0, 2(s7)
        j write


    ajusta_output:
 
#faz a divisao inteira do numero por 1000, 100, 10, aquela que der de 1 a  9 dira qual o tamnho em casa o numero é (milhar, centena, dezena, unidade)
    
    teste_unidade:
        la s7, output
        li t0, 0
        li t1, 9
    bge a2, t0, testa_menor_nove # testa maior se >= 0
    j teste_dezena
        testa_menor_nove:
        blt a2, t1,eh_unidade #testa menor igual a nove
        beq a2, t1, eh_unidade # testa se é gual caso a menor falhe

    teste_dezena:
        la s7, output
        li t0, 10
        li t1, 99
    bge a2, t0, testa_menor_novenove
    j teste_centena
        testa_menor_novenove:
        blt a2, t1, eh_dezena
        beq a2, t1, eh_dezena # testa se é gual caso a menor falhe


    teste_centena:
        la s7, output
        li t0, 100
        li t1, 999
        bge a2, t0, testa_menor_novenovenove
        j teste_milhar
            testa_menor_novenovenove:
            blt a2, t1, eh_centena
            beq a2, t1, eh_centena # testa se é gual caso a menor falhe

    
    teste_milhar:
        la s7, output
        li t0, 1000
        li t1, 9999
        bge a2, t0, testa_menor_novenovenovenove
            testa_menor_novenovenovenove:
            blt a2, t1, eh_milhar
            beq a2, t1, eh_milhar # testa se é gual caso a menor falhe

    

    eh_milhar:

        mv s0, a2
        li t0, 1000
        li t1, 100
        li t2, 10


        div a1, s0, t0 #1 /1000
        rem s0, s0, t0 

        div a2, s0, t1# /100
        rem a3, s0, t1 #2 

        div a3, a3, t2# /10
        rem a4, a3, t2

        addi a1, a1, 48
        sb a1, 0(s7)

        addi a2, a2, 48
        sb a2, 1(s7)

        addi a3, a3, 48
        sb a3, 2(s7)

        addi a4, a4, 48
        sb a4, 3(s7)
        
        li a2, '\n'
        sb a2, 4(s7)


        j write

    eh_centena:
        mv s0, a2
        li t0, 100
        li t1, 10

        div a1, s0, t0
        rem s0, s0, t0

        div a2, s0, t1
        rem a3, s0, t1

        addi a1, a1, 48
        sb a1, 0(s7)

        addi a2, a2, 48
        sb a2, 1(s7)

        addi a3, a3, 48
        sb a3, 2(s7)

        li a2, '\n'
        sb a2, 3(s7)


        j write
    
    eh_dezena:
        mv s0, a2 

        li t0, 10
        div a1, s0, t0
        rem a2, s0, t0

        addi a1, a1, 48
        addi a2, a2, 48

        sb a1, 0(s7)
        sb a2, 1(s7)
        li a3, '\n'
        sb a3, 2(s7)

        j write
    
    eh_unidade:

        
        addi a2, a2, 48
        sb a2, 0(s7)    

        li a2, '\n'
        sb a2, 1(s7)

        j write

    write:
        li a0, 1            # file descriptor = 1 (stdout)
        la a1, output       # buffer
        li a2, 10           # size
        li a7, 64           # syscall write (64)
        ecall 


