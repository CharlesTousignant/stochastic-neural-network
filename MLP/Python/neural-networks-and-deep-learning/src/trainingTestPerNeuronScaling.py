import mnist_loader
import network
import numpy as np
import parameters_utils
training_data, validation_data, test_data = mnist_loader.load_data_wrapper_smaller()


net = network.Network([15*15, 10, 10])
net.SGD(training_data, 30, 10, 3.0, test_data=test_data)

test_data_hex = []
test_label = []
for i in range(10):
    test_data_hex.append('(' +  ','.join(map(parameters_utils.floatToBinaryUnipolar, test_data[i][0])) + ')')
    test_label.append(str(test_data[i][1]))
    print(net.feedforward(test_data[i][0]))
    print(test_data[i][1])


# Scale weights and biases to be between -1 and 1
layer1WeightsScaled = []
layer1BiasesScaled = []
layer2WeightsScaled = []
layer2BiasesScaled = []

layer1WeightMaximums = abs(net.weights[0]).max(axis=1)
layer1Maximums = np.maximum(layer1WeightMaximums, abs(net.biases[0].flatten()))
layer1Scales = parameters_utils.smallestPow(layer1Maximums)

layer2WeightMaximums = abs(net.weights[1]).max(axis=1)
layer2Maximums = np.maximum(layer2WeightMaximums, abs(net.biases[1].flatten()))
layer2Scales = parameters_utils.smallestPow(layer2Maximums)

for (i, scale) in enumerate(layer1Scales):
    layer1BiasesScaled.append(float(net.biases[0][i] / scale))
    layer1WeightsScaled.append( net.weights[0][i] / scale)

for (i, scale) in enumerate(layer2Scales):
    layer2BiasesScaled.append(float(net.biases[1][i] / scale))
    layer2WeightsScaled.append(net.weights[1][i] / scale)

# print all the weights and biases
# print("layer1Weights:")
# print(layer1WeightsScaled)
# print("layer1Biases:")
# print(layer1BiasesScaled)
# print("layer2Weights:")
# print(layer2WeightsScaled)
# print("layer2Biases:")
# print(layer2BiasesScaled)

# Convert the weight and biases to a 32 bit Hex string

weights0StrArr = []
for neuronWeights, index in zip(layer1WeightsScaled, range(len(net.weights[0]))):
    weights0Hex = map(parameters_utils.floatToBinary, neuronWeights)
    weights0StrArr.append( ",".join(weights0Hex) )
weights0OneStr = "),(".join(weights0StrArr)

weights1StrArr = []
for neuronWeights, index in zip(layer2WeightsScaled, range(len(net.weights[1]))):
    weights1Hex = map(parameters_utils.floatToBinary, neuronWeights)
    weights1StrArr.append( ",".join(weights1Hex) )
weights1OneStr = "),(".join(weights1StrArr)


biases0 = map(parameters_utils.floatToBinary, layer1BiasesScaled)
biases1 = map(parameters_utils.floatToBinary, layer2BiasesScaled)


# test_data_hex = map(floatToBinary, test_data[1][0])

# test_data_hex.append('(' +  ','.join(map(floatToBinary, test_data[9][0])) + ')')



params = {
    'layer1Scale':  str(layer1Scales),
    'layer2Scale': str(layer2Scales),
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

