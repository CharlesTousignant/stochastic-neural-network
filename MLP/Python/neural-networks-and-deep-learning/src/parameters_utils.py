import math

def smallestPow(x):
    toReturn = []
    for max in x:
        toReturn.append(2**(math.ceil(math.log(max, 2))))
    return toReturn

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