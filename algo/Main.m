%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% by Alexander S. Augenstein   %%%
%%% University of Pittsburgh     %%%
%%% ECE 2195, Fall 2018          %%%
%%% Final Project, due 12/10/18  %%%
%%% Dr. Heng Huang               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% these are all parameters you can adjust for an experiment. If the last
% experiment is still loaded into the workspace and you want to see it
% converge to a more accurate result, you can adjust the learning rate and
% pick up where you left off by running Main again.
% the only parameter you shouldn't change during an experiment is the epoch
% print period - some plotting functionality used depends on this assumption
eta = .035;                    % set the learning rate
lambda = .00001;                % set the L2 regularization weight
convergence_criteria = 0.02;
epoch_print_period = 1000;

% load dataset if needed (there is some input dimensionality reduction performed in this step)
if (exist('x','var') == 0) % import images if not already loaded into workspace.
x = LoadData();            % takes <2min but only needs to be done once unless you clear x manually
end

if (exist('network','var') == 0)
    % split the training from the test data and define the ideal output layer 
    % activations for all inputs in both training and test sets
    training = TRAIN();    % if we want to pick up in the middle of a
    test = TEST(training); % stopped experiment, we don't want to randomly
    truth = TRUTH();       % split the test and training sets again

    % define the structure of the neural net
    network = InitializeNetwork(size(x,1),100,62);
    C = 1;                 % cost estimate initialization
    epoch = 1;             % these are only initialized if you're not in 
    percent_accuracy = 0;  % the middle of a stopped experiment

end
% implement backpropagation using SGD. The cost on the training set correlates with the accuracy on the training set, but given that we're using L2 regularization, it is expected that this classifier will generalize well to the test set.
while (C(end)>convergence_criteria)  % the convergence criterion is set using the training cost, because (1) it correlates with the training accuracy yet less expensive to estimate, and (2) even though test accuracy is what we really want to improve, it's not fair to use test accuracy as a convergence metric since the test data needs to be used independently from the training phase
    try
        C_ = C(epoch);          % this is a temp varable used for cost estimate smoothing
        epoch = epoch+1;
    catch
        epoch = epoch-1;
        C_ = C(epoch);        % this protects against a potential out of bounds error in the case when the experiment is terminated manually then started again using Main, between this line and when C(epoch) is updated
    end
    
    index_ = randi(50*62);                             % index_ is used to randomly select a single training vector for backpropagation (since this code uses SGD to update the weights as opposed to minibatch, we only need one sample). Also, this design choice is one of a few methods used to help avoid getting stuck in local minima.
    y = truth(:,training(index_));
    network = ForwardPropagate(network,...
        reshape(imrotate((reshape(x(:,training(index_)),38,38))...
        ,randi(30)-15,'bilinear','crop'),38*38,1));    % The image preprocessing that was done when the images were first loaded took care of compensating for translation and scale, but to make the network generalize well to small rotations, this line of code reconstructs an image, rotates it up to 15 degrees in either direction, then reshapes it back into a feature vector for use in backpropagation. This is convenient trick didn't impact code elsewhere, and effectively serves to increase the effective size of our training set.
        
    [C(epoch), gradC] = CostSurface(network,y);   
    C(epoch) = .99*C_ + .01*C(epoch);                  % this is a weighted average filter with forgeting factor. The cost calculated in the line above is only true for one training sample, but the true cost is expensive to calculate (forward propagate entire training set of 50*62 images), so this estimate gets us close enough at an overhead of only a few simple operations per iteration. The performance impact for this filter is negligable compared to alternative implementations. 
    
    network = BackPropagate(network,gradC,eta,lambda); % update network weights using backpropagation
            
    if mod(epoch,epoch_print_period)==1                % printing and plotting can be a performance bottleneck, but the information is useful so the updates are less frequent
        percent_accuracy = [percent_accuracy PlotConfusionMat(network,x,truth,test,1)]; 
        [ "The cost at epoch " + num2str(epoch) + " is " + num2str(C(epoch)) + " and " + num2str(percent_accuracy(end)) + "% classification accuracy" ] % This is printed to the workspace so you can get a sense of how close the algorithm is to the convergence criteria        
    end
end

["The simulation terminated at a training cost of " + num2str(C(end)) ; "which is less than the convergence threshold of " + num2str(convergence_criteria) ; "The classification accuracy on the test set is " + num2str(percent_accuracy(end)) + "%" ]
percent_accuracy_ = [percent_accuracy PlotConfusionMat(network,x,truth,test,1)]; % the new variable is defined so that the simulation can be picked up after manually stopping without impacting the functionality of PlotProgress. We want to know the percent accuracy when the convergence criteria has been met, but appending more than one entry at an interval that is not at a uniform interval conflicts with an assumption made by PlotProgress.
PlotProgress(epoch, epoch_print_period, C, percent_accuracy_)   % this plots the training cost and the test accuracy in a single subplot

