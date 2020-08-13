% returns the bit number which needs to be used to express a number
% e.g to express 7,  111 --> 3 bits are required.
% e.g to express 8, 1000 --> 4 bits are required.

function bits = kpt_bitnum(number)
    bits = 0;    
    while number > 0
        number = number - 2^bits;
        bits = bits + 1;
    end
end