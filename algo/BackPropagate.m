function network = BackPropagate(network,gradC,eta,lambda)
%BACKPROPAGATE updates network parameters using backpropagation
% This function uses a network, cost information, a learning rate, and an
% L2 regularization parameter to backpropagate error through the network
% and return the network with updated weights and biases.

return_derivative = true; % this parameter is defined to clarify the intended use of ActivationFunction
sig2prime = ActivationFunction(network.a2,return_derivative); % calculate the derivative of the activation function of each node in the hidden layer
sig3prime = ActivationFunction(network.a3,return_derivative); % calculate the derivative of the activation function of each node in the output layer

network.delta2 = (network.w3)'*(gradC.*sig3prime).*sig2prime; % calculate error in the hidden layer
network.delta3 = gradC.*sig3prime;                            % calculate error in the output layer
    
network.b2 = network.b2 - eta*network.delta2;  % update biases in the hidden layer
network.b3 = network.b3 - eta*network.delta3;  % update biases in the output layer
network.w2 = (1-lambda)*network.w2 - eta*network.delta2*(network.a1)'; % update weights between the input layer and the hidden layer
network.w3 = (1-lambda)*network.w3 - eta*network.delta3*(network.a2)'; % update weights between the hidden layer and the output layer

end

