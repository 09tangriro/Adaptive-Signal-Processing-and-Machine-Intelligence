function [signalZeroAlphaBeta] = clarke(signalABC)

clarkeMat = sqrt(2/3) * [sqrt(1/2) sqrt(1/2) sqrt(1/2); 1 -1/2 -1/2; 0 sqrt(3/4) -sqrt(3/4)];
signalZeroAlphaBeta = clarkeMat * signalABC;
end

