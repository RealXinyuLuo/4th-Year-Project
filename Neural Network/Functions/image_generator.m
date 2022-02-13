function images = image_generator(sample_number,sample_length,SNR,type,isSNRuniform,issingletype)
%Generates a set of images allowing for variable SNR values and types
%   Inputs:
%      sample_number - the total number of image samples to be generated        
%      sample_length - the length of 1-D image samples to be generated
%      SNR - signal-to-noise ratio
%      type - single type image. Not used if issingletype = false
%      isSNRuniform - boolean flag, true if uniform SNR
%      issingletype - boolean flag, true if single type images
    images = zeros(sample_length,sample_number);
    
    if isSNRuniform && issingletype
        % if single type image of uniform SNR values
        images = single_type_images(sample_number, sample_length,SNR,type);
        fprintf('Images of type "%s" and SNR of "%d" are generated\n',type,SNR);
    elseif isSNRuniform && ~issingletype
        % if mixed image types of uniform SNR values
        images = mixedimages(sample_number, sample_length,SNR);
        fprintf('Mixed image types and SNR of "%d" are generated\n',SNR);
    elseif ~isSNRuniform && issingletype
        % if single type image of random SNR values
        for i = 1:sample_number
            SNR = randi([20,80]);  %random SNR values between 20db and 80db
            images(:,i)=single_type_images(1, sample_length,SNR,type);
        end
        fprintf('Images of type "%s" and randomized SNR values are generated\n',type);
    else
        % if mixed image types of random SNR values
        for i = 1:sample_number
            SNR = randi([20,80]);  %random SNR values between 20db and 80db
            images(:,i)=mixedimages(1, sample_length,SNR);
        end
        fprintf('Mixed image types and randomized SNR values are generated\n');
    end

end

