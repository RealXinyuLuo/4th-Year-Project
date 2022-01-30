function signal = randomramp(signal_length)  %NOT WORKING
%Generates a ramp signal
%   signal_length: the length of the sine wave to be generated


%ramp signal
signal = zeros(signal_length,1);
ramppoint = round(rand*signal_length);  % the signal length the ramp starts
increment = 2*pi/(signal_length-ramppoint);         % step size 


for i = ramppoint:signal_length
    if i == 1
        signal(i) = 0 + increment;      % Added to avoid indexing error
    elseif i > 1
        signal(i) = signal(i-1) + increment;
    else
        signal(i) = 0;                  % Added to avoid indexing error
    end
end 

signal = signal';
signal = normalize(signal,'range');
end

