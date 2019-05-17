function network = InitializeNetwork(input_nodes,hidden_nodes,output_nodes)
%INITIALIZENETWORK initializes a neural network with the specified layer sizes
% This initializes the weights randomly in [-1,1] and sets biases to 1.
% Errors are also initialized so that the size is well defined 
% as needed in the first epoch of backpropagation.
% The number of hidden layers is static and set to 1, but the number of
% nodes in the hidden layer can be freely adjusted.

if (exist('network','var') == 0) % import images if not already loaded into workspace.
% initialize some network parameters
network = [];
network.delta2 = zeros(hidden_nodes,1);
network.delta3 = zeros(output_nodes,1);

% initialize weights with small random numbers between 0 and 1. there are other common ways to initialize the weights but this works well in this assignment
network.w2 = 2*rand(hidden_nodes,input_nodes)-1;
network.w3 = 2*rand(output_nodes,hidden_nodes)-1;
network.b2 = ones(hidden_nodes,1);
network.b3 = ones(output_nodes,1);
end

end

