function [grey_signal] = greydenormalize(normalized_signal)
%Denormalize the input normalized signal back into grey scale data
%   normalized_signal: output [0,1]
%   grey_signal: input grey scale signal [0,255]


signal_length =  length(normalized_signal);
grey_signal= zeros(1,signal_length);

for i = 1:signal_length
    % convert signal from double to uint8
    grey_signal(i) = uint8(normalized_signal(i)*255);
end

end