
.section .text
.set PLAY_GPS , 0xFFFF0100
.set X_POSITION, 0xFFFF0110
.set Y_POSITION, 0xFFFF0114
.set Z_POSITION, 0xFFFF0118
.set STEERING_WHEEL, 0xFFFF0120
.set ENGINE_DIRECTION, 0xFFFF0121
.set HAND_BREAK, 0xFFFF0122

##entrance_coordinates
.set entrance_X, 73
.set entrance_Y, 1
.set entrance_Z, -19

actualize_coordinators:

    on_gps:
        li a0, PLAY_GPS
        li t1, 1
        sb t1, (a0)
        li t1, 0

    wait_set_0:
        beq a0, x0, returnCoordinators
        li a0, PLAY_GPS
        lb a0, (a0)
        j wait_set_0
    
    returnCoordinators:
        ret
        
D_vector:

    addi sp, sp, -4
    sw ra, (sp)
    jal actualize_coordinators
    lw ra, (sp)
    addi sp, sp, 4


    Load_New_Coordinators:
        li a0, X_POSITION
        li a1, Y_POSITION
        li a2, Z_POSITION
        lb a0, (a0)
        lb a1, (a1)
        lb a2, (a2)

    Create_Vecotor_D:
        li t0, entrance_X
        li t1, entrance_Y
        li t2, entrance_Z

        sub a0, t0, a0 # D_X = entrance_X - X_POSITION 
        sub a1, t1, a1 # D_Y = entrance_Y - Y_POSITION
        sub a2, t2, a2 # D_Z = entrance_Z - Z_POSITION

    ret

C_vector:
#HOW TO GETS THE OLD POSITION ???CAN I WAIT THE CAR WALKS A BIT?

    loads_old_coordinators:
        li a0, X_POSITION
        li a1, Y_POSITION
        li a2, Z_POSITION
        lb a0, (a0)#X_POSITION 
        lb a1, (a1)#Y_POSITION
        lb a2, (a2)#Z_POSITION
        
        mv t0, a0
        mv t1, a1
        mv t2, a2


    addi sp, sp, -4
    sw ra, (sp)
    jal actualize_coordinators
    lw ra, (sp)
    addi sp, sp, 4

    Load_New_Coordinators_C:
        li a0, X_POSITION
        li a1, Y_POSITION
        li a2, Z_POSITION
        lb a0, (a0)#X_POSITION 
        lb a1, (a1)#Y_POSITION
        lb a2, (a2)#Z_POSITION

    Create_Vector_C:
        
        sub a0, a0, t0 # C_X = nex_x - old_x
        sub a1, a1, t1 # C_Y = new_z - old_y
        sub a2, a2, t2 # C_Z = new_z - old_z

    ret

go_foward:

    li a0, ENGINE_DIRECTION
    li a1, 1
    sb a1, (a0)
    ret

stop_engine:

    li a0, ENGINE_DIRECTION
    li a1, 0
    sb a1, (a0)
    ret

brake:

    li a0, HAND_BREAK
    li a1, 1
    sb a1, (a0)
    ret

turn_left:

    li a0, STEERING_WHEEL
    li a1, -127
    sb a1, (a0)
    ret

turn_right:

    li a0, STEERING_WHEEL
    li a1, 127
    sb a1, (a0)
    ret

sqrt_of:
    #a0 = num

    Babylonian_method:

    li t0, 2
    div t1, a0, t0 #k(t1)

    li t3, 19 #limite do meu forS
    li t4, 0 #variavel de iteracao

    twenty_iterations:
    beq t4, t3, return
    
        div t2, a0, t1 #y/k
        add t1, t1, t2 # superior(k + y/k)
        div t1, t1, t0 #k1 atualiza k
        addi t4, t4, 1

    return:
        mv a0, t1 #returns in a0 the square of the number 
    ret

internal_product:
    #receive two_vectors and make a internal product returning a value
    addi sp, sp, -4
    sw ra, (sp)
    jal D_vector
    lw ra, (sp)
    addi sp, sp, 4

    mv t0, a0
    mv t1, a1
    mv t2, a2


    addi sp, sp, -4
    sw ra, (sp)
    jal C_vector #### bug wat is in a0, a1, a2?
    lw ra, (sp)
    addi sp, sp, 4


    internal_product_calcus:

    mul a0, a0, t0
    mul a1, a1, t1
    mul a2, a2, t2


    add a0, a0, a1
    add a0, a0, a2

    ret

calculs_the_norm:
    #calculs the norm of a vector
    #a0 X
    #a1 Y
    #a2 Z
    mul a0, a0, a0 #a0 = a0 ^2
    mul a1, a1, a1 #a1 = a1 ^2
    mul a2, a2, a2 #a2 = a2 ^2
    add a0, a0, a1 #a0 = a0 + a1
    add a0, a0, a2 #a0 = a0 + a2

    #calculs the sqrt of a0
    
    addi sp, sp, -4
    sw ra, (sp)
    jal sqrt_of
    lw ra, (sp)
    addi sp, sp, 4 

    #returns the norm in a0 
    ret


check_distance:

    addi sp, sp, -4
    sw ra, (sp)
    jal D_vector
    lw ra, (sp)
    addi sp, sp, 4 

    #calculs the norm of a vector

    addi sp, sp, -4
    sw ra, (sp)
    jal calculs_the_norm
    lw ra, (sp)
    addi sp, sp, 4 

    #a0 has the norm, and the norm is the distance

    ret


.global _start
_start:
main:

    infinite_while_go_foward:

        control:
            #always calculs the distance between entrance and the car
            foward_and_stop:
                addi sp, sp, -4
                sw ra, (sp)
                jal go_foward
                lw ra, (sp)
                addi sp, sp, 4


            addi sp, sp, -4
            sw ra, (sp)
            jal check_distance
            lw ra, (sp)
            addi sp, sp, 4
            
            #stops when the distance between entrance and the car is less than 20
            li t0, 20
            blt a0, t0, exit

            addi sp, sp, -4
            sw ra, (sp)
            jal internal_product
            lw ra, (sp)
            addi sp, sp, 4

            blt a0, x0, left

                left:
                    addi sp, sp, -4
                    sw ra, (sp)
                    jal turn_left
                    lw ra, (sp)
                    addi sp, sp, 4
                    j continue_loop
                
                right:
                    addi sp, sp, -4
                    sw ra, (sp)
                    jal turn_right
                    lw ra, (sp)
                    addi sp, sp, 4
                    j continue_loop
            

                #stops this while when the distance of the car until the state is less than 20 meters
            continue_loop:
                j control
    
    exit:
        addi sp, sp, -4
        sw ra, (sp)
        jal stop_engine
        lw ra, (sp)
        addi sp, sp,  4

        addi sp, sp, -4
        sw ra, (sp)
        jal brake
        lw ra, (sp)
        addi sp, sp, 4

        li a7, 93
        ecall








