function balancedAccuracy = computeBalancedAccuracy(yHat, yTrue)
    % COMPUTEBALANCEDACCURACY Computes balanced accuracy for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %
    % OUTPUT
    %  balancedAccuracy (double)

    % -- Compute recall and specificity --
    recall = computeRecall(yHat, yTrue);
    specificity = computeSpecificity(yHat, yTrue);

    % -- Compute balanced accuracy --
    balancedAccuracy = (recall + specificity) / 2;
end