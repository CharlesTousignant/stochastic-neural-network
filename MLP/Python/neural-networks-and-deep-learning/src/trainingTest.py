import mnist_loader
import network
import json
import math
import numpy as np
import struct

def smallestPow(x):
    return 2**(math.ceil(math.log(x, 2)))

def padded_hex(i, l):
    given_int = i
    given_len = l

    hex_result = hex(given_int)[2:].replace('L', '') # remove '0x' from beginning of str
    num_hex_chars = len(hex_result)
    extra_zeros = '0' * (given_len - num_hex_chars) # may not get used..

    return ('0x' + hex_result if num_hex_chars == given_len else
            '?' * given_len if num_hex_chars > given_len else
            '0x' + extra_zeros + hex_result if num_hex_chars < given_len else
            None)

def floatToBinary(x):
    zeroToOne = (x + 1) * 0.5
    zeroToMax = zeroToOne * (2**(32) - 1)
    result = int(zeroToMax)
    paddedHex = padded_hex(result, 8)
    if(paddedHex[0] == "?"):
        print("Error: floatToBinary():" + str(result) + "from" + str(x))
    return paddedHex[1] + '"' + paddedHex[2:] + '"'

def floatToBinaryUnipolar(x):
    zeroToOne = x
    zeroToMax = zeroToOne * (2**(32) - 1)
    result = int(zeroToMax)
    paddedHex = padded_hex(result, 8)
    if(paddedHex[0] == "?"):
        print("Error: floatToBinary():" + str(result) + "from" + str(x))
    return paddedHex[1] + '"' + paddedHex[2:] + '"'

training_data, validation_data, test_data = mnist_loader.load_data_wrapper() 

net = network.Network([784, 10, 10])
net.SGD(training_data, 1, 10, 3.0, test_data=test_data)



# Scale weights and biases to be between -1 and 1
maxBias1 = abs(net.biases[0]).max()
maxWeight1 = abs(net.weights[0]).max()

maxLayer1 = max(maxBias1, maxWeight1)
layer1Scale = smallestPow(maxLayer1)

maxBias2 = abs(net.biases[1]).max()
maxWeight2 = abs(net.weights[1]).max()

maxLayer2 = max(maxBias2, maxWeight2)
layer2Scale = smallestPow(maxLayer2)


net.biases[0] = net.biases[0] / layer1Scale
net.weights[0] = net.weights[0] / layer1Scale

net.biases[1] = net.biases[1] / layer2Scale
net.weights[1] = net.weights[1] / layer2Scale

# Convert the weight and biases to a 32 bit Hex string

weights0StrArr = []
for neuronWeights, index in zip(net.weights[0], range(len(net.weights[0]))):
    weights0Hex = map(floatToBinary, neuronWeights)
    weights0StrArr.append( ",".join(weights0Hex) )
weights0OneStr = "),(".join(weights0StrArr)

weights1StrArr = []
for neuronWeights, index in zip(net.weights[1], range(len(net.weights[1]))):
    weights1Hex = map(floatToBinary, neuronWeights)
    weights1StrArr.append( ",".join(weights1Hex) )
weights1OneStr = "),(".join(weights1StrArr)


biases0 = map(floatToBinary, net.biases[0])
biases1 = map(floatToBinary, net.biases[1])

test_data_hex = []
test_label = []
for i in range(0, 9):
     test_data_hex.append('(' +  ','.join(map(floatToBinaryUnipolar, test_data[i][0])) + ')')
     test_label.append(str(test_data[i][1]))
# test_data_hex = map(floatToBinary, test_data[1][0])

# test_data_hex.append('(' +  ','.join(map(floatToBinary, test_data[9][0])) + ')')

print(net.feedforward(test_data[9][0]))
print(test_data[9][1])

params = {
    'layer1Scale': str(layer1Scale),
    'layer2Scale': str(layer2Scale),
    'biases0' : '(' + ','.join(biases0) + ')',
    'weights0' :'(' + weights0OneStr + ')',
    'biases1' : '(' + ','.join(biases1) + ')',
    'weights1' :'(' + weights1OneStr + ')',
    'test_data': '(' + ','.join(test_data_hex	) + ')',
    'test_data_labels': '(' + ','.join(test_label) + ')'
}


with open('parameters.txt', 'w') as f:
    for (key, value) in params.items():
        f.write(key + '=' + value + '\n')

print('DONE')

