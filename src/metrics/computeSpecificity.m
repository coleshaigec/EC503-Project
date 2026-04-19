function specificity = computeSpecificity(yHat, yTrue)
    % COMPUTESPECIFICITY Computes specificity for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUT
    %  specificity (double)

    % specificity = TN / (TN + FP)

    % -- Actual negatives --
    actualNegatives = yTrue == -1;
    
    % -- Handle edge case cleanly --
    numActualNegatives = sum(actualNegatives);
    if numActualNegatives == 0
        specificity = 0;
        return;
    end

    % -- Predicted negatives --
    predictedNegatives = yHat == -1;

    % -- True negatives --
    trueNegatives = actualNegatives & predictedNegatives;
    numTrueNegatives = sum(trueNegatives);

    % -- Compute specificity --
    specificity = numTrueNegatives / numActualNegatives;
end