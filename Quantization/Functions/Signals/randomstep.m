function signal= randomstep(signal_length)
%Generates a normalized step function
%   signal_length: the length of the sawtooth wave to be generated

increment = 2*pi/signal_length;     % step size 
t = [0:increment:2*pi-increment];
steppoint = round(rand*2*pi);       % the point the step happens
amp = rand;                         % random amptitude

% Start with all zeros: 
unitstep = zeros(size(t)); 
% But make everything corresponding to t>=1 :
unitstep(t>=steppoint) = amp; 

signal = unitstep;
signal = signal';    

end

