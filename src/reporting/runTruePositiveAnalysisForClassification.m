function rulsForTruePositives = runTruePositiveAnalysisForClassification(yHat, yTrue, warningHorizon)
    % RUNTRUEPOSITIVEANALYSISFORCLASSIFICATION Extracts RULs for true positives.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  rulsForFalsePositives (numFalsePositives x 1 double)
    %
    % NOTES
    % - +1 indicates failure within warning horizon (positive class)
    % - -1 indicates outside warning horizon (negative class)

    % -- Identify true positives (within horizon) --
    actualPositives = yTrue <= warningHorizon;

    % -- Identify predicted positives --
    predictedPositives = (yHat == 1);

    % -- False positives: predicted positive but actually negatives --
    truePositives = predictedPositives & actualPositives;

    % -- Extract corresponding RULs --
    rulsForTruePositives = yTrue(truePositives);
end