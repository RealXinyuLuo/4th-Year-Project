clc
clear

signal_number = 3;
signal_length = 100;
SNR = 30;

type = 'sine';

images = single_type_images(signal_number,signal_length,SNR,type);


plot(images)

