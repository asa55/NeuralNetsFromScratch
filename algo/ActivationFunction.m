function outputArgument = ...
    ActivationFunction(activation_inputs,return_derivative)
%ACTIVATIONFUNCTION calculates neuron activation using a sigmoidal function
% this function will return the activation or the derivative based on the
% argument return_derivative
if return_derivative
    outputArgument = activation_inputs.*(1-activation_inputs); % calculate derivative
else
    outputArgument = (1+exp(-activation_inputs)).^(-1);        % calculate sigmoidal activation
end
        
end

