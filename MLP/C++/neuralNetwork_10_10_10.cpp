#include <math.h>
#include <cstdint>
#include <iostream>
#include <random>
#include <fstream>
#include <bitset>

#define numInputs 10
#define numNeuronsLayer1 10
#define numOutputNeurons 10


const uint32_t randomInputs[10][numInputs] = 
{  { 0x7356b1bb , 0xb872426d , 0x1575515d , 0xe99eadb3 , 0x3a9e3c0f , 0x8168599c , 0xe9d07a32 , 0x8eeab382 , 0x27023ee8 , 0x80d10fac } , { 0xd368bdc2 , 0x7664b5a7 , 0x89d0cf46 , 0x8bed7368 , 0xff02af49 , 0x7294e430 , 0x14034fbb , 0xdabd4cc4 , 0x71535cf8 , 0x9aaeea20 } , { 0x1b4d989d , 0x7fa09780 , 0xf63ef3d2 , 0xfadc6788 , 0x012fb568 , 0x08c904fa , 0xc660883f , 0xfa1cce2a , 0xd13ac8b8 , 0x5cf9c9b3 } , { 0xde62c6bd , 0xadf500ad , 0x159d967e , 0x58a2c06c , 0x665827cb , 0xdb1aa208 , 0x4286ddf1 , 0x0b8905b4 , 0xccd149a4 , 0xa8fd9757 } , { 0x6e7122f0 , 0xbffc21b1 , 0xe9203368 , 0x220c0724 , 0x2e8d86cb , 0xfb7bfb5e , 0x43889687 , 0x1869325b , 0x25420afc , 0x485d46db } , { 0x22d56381 , 0xcd572d60 , 0xde89ef2b , 0x13dac708 , 0x9467851d , 0xa09c428d , 0x8cc3a36c , 0x0212714e , 0x251bc1f6 , 0xae274af0 } , { 0xda603f48 , 0x88afd714 , 0x9f3f014d , 0x704c7830 , 0x59d803fb , 0x3315c9dc , 0x83645273 , 0x23540e0e , 0x66dce437 , 0x61e09244 } , { 0x13728d90 , 0xc32e0a94 , 0x3d6b2529 , 0x0a5c5094 , 0x1f91d464 , 0x40c1b904 , 0x2f1494b9 , 0x8138ac02 , 0x3d6d8755 , 0xd2963cf5 } , { 0x6ad203b6 , 0xfb5234e0 , 0x0cb62703 , 0xd2cdf95b , 0xe718672d , 0x4d448df1 , 0xf1dd92d7 , 0x0c4613a1 , 0x7da944f1 , 0x3f72f0c3 } , { 0x7d3fa930 , 0x8b4742bc , 0x5674c771 , 0xe3420514 , 0xe669edd5 , 0x5805de29 , 0x5e86f504 , 0x088449f4 , 0x1c77c8a0 , 0x29b1fccc }};

const uint32_t scalesHiddenLayer1[numNeuronsLayer1] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};
const uint32_t scalesOutputLayer[numNeuronsLayer1] = {
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

const uint32_t hiddenLayer1Weights[numNeuronsLayer1][numInputs] = 
{  { 0xd091bb5c , 0x22ae9ef6 , 0xe7e1faee , 0xd5c31f79 , 0x2082352c , 0xf807b7df , 0xe9d30005 , 0x3895afe1 , 0xa1e24bba , 0x4ee4092b } ,  { 0x18f86863 , 0x8c16a625 , 0x474ba8c4 , 0x3039cd1a , 0x8c006d5f , 0xfe2d7810 , 0xf51f2ae7 , 0xff1816e4 , 0xf702ef59 , 0xf7badafa } ,  { 0x285954a1 , 0xb9d09511 , 0xf878c4b3 , 0xfb2a0137 , 0xf508e4aa , 0x1c1fe652 , 0x7c419418 , 0xcc50aa59 , 0xccdf2e5c , 0x4c0a1f3b } ,  { 0x2452a9dc , 0x1397d8d , 0x6bf88c31 , 0x1cca797a , 0xea6da4ae , 0xa3c78807 , 0xcace1969 , 0xe0e0d4ad , 0xf5a14bab , 0x80f00988 } ,  { 0xa7de9f4c , 0xcc450cba , 0x924668f , 0x5c7dc380 , 0xd96089c5 , 0x3640ac4c , 0xef1a2e6d , 0xae6d9426 , 0xadc1965b , 0x6613ba46 } ,  { 0xc1fb41c2 , 0xbd9b0ecd , 0xbe3dedfc , 0x7989c8ee , 0x6468fd6e , 0x6c0df032 , 0xa7cd6634 , 0x2c826d8b , 0x2bd2e412 , 0x4d4a2dbe } ,  { 0xb4bf6fa7 , 0xcc1a8959 , 0x8263282 , 0x51097330 , 0x46e46cb0 , 0xdf577ec2 , 0xbd1e364 , 0x262c5564 , 0x18dda0c9 , 0xfe7b45d9 } ,  { 0xd2ce21c9 , 0xd268409a , 0xb1e049e1 , 0x200bfa47 , 0x512d6e73 , 0xc3851eee , 0xf341c081 , 0x7d973e48 , 0x8d17554 , 0xa9e20d28 } ,  { 0x70518ce6 , 0x203ac303 , 0x61add0ab , 0x35d0430c , 0xc3f8e892 , 0xd1c8509 , 0xcb92388e , 0x95436bf , 0x2fd6e208 , 0x68a29af9 } ,  { 0x7d61330b , 0x753ec6fc , 0x7211efea , 0x7cd15133 , 0xa574c4ff , 0xcb41f198 , 0xb598eef6 , 0xebbe7347 , 0xc1332568 , 0xceba5a70   }  };

const uint32_t hiddenLayerBiases[numNeuronsLayer1] = 
{ 0x46a99459 , 0xb4ad9f11 , 0xae00feaa , 0xb8b573 , 0xa7b480b6 , 0xb5f0b06c , 0x29a0ec27 , 0xa4daa010 , 0x1e76a1c5 , 0x74be9133 };
    
    
    
    
const uint32_t outputWeights[numOutputNeurons][numNeuronsLayer1] =
{  { 0x7f94c950 , 0xc61f6ed6 , 0xf5b1c7a1 , 0x92e195f8 , 0x572384d4 , 0xe0732c88 , 0x95d41b68 , 0xcee496c3 , 0x394bbd52 , 0x48cd47c } ,  { 0xc05309be , 0xd23d2d63 , 0x414de9c5 , 0xd2229f23 , 0x818666a3 , 0xf0a8b109 , 0xb2f6b127 , 0x69a48341 , 0xe4123c56 , 0x6c548c8f } ,  { 0xf5941f61 , 0x94b993aa , 0x8c165134 , 0x2876763c , 0x237ce42e , 0xc300d11b , 0x263821ca , 0x3aeb8202 , 0x41ec0f84 , 0xcf4ac36d } ,  { 0xd7393ee6 , 0xfd0fc06a , 0x4118a30a , 0x551b54a4 , 0xd074f86f , 0x4cc1c54a , 0x3e57a703 , 0x3774cda , 0xede43895 , 0x379ce627 } ,  { 0x59988939 , 0xe8490ddc , 0x325410e1 , 0xd9352f6a , 0x4047080a , 0xf47c081d , 0x9db51a85 , 0xc765d71f , 0x79297527 , 0xfcca2773 } ,  { 0x5a065b97 , 0x114dee4f , 0xd4b12f5f , 0xcb29360a , 0x95d3de16 , 0x983162a8 , 0x8cbaafb3 , 0xbb98b27f , 0xeacd3439 , 0xb1fac842 } ,  { 0x492cbef1 , 0xae08ab78 , 0xc1d7dfd0 , 0x646f1d40 , 0xc0f463c4 , 0x8fc23a81 , 0x6164e623 , 0x3543f2bc , 0x915cc253 , 0x8701d0df } ,  { 0x136b2fdd , 0x677a359e , 0xdcfacd0 , 0x5a4ea31e , 0x87e25935 , 0x97c34e42 , 0xc77780f0 , 0x5b396fba , 0xef1b52e6 , 0xf7080941 } ,  { 0x2141888b , 0x278946b0 , 0x919e6d64 , 0x6518b459 , 0x7829fc22 , 0x6325d30e , 0x30c0399 , 0xba19b463 , 0x564dab75 , 0x63794f97 } ,  { 0x2984c787 , 0xed702bbe , 0xcb563b4d , 0x6fa56696 , 0x4fabc9ed , 0xdcd87a48 , 0x874df295 , 0x9ecfe9f0 , 0x2a67f49f , 0x1e9aa4e1 }  };

const uint32_t outputLayerBiases[numOutputNeurons] = 
    { 0x9a1b7d08 , 0x78d22934 , 0x43521602 , 0x5718a361 , 0xa771ba44 , 0x87a3b97c , 0xb0705c82 , 0xb7526048 , 0xbf86dcd7 , 0xfd066ea4 };


uint32_t bipolarStochasticToBin(float bipolar){
    return (uint32_t((bipolar + 1) / 2 * UINT32_MAX));
}


float sigmoidalFunction(float input) {
    return 0.5 * float(1.0f + tanh(input));
}

float binToBipolarStochastic(uint32_t binary){
    return (float(binary) / float(UINT32_MAX)) * 2 - 1;
}

float binToBipolarStochasticScaled(uint32_t binary, int scale){
    return binToBipolarStochastic (bipolarStochasticToBin ( binToBipolarStochastic(binary) / scale ));
}

struct inputs {
    int hexInputs[numInputs];
};


struct outputs {
    float floatOutputs[numOutputNeurons];
};

outputs runNetwork(const uint32_t input[numInputs]) {
    float currSum;
    outputs toReturn;
	
    float inputActivations[numInputs];	

	for (int i = 0; i < numInputs; i++){
		inputActivations[i] = binToBipolarStochastic(input[i]);
	}

    float hiddenLayer1Activation[numNeuronsLayer1];
    for (int i = 0; i < numNeuronsLayer1; i++) {
        currSum = 0;
        for (int j = 0; j < numInputs; j++) {
            currSum += (inputActivations[j]) * binToBipolarStochastic (hiddenLayer1Weights[i][j]);
        }
        currSum += binToBipolarStochastic(hiddenLayerBiases[i]);
        hiddenLayer1Activation[i] = sigmoidalFunction(currSum * scalesHiddenLayer1[i]);
    }


    for (int i = 0; i < numOutputNeurons; i++) {
        currSum = 0;
        for (int j = 0; j < numNeuronsLayer1; j++) {
            currSum += hiddenLayer1Activation[j] * binToBipolarStochastic(outputWeights[i][j]);
        }
        currSum += binToBipolarStochastic(outputLayerBiases[i]);
        toReturn.floatOutputs[i] = sigmoidalFunction(currSum * scalesOutputLayer[i]);
    }

   return toReturn;
};
void saveParams(float scale){
    std::ofstream resultsFile;
    resultsFile.open("parametersScaled.csv");
    resultsFile << "(";
    for(int i = 0; i < numNeuronsLayer1; i++){
        resultsFile << "(";
        for(int j = 0; j < numInputs; j++){
            resultsFile << "x\"" << std::hex << bipolarStochasticToBin ( binToBipolarStochastic(hiddenLayer1Weights[i][j]) / scale) ;
            resultsFile << "\",";
        }
        resultsFile << ")\n,";
    }
    resultsFile << ")";

    resultsFile << "(";
    for(int i = 0; i < numNeuronsLayer1; i++){
        resultsFile << "x\"" << std::hex << bipolarStochasticToBin ( binToBipolarStochastic(hiddenLayerBiases[i]) / scale);
        resultsFile << "\",";
    }
    resultsFile << ")\n";

    resultsFile << "(";
    for(int i = 0; i < numOutputNeurons; i++){
        resultsFile << "(";
        for(int j = 0; j < numNeuronsLayer1; j++){
            resultsFile << "x\"" <<  std::hex  << bipolarStochasticToBin ( binToBipolarStochastic(outputWeights[i][j]) / scale);
            resultsFile << "\",";

        }
        resultsFile << ")\n,";
    }
    resultsFile << ")";

    resultsFile << "(";
    for(int i = 0; i < numOutputNeurons; i++){
        resultsFile << "x\"" << std::hex << bipolarStochasticToBin ( binToBipolarStochastic(outputLayerBiases[i]) / scale);
        resultsFile << "\",";
    }
    resultsFile << ")\n";
    resultsFile.close();

}

int main(){
    // std::ofstream resultsFile;
    // resultsFile.open("multiplicationTests.csv");
    // for(int i = 0; i < 16 * 16; i ++){
    //     float input = binToBipolarStochastic(i * 0x01000000);
    //     resultsFile << input * input << "\n";
    // }
    // resultsFile.close();


    saveParams(4.f);
    // auto result =  runNetwork((0xff00 << 16) | 0xff00);
    // std::cout << result.output1 << ',' << result.output2 << '\n';
    std::ofstream resultsFile;
    resultsFile.open("NeuralNetResults.csv");
    for(int i = 0; i < 16; i++){
        outputs results = runNetwork(randomInputs[i]);
        for(auto result: results.floatOutputs){
            resultsFile << result << ",";
        }
        resultsFile << "\n";
    }
    resultsFile.close();
};