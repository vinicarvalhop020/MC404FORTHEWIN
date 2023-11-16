
.data
input_file: .asciz "image.pgm"
input: .skip 262159

.text

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall

read:   

    la a1, input #  buffer to write the data
    li a2, 262159  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

get_width:

    #s0 salva o tamanho do numero
    #s1 salva a posicao do vetor


    li t0, 3 
    lb s1, 3(a1) # s1 <= &input + 3
    li s0, 0 #s0 guarda o tamanho do numero

    encontra_tamanho:
    li t1, 32 #valor do espaco em ascii
    beq s1, t1
    beq s1, t1, encontra_numero #se chegar em espaço pula para continue
    addi t0, t0, 1  #t0 + 1
    add s1, a1, t0 # anda no vetor s1 <= &input + t0 anda 1 byte
    lb s1, (s1) # s1 <= input[t0], atualiza s1
    addi s0, s0, 1 # soma 1 em s0

    j encontra_tamanho 

    encontra_numero:
    #s3 encontra o numero
        li t1, 3    
        bge s0, t1, centena
        li t1, 2
        bge s0, t1, dezena
        li t1, 1
        bge s0, t1, unidade

    centena:
        lb t0, 3(a1)
        lb t1, 4(a1)
        lb t2, 5(a1)
        addi t0, t0, -48
        addi t1, t1, -48
        addi t2, t2, -48
        li t3, 100
        li t4, 10
        mul t0, t0, t3
        mul t1, t1, t4
        add s3, t0, t1
        add s3, s3, t2
        j get_hight
    dezena:
        lb t0, 3(a1)
        lb t1, 4(a1)
        addi t0, t0, -48
        addi t1, t1, -48
        li t3, 10
        li t4, 1
        mul t0, t0, t3
        mul t1, t1, t4
        add s3, t0, t1
        j get_hight
    unidade:
        lb t0, 3(a1)
        addi t0, t0, -48
        mv s3, t0
        j get_hight


get_hight:
    
    li t0, 4

    add t0, t0, s0  #posicao 3 + s0 (onde começa o hight)
    add s1, a1, t0 # s1<= &input + t0
    lb s1, (s1) # s1 <= input[x+ t0]
    li s0, 0

    encontra_tamanho_hight:
        li t1, 32
        beq s1, t1, continue
        addi t0, t0, 1 #incrementa t0
        add s1, a1, t0 # s1<= &input +t0
        lb s1, (s1) 
        addi s0, s0, 1 #reconhece tamanho do numero
        j encontra_tamanho_hight

    continue:

        li t1, 3    
        bge s0, t1, cem
        li t1, 2
        bge s0, t1, dez
        li t1, 1
        bge s0, t1, um

    cem:
        add s4, a1, t0 #<= s4 = &input + t0
        lb s4, (s4)
        addi s4, s4, -48
        li t3, 100
        mul s4, s4, t3

        addi t0, t0, 1
        add t6, a1, t0 #<= t6 = &input + t0
        lb t6, (t6)
        addi t6, t6, -48
        li t4, 10
        mul t6, t6, t4
        add s4, s4, t6

        addi t0, t0, 1
        add t6, a1, t0
        lb t6, (t6)
        addi t6, t6, -48
        add s4, s4, t6

        j main

    dez:
        add s4, s1, t0
        lb s4, (s4)
        addi s4, s4, -48
        li t3, 10
        mul s4, s4, t3

        addi t0, t0, 1
        add t6, a1, t0
        lb t6, (t6)
        addi t6, t6, -48
        add s4, s4, t6

        j main

    um:
        add s4, s1, t0
        addi t0, t0, 1
        lb s4, (s4)
        addi s4, s4, -48

        j main
    
    #s3 contem width
    #s4 contem hight
    #t0 contem a proxima posiçao (add reg, a1, t0) precisa ser incrementado em 1

     

main:


set_canvas_size:
    mv a0, s3 #width
    mv a1, s4 #hight
    li a7, 2201
    ecall

open2:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open 
    ecall

read_2:

    la a1, input #  buffer to write the data
    li a2, 262159  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

print_image_canvas:


    li t1, 0
    li t2, 0
    addi t0, t0, 5 #< epaço + 255 + espaço = 5
    add s0, a1, t0 # s0 <= &input + t0


for_linhas:
bge t1, s4, exit #le até linha == altura

    for_colunas:
        bge t2, s3, atualiza_linha #le até coluna == largura 

        set_pixel:
            mv a0, t1 # x coordinate = 100 linha
            mv a1, t2 # y coordinate = 200 coluna

            atualiza_a2:

                shiftar_a2:
                lb s0, (s0)
                slli a2, s0, 24

                slli t6, s0, 16
                add a2, a2, t6

                slli t6, s0, 8
                add a2, a2, t6

                addi a2, a2, 255

            li a7, 2200 # syscall setPixel (2200)
            ecall

        atualiza_posicao_matriz:
            addi t0, t0, 1 #marcador de posicao da matrisz
            add s0, a1, t0

            addi t2, t2, 1 # atuliza posicao na coluna
            j for_colunas
        
        atualiza_linha:
            addi t1, t1, 1
            li t2, 0
            j for_linhas


exit: