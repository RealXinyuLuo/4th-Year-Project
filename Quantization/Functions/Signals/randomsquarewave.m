function signal = randomsquarewave(signal_length)
%Generates a normalized (of value 0-1) random square wave
%   signal_length: the length of the square wave to be generated

%square wave
increment = 2*pi/signal_length;      % step size 
t = [0:increment:2*pi-increment];
amp = randi(5);                      % random amptitude
freq = randi(3);                     % random frequency 
shift = randi(2);                    % random phase 
signal = amp*square(freq*t+shift);   % generate signal
signal = signal';                    % transpose
signal = normalize(signal,'range');  % normalise between 0-1
end

