function signal = randomramp(signal_length)  %NOT WORKING
%Generates a ramp signal
%   signal_length: the length of the sine wave to be generated


%ramp signal
signal = zeros(signal_length,1);
ramppoint = round(rand*signal_length);  % the signal length the ramp starts
increment = 2*pi/(signal_length-ramppoint);         % step size 


%t = [ramptime:increment:2*pi-increment];

for t =ramppoint:signal_length
    signal(t) = signal(t-1) + increment;
end 

signal = signal';
signal = normalize(signal,'range');
end

