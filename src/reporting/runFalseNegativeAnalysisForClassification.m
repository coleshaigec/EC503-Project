function rulsForFalseNegatives = runFalseNegativeAnalysisForClassification(yHat, yTrue, warningHorizon)
    % RUNFALSENEGATIVEANALYSISFORCLASSIFICATION Extracts RULs for false negatives.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  rulsForFalseNegatives (numFalseNegatives x 1 double)
    %
    % NOTES
    % - +1 indicates failure within warning horizon (positive class)
    % - -1 indicates outside warning horizon (negative class)

    % -- Identify true positives (within horizon) --
    truePositives = yTrue <= warningHorizon;

    % -- Identify predicted negatives --
    predictedNegatives = (yHat == -1);

    % -- False negatives: predicted negative but actually positive --
    falseNegatives = predictedNegatives & truePositives;

    % -- Extract corresponding RULs --
    rulsForFalseNegatives = yTrue(falseNegatives);
end