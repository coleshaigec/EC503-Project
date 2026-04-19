function precision = computePrecision(yHat, yTrue)
    % COMPUTEPRECISION Computes precision for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUT
    %  precision (double)

    % -- Actual positives --
    actualPositives = (yTrue == 1);

    % -- Predicted positives --
    predictedPositives = (yHat == 1);

    % -- True positives --
    truePositives = predictedPositives & actualPositives;

    % -- Compute precision --
    numTruePositives = sum(truePositives);
    numPredictedPositives = sum(predictedPositives);

    % -- Handle edge case cleanly --
    if numPredictedPositives == 0
        precision = 0;
        return;
    end

    precision = numTruePositives / numPredictedPositives;
end