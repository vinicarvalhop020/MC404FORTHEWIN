.global linked_list_search
.global puts #OK
.global gets #OK
.global atoi #OK
.global itoa #OK   
.global exit #OK

.data
aux: .skip 100

hex_value:
 .word 'A','B','C','D','E','F'

.text
linked_list_search: #Node *head_node, int val#

    li a3, 0 #somador

    do: 
    
        lw t0, (a0) ##VAL1
        lw t1, 4(a0) ##VAL2
        add t0, t0, t1 
        beq t0, a1, found 
        lw a0, 8(a0) #atualiza o endereco de a0


    while_ls:
    beq a0, x0, not_found

        addi a3, a3, 1 #soma o node como 1
        lw t0, (a0)
        lw t1, 4(a0)
        lw a0, 8(a0) #atualiza o endereco de a0
        add t0, t0, t1 #soma t0 + t1 
        beq t0, a1, found #compara com o procurado
        j while_ls


    found:
        mv a0, a3
    ret

    not_found:
        li a0, -1
    ret



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

gets:
 #while até um de um \n
    #a0 <= &str
    mv t5, a0 #stores a0 adress
    mv a1, a0 #<= a1 =  &a0
    li t0, 0 #contador de tamanho posicao 
    li t2, '\n'
    add t1, a1, t0 
    lb t1, (t1) #t1 aponta para caracteres do meu vetor

    while_ge: #wile read \n
    beq t1, t2, return

        read:
            li a0, 0  # file descriptor = 0 (stdin)
            li a2, 1  # size (reads only 1 byte)
            li a7, 63 # syscall read (63)
            ecall

        verify:
            lb t1, (a1)
            addi t0, t0, 1
            mv a1, t5
            add a1, a1, t0 #avança a1
            j while_ge

    
    return:
        li t0, -1
        add a1, a1, t0
        li t0, 0
        sb t0, (a1)
        mv a1, t5
        mv a0, a1 # a0 <= &a1
        ret

atoi:
    #1while até ler algo que nao é whitespace
    lb t0, 0(a0) #<= t0 = &a0[0]
    li t1, 0 #marcador_de_encontrou (Tambem marca a posicao do primeiro numero)
    li t2, 32 #todos os whitespaces na tabela ascii sao menores que 32
    li a5, 0

    is_negative:
        li t3, '-'
        beq t0, t3, negative
            j while_found_start
    
    negative:
        lb t0, 1(a0) #avança para começar apos o sinal 
        addi a0, a0, 1
        li a5, 1  #marcador de negatividade

    while_found_start:
        bge t0, t2, verify_caracter #jumps if the character is the start (vai pular os espacos)
        addi t1, t1 , 1 #incrementa para andar 
        add t0, a0, t1  #t0 = &a0[i+1]
        lb t0, (t0) #t0 = a0[i]
        j while_found_start

    verify_caracter:
        #nesse ponto sabemos onde começa a sequencia de numer
        li t3, 0 #contador do tamanho do numero
        add t0, a0, t1 #comeco na posicao exata do numero
        lb t0, (t0)

        while_found_size:
        #acaba se eu encontro algum whitespace, a partir da posicao inicial :)
            blt t0, t2, convert_to_str
            addi t3, t3, 1
            add t0, a0, t3
            lb t0, (t0)
            j while_found_size

    convert_to_str:
        addi t3, t3, -1
        #t1 contem a posicao de começo do meu numero
        #t3 contem o tamanho do meu numero  

        #1- encontrar o valor da base inicial
        #2- multiplicar o numero i pela base 

        #1 encontrar a base

        found_base:
        li t5, 1 #inicial_multiplicacao
        li t6, 10 #base_exponencial
        li t4, 0  # variavel de iteração  
            for_base:   
                bge t4, t3, found_number  
                mul t5, t5, t6 # t5 = x&10^i
                addi t4, t4, 1 
                j for_base

        found_number:

        add t0, a0, t1
        lb t0, (t0)
        li t2, 0

            for_found_number:
            #t0 contem meu numero no vetor
            #t1 contem a posicao do numero
            #t3 é o tamanho do numero 

                beq t5, x0, fix_base
                    addi t0, t0, -48 #ascii para decimal
                    mul t0, t0, t5 #t0[i] * base
                    add t2, t2, t0 #t2 recebe  n*base
                    div t5, t5, t6 #atualiza base dividindo por 10
                    addi t1, t1, 1 #anda +1 na posicao inicial do numero
                    add t0, a0, t1 # t0 = &a0[i+t1]
                    lb t0, (t0)# t0 = &a0[i+t1]
                    j for_found_number
                
                fix_base:
                    li t5, 1
                    mul t0, t0, t5
                    add t2, t2, t0
                    j get_number
                
        get_number:
            beq a5, x0, normal_ret
                j mult_men1
            normal_ret:
                mv a0, t2 #mv para o registrador de retorno a0 o t2
                ret
            mult_men1:
                li t1, -1
                mul t2, t2, t1
                mv a0, t2
                ret
 
itoa:
    #a0 takes the value
    mv t6, a1
    #a1 is the str
    #a2 is the base

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
        ret


exit:
    li a7, 93
    ecall
    ret




