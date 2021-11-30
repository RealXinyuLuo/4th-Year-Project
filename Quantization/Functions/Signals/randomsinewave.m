function signal = randomsinewave(signal_length)
%Generates a normalized (of value 0-1) random sine wave
%   signal_length: the length of the sine wave to be generated

%sine wave
increment = 2*pi/signal_length;             % step size 
t = [0:increment:2*pi-increment];
amp = randi(10);                            % random amplitdude 
freq = randi(3);                            % random frequency 
shift = randi(10);                          % random phase 
signal = amp*sin(freq*t+shift);             % generate signal
signal = signal';                           % transpose
signal = normalize(signal,'range');         % normalise between 0-1
end

