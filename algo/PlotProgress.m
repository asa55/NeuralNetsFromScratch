function [] = PlotProgress(epoch, epoch_print_period, C, percent_accuracy)
%PLOTPROGRESS plots performance metrics on the training and test sets
%   The training cost can be measured easily in terms of the cost function
%   C, which in the case of classification (and in this submission) is the
%   cross entropy. The cost over the test set could be used for comparison,
%   but the bottom line of a classifier is whether or not it is correctly
%   classifying images from the test set. Thus, the performance over the
%   test set is measured by the percentage of images correctly classified
%   from the test set.

figure(2), set(gcf,'color','w')
subplot(2,1,1)
plot(C)
title("training error estimate (cross entropy on training set)")
xlabel("epoch")
ylabel("cross entropy")

subplot(2,1,2)
plot([epoch_print_period*(0:length(percent_accuracy(2:end))-2) epoch],...
    percent_accuracy(2:end))
title("classification accuracy on test set")
xlabel("epoch")
ylabel("percent accuracy")

end

