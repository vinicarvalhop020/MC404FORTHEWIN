.global puts #OK
.global itoa


.data
aux: .skip 100
str: .skip 100

hex_value:
 .word 'A','B','C','D','E','F'


.text
itoa:
    #a0 takes the value
    mv t6, a1
    #a1 is the str
    #a2 is the base

    la a1, str
    li a2, 10

    int_str:
        li t0, 16
        beq a2, t0, hex_conv

    la a3, aux

    blt a0, x0, negativa
    

    dec_conv:
        la a3, aux
        li t2, 0 #saves the lenght of numbr
        li t3, 0 #marcador de posicao do vetor


        div t0, a0, a2 #divisao do numero pela base
        rem t1, a0, a2 #resto da divisao do numero pela base

        sb t1, (a3)# salva na primeira posicao do vetor 
        addi t3, t3, 1

        while_rst0:
            beq t0, x0, next_step
            rem t1, t0, a2 #salva o resto da divisao do numero atual pela base
            addi t2, t2, 1
            div t0, t0, a2 #divide o numero atual pela base (decrescendoo)
            add a3, a3, t3 #anda no vetor
            sb t1, (a3) #stores in a3
            j while_rst0

        next_step:
        la a4, aux

        mv t4, t2
        addi t4, t4, 1 #range do for
        li t5, 0 #iteracoao

        for_pass_number:
            beq t5, t4, return_itoa
                add a4, a4, t2 #ultima posicao do nm
                lb t0, (a4)
                addi t0, t0, 48
                sb t0, (a1)
                addi a1, a1, 1 #anda em a1
                addi t5, t5, 1 #anda em i 
                addi t2, t2, -1
                la a4, aux #restores the initial position
                j for_pass_number


    negativa:
        li t2, -1
        li t3, '-'
        sb t3, (a1)
        mul a0, a0, t2
        addi a1, a1, 1
        j dec_conv


    hex_conv:
        la a3, aux
        li t2, 0 #saves the lenght of numbr
        li t3, 0 #marcador de posicao do vetor
        div t0, a0, a2 #divisao do numero pela base
        rem t1, a0, a2 #resto da divisao do numero pela base

        sb t1, (a3)# salva na primeira posicao do vetor 
        addi t3, t3, 1

        while_rst0_hex:
            beq t0, x0, next_step_hex
            rem t1, t0, a2 #salva o resto da divisao do numero atual pela base
            addi t2, t2, 1
            div t0, t0, a2 #divide o numero atual pela base (decrescendoo)
            add a3, a3, t3 #anda no vetor
            sb t1, (a3) #stores in a3
            j while_rst0_hex

        next_step_hex:
        la a4, aux
        lb t0, (a4)
        lb t0, 1(a4)
        lb t0, 2(a4)
        lb t0, 3(a4)


        mv t4, t2
        addi t4, t4, 1 #range do for
        li t5, 0 #iteracoao
        li a6, 10

        for_pass_number_hex:
            beq t5, t4, return_itoa
                add a4, a4, t2 #ultima posicao do nm
                lb t0, (a4)

                bge t0, a6, need_conversion 
                addi t0, t0, 48
                continue_flux:
                    sb t0, (a1)
                    addi a1, a1, 1 #anda em a0
                    addi t5, t5, 1 #anda em i 
                    addi t2, t2, -1
                    la a4, aux #restores the initial position
                    j for_pass_number_hex

                need_conversion:
                    la a7, hex_value
                    li a5, 4
                    sub t0, t0, a6 # t0 = t0 - 10
                    mul t0, t0, a5
                    add a7, a7, t0
                    lb t0, (a7)
                    j continue_flux


        return_itoa:
            li t1, 0 #/0 in the end
            sb t1, (a1)
            mv a1, t6
            mv a0, a1
        
        j puts

puts:   
    #const char *str 
    #a0 <= &str

    lb t1, 0(a0) #<= a1 = str[0]
    li t2, 0
    li t3, 0 
    

##discover the lenght of string read until \0
    while_puts:
        beq t1, t2, write #comapara posicao do vetor com \0
        addi t3, t3, 1 #soma 1 em t3 
        add t1, a0, t3 #anda a0, a1 =   &str[x+1]
        lb t1, (t1) 
        j while_puts

    #troca \0 por \n
    #t3 contem o tamanho

    write:
        li t4, '\n'
        add a0, a0, t3 #a0 = &str[a3]
        sb t4, 0(a0)
        sub a0, a0, t3 #a0 = &str[0]
        addi t3, t3, 1 #incrementa a3 em 1 para o size
        mv a1, a0
        li a0, 1            # file descriptor = 1 (stdout)
        mv a2, t3           # size
        li a7, 64           # syscall write (64)
        ecall  
    ret