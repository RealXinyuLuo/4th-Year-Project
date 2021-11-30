function images = single_type_images(signal_number, signal_length,SNR,type)
%This function generates 1d signals of a designated type 
%Valid types are: sine, pulse, ramp, sawtooth, square, and step
%   Signal Number: size of the training data set 
%   Signal Length: size of each training data 
%   SNR: Signal-to-Noise ratio of Gaussian noise added to the signal 
%   type: designated signal type 

    %% Cell containing the valid types
    valid_types = {'sine','pulse','ramp','sawtooth','square','step'};

    %% Empty matrix to hold values
    images = zeros(signal_length,signal_number,1);  
    
    %% Function logic 
    % Sine wave 
    if strcmp(type,'sine')
        for k = 1 : signal_number
            signal = randomsinewave(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % Pulse wave
    elseif strcmp(type,'pulse')
        for k = 1 : signal_number
            signal = randompulsewave(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % Ramp wave
    elseif strcmp(type,'ramp')
        for k = 1 : signal_number
            signal = randomramp(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % Sawtooth wave
    elseif strcmp(type,'sawtooth')
        for k = 1 : signal_number
            signal = randomsawtooth(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % Square wave 
    elseif strcmp(type,'square')
        for k = 1 : signal_number
            signal = randomsquarewave(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % Step function
    elseif strcmp(type,'step')
        for k = 1 : signal_number
            signal = randomstep(signal_length);
            signal = awgn(signal,SNR);          
            signal = signal';    
            signal = normalize(signal,'range'); % Normalise between 0-1
            images(:,k) = signal;   %Store each inside the image_store
        end 
    % TypeErro message 
    else 
        fprintf('TypeError: Input type not valid. Only the following type inputs are allowed:\n')
        for i = 1:numel(valid_types)
            fprintf(' ')
            fprintf(valid_types{i})
        end
        fprintf('\n') 
    end 
end

