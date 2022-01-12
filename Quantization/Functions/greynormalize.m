function [normalized_signal] = greynormalize(grey_signal)
%Normalize the input grey-scaled image signal to be values between 0 and 1
%   grey_signal: input grey scale signal [0,255]
%   normalized_signal: output [0,1]

signal_length =  length(grey_signal);
normalized_signal= zeros(1,signal_length,"double");


for i = 1:signal_length
    % convert signal from uint8 to double
    normalized_signal(i) = double(grey_signal(i))/255;
end

end

