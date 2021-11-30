function [signal,pulsepoint] = randompulsewave(signal_length)
%Generates a random pulse siganl 
%   signal_length: the length of the sine wave to be generated

%sine wave
increment = 2*pi/signal_length;             % step size 
t = [0:increment:2*pi-increment];
amp = randi(10);                            % random amplitdude
pulsepoint = 0;

while pulsepoint == 0                       % While loop to prevent pulsepoint = 0
    pulsepoint = round(rand*signal_length);          % the point the pulse happens
end 

signal = zeros(size(t));
signal(pulsepoint) = amp;

signal = signal';                           % transpose
signal = normalize(signal,'range');         % normalise between 0-1

end

