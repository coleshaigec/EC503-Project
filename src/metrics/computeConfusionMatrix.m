function confusionMatrix = computeConfusionMatrix(yHat, yTrue)
    % COMPUTECONFUSIONMATRIX Builds confusion matrix for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)  - predicted labels
    %  yTrue (n x 1 double) - true labels
    %
    % OUTPUTS
    %  confusionMatrix (confusion matrix)
    confusionMatrix = confusionmat(yHat, yTrue);
end