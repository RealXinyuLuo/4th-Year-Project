Hello 


//Version 1
Justin Ko's original code. 

//Version 2.1
//12 Nov,2021
//Xinyu Luo
Basic uniform quantizer

//Version 2.2
//23 Nov, 2021
//Xinyu Luo 
Huffman encoding is brought online. 
Neural network is fixed.

//Version 2.3
//12 Jan, 2022
//Xinyu Luo
Brought in 2D quantization.
Huffman encoding now supports datapoints of more than 500.

//Version 2.4
//7 Feb, 2022
//Xinyu Luo
Quantization now works together with neural network. 

//Version 2.5
//13 Feb, 2022
//Xinyu Luo
Quantization level now included in the feature vector of the neural network. 
New image generator function handles randomized SNR values.

//Version 2.5.1
//14 Feb, 2022
//Xinyu Luo
Quantization level now can be passed into the neural network.
Eliminated the use of global variable to set ground truth. 


//Version 2.6
//18 Feb, 2022
//Xinyu Luo
Combined an approximation of entropy and reconstruction. 
Quantization taken out of feature. 
Streamlined testing. 
Trained networks are now automatically stored in a variable. 
