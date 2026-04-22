function recall = computeRecall(yHat, yTrue)
    % COMPUTERECALL Computes recall for classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUT
    %  recall (double)

    % -- Actual positives --
    actualPositives = (yTrue == 1);
    numActualPositives = sum(actualPositives);

    % -- Predicted positives --
    predictedPositives = (yHat == 1);

    % -- Handle edge case cleanly --
    if numActualPositives == 0
        recall = 0;
        return;
    end

    % -- True positives --
    truePositives = predictedPositives & actualPositives;

    % -- Compute recall --
    recall = sum(truePositives) / numActualPositives;

end