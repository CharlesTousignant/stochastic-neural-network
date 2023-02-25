#include <stdio.h>
#include <iostream>
#include <bitset>
#include <fstream>
#include <ios>
#include <iomanip>
#include <random>
#include <cmath>

#define N 16

uint32_t s1 = 0x12345678;
uint32_t s2 = 0x23456789;
uint32_t s3 = 0x3456789a;
uint32_t b = 0;


uint32_t taus88 ()
{ /* Generates numbers between 0 and 0xFFFFFFFF */
    b = (((s1 << 13) ^ s1) >> 19);
    s1 = (((s1 & 4294967294) << 12) ^ b);
    b = (((s2 << 2) ^ s2) >> 25);
    s2 = (((s2 & 4294967288) << 4) ^ b);
    b = (((s3 << 3) ^ s3) >> 11);
    s3 = (((s3 & 4294967280) << 17) ^ b);
    return (s1 ^ s2 ^ s3);
}

bool BinaryToStochastic(uint16_t binary){
    uint16_t binary2 = taus88() >> 16;
    std::cout << "stochastic stream: " << ( binary > binary2) << "\n";
    return ( binary > binary2);
}

float BinaryBipolarToFloat(unsigned binary){
    return (float(binary) / float(0xFFFF)) * 2.0f - 1.0f;
}

uint32_t STanh(uint16_t binaryX){
    uint32_t count = 0;
    uint32_t binaryRes = 0;
    unsigned state = 8;
    bool inputStochasticStream;
    uint32_t testCount = 0;
    while(count < pow(2, 16)){
        inputStochasticStream = BinaryToStochastic(binaryX);
        if(inputStochasticStream){
            if(state != N-1){
                state++;
            }
            testCount++;
        }
        else{
            if(state != 0){
                state--;
            }
        }
        binaryRes += (state >= N/2 ? 1 : 0);
        count++;
    }
    return binaryRes;
}


int main() {
    std::ofstream resultsFile;
    resultsFile.open("resultsSTanhNew.csv");
    for(int i = 0; i <= 0xFFFF; i++){
        uint32_t result = STanh(i);
        resultsFile << result << ",";
    }
    resultsFile << "\n";
    for(int i = 0; i <= 0xFFFF; i++){
        uint32_t result = STanh(i);
        resultsFile << result << ",";
    }
    resultsFile.close();
}