% calculates the maximum number which can be written
% with the given bit number
% example: with 3 bits: --> 111 --> 7

function maxnum = kpt_bit2max(bitnum)
    bitnum = bitnum - 1; maxnum = 0;
    for i = 0:bitnum
        maxnum = maxnum + 2^i;
    end
end