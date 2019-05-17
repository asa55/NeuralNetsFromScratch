function [C,gradC] = CostSurface(network,y)
%COSTSURFACE Determines cross entropy cost and the gradient at that location
% We are using the method of gradient descent. The information we have
% about the surface we want to descend is quantified by the cost at a point 
% and its local gradient, and this function was named to capture the fact 
% that it calculates what we know about our cost surface

C = -mean((y.*log(network.a3)+(1-y).*log(1-network.a3)),1);
gradC = (network.a3 - y)./(network.a3.*(1-network.a3)); 

end

