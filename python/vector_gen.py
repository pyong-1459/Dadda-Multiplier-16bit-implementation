import numpy as np
import random
import math


f_input  = open("input.txt", 'w')
f_output = open("output.txt", 'w')
# f_raw = open("data_raw.txt", 'w')

vectors = np.zeros(shape=(3,1000))
for i in range(1000):
    A = math.floor(random.random() * 65536)
    B = math.floor(random.random() * 65536)
    Y = A * B
    vectors[0][i] = A
    vectors[1][i] = B
    vectors[2][i] = Y
    
    # A_hex = hex(A)
    A_hex = format(A, '06X')
    B_hex = format(B, '06X')
    Y_hex = format(Y, '010X')
    A_hex = A_hex[2:] + "\n"
    B_hex = B_hex[2:] + "\n"
    Y_hex = Y_hex[2:] + "\n"
    f_input.write(A_hex)
    f_input.write(B_hex)
    f_output.write(Y_hex)
    # print(A_hex)
    # print(B_hex)
    # print(Y_hex)

f_input.close()
f_output.close()