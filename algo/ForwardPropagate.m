function network = ForwardPropagate(network,x)
%FORWARDPROPAGATE Determines the network outputs for all given input samples
%   Inputs are applied to the input nodes then propagated through the
%   network to determine the activations due to these inputs in each layer.
%   The network is updated to reflect the outputs given the input(s) in x,
%   which can contain one or many samples

% Multiple images are handled with permute() instead of the transpose,
% because Matlab only defines the transpose for 2 dimensional matrices (but
% the code below aligns multiple samples across dimension 3)
network.a1 = permute(x,[1,3,2]);
network.z2 = sum(network.w2.*permute(network.a1,[2,1,3]),2)... % If you think about how this acts for a single sample, you'll see it basically calculates W*x, where x is a column vector. The way I did it, I calculate a bunch of these by stacking the operations along dimension 3
    +repmat(network.b2,1,1,size(x,2));  % since there is a W*x calculation in each layer of dimension 3, this line repeats the same exact bias vector along dimension 3 so that the add function is defined. Matlab doesn't know what to do if you don't stack the same b along dim3, so this basically calculates W*x+b in each layer of dim3.
network.a2 = ActivationFunction(network.z2,0);  % this is an elementwise operation, so we have no problems calculating this
network.z3 = sum(network.w3.*permute(network.a2,[2,1,3]),2)... % we do the whole process over again as outlined above for the output layer instead of the hidden layer
    +repmat(network.b3,1,1,size(x,2));
network.a3 = ActivationFunction(network.z3,0); % the network output a3 is a column vector for a single input but column vectors stacked along dim3 in the case of multiple inputs. The network is updated with this info and returned

end

