function images = mixedimages(signal_number, signal_length,SNR)
%This function generates random 1d signals for analysis in this report
%   Signal Number: size of the training data set 
%   Signal Length: size of each training data 
%   SNR: Signal-to-Noise ratio of Gaussian noise added to the signal 

    images = zeros(signal_length,signal_number);  %Empty matrix to hold values
    for k = 1 : signal_number
        n = randi(7); 
        
        %sine wave
        if n == 1
            signal = randomsinewave(signal_length);
        end
        
        %pulse signal
        if n == 2
            signal = randompulsewave(signal_length);
        end
        
        %random noise
        if n == 3
            signal = rand(signal_length,1);
        end
        
        %squarewave
        if n == 4
            signal = randomsquarewave(signal_length);
        end
        
        %sawtooth
        if n == 5
            signal = randomsawtooth(signal_length);
        end
        
        %step
        if n == 6
            signal = randomstep(signal_length);
        end
        
        %ramp
        if n == 7
            signal = randomramp(signal_length);
        end
        
    signal = awgn(signal,SNR);  % Add Gaussian noise   
            
    signal = signal';    
    signal = normalize(signal,'range');    % Normalise between 0-1
    images(:,k) = signal;   %Store each inside the image_store
    end

end

