function rulsForFalsePositives = runFalsePositiveAnalysisForClassification(yHat, yTrue, warningHorizon)
    % RUNFALSEPOSITIVEANALYSISFORCLASSIFICATION Extracts RULs for false positives.
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

    % -- Identify true negatives (beyond horizon) --
    actualNegatives = yTrue > warningHorizon;

    % -- Identify predicted positives --
    predictedPositives = (yHat == 1);

    % -- False positives: predicted positive but actually negatives --
    falsePositives = predictedPositives & actualNegatives;

    % -- Extract corresponding RULs --
    rulsForFalsePositives = yTrue(falsePositives);
end