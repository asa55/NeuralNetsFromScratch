function percent_accuracy = PlotConfusionMat(network,x,truth,test,plot_)
%PLOTCONFUSIONMAT plots the confusion matrix over the test images
% The confusion matrix is for visualization purposes only - it is a color
% chart of classification outputs versus their true outputs. The classifier
% is imperfect and will sometimes classify a test image as something other
% than the true class. The confusion matrix starts as a matrix of all zeros,
% and adds +1 to the (truth, classifier output) entry for every input in
% the test set. So the max score is 5 (shown as a yellow box) and the min 
% score is 0 (shown as a dark blue box), and if the classifier was 100%
% accurate we'd expect to see a yellow line emerge along the main diagonal,
% because this would imply the classifier selected the correct output for
% every input in the test set. When you run Main, by default you will see
% this plot update every 1000 epochs, and you'll see this pattern start to
% emerge along the main diagonal. You can turn the plotting functionality
% off by setting plot_ to 0, and the function will simply return the
% percent accuracy of the classifier over the entire test set.

network = ForwardPropagate(network,x(:,test));
[~,reshaped_truth] = (maxk(truth(:,1,test),1,1));
[~,reshaped_outputs] = (maxk(network.a3,1,1));
confusion_dat = confusionmat(reshape(reshaped_outputs,size(reshaped_outputs,3),1,1),reshape(reshaped_truth,size(reshaped_truth,3),1,1));
if plot_
    figure(1), set(gcf,'color','w')
    b = bar3(confusion_dat);
    title("confusion matrix")
    xlabel('truth')
    ylabel('output')
    for k = 1:length(b)
        zdata = b(k).ZData;
        b(k).CData = zdata;
        b(k).FaceColor = 'interp';
    end
    colorbar   % uncomment this if you want to see what color corresponds to what value
    view(2) % there is a function that plots the confusion matrix in Matlab 2018b, but to eliminate the version dependency I used bar3 instead. It does basically the same job when you use view(2), which renders a top-down view of the 3d chart making it appear similar to what you'd see with plotconfusion().
    xlim([0.5,62.5])
    ylim([0.5,62.5])
end

percent_accuracy = 100*sum(diag(confusion_dat))/(sum(sum(confusion_dat))); % if the entries aren't along the main diagonal, they were classified incorrectly. So we can take the sum along the diagonal and divide by all entries to get the classification accuracy. I multiply by 100 so you can see it displayed as a percentage on a 0 to 100 scale.

end

