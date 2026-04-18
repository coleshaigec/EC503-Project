function balancedAccuracy = computeBalancedAccuracy(yHat, yTrue, warningHorizon)
    % COMPUTEBALANCEDACCURACY Computes balanced accuracy for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUT
    %  balancedAccuracy (double)

    % -- Compute recall and specificity --
    recall = computeRecall(yHat, yTrue, warningHorizon);
    specificity = computeSpecificity(yHat, yTrue, warningHorizon);

    % -- Compute balanced accuracy --
    balancedAccuracy = (recall + specificity) / 2;
end