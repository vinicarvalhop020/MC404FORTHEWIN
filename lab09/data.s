.globl head_node

.data
head_node: 
    .word 10
    .word -4
    .word node_1
.skip 10
node_1: 
    .word 56
    .word 78
    .word node_2
.skip 5
node_3:
    .word -100
    .word -43
    .word node_4
node_2:
    .word -654
    .word 590
    .word node_3
node_4:
    .word 30
    .word 3  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_5
# Node 5
node_5:
    .word -7
    .word 4  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_6
# Node 6
node_6:
    .word 0
    .word 5  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_7
# Node 7
node_7:
    .word -15
    .word 6  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_8
# Node 8
node_8:
    .word 8
    .word 7  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_9
# Node 9
node_9: 
    .word 51
    .word 8  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_10
# Node 10
node_10:
    .word 4
    .word 9  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_11
# Node 11
node_11:
    .word -9
    .word 10  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_12
# Node 12
node_12:
    .word 7
    .word 11  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_13
# Node 13
node_13:
    .word 60
    .word 12  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_14
# Node 14
node_14:
    .word -5
    .word 13  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_15
# Node 15
node_15:
    .word -8
    .word 14  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_16
# Node 16
node_16:
    .word -30
    .word 15  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_17
# Node 17
node_17:
    .word -3
    .word 16  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_18
# Node 18
node_18:
    .word 12
    .word 17  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_19
# Node 19
node_19:
    .word -2
    .word 18  # Valor 2 do nó (ajustado para garantir soma única)
    .word node_20
node_20:
    .word 998
    .word 1
    .word 0


