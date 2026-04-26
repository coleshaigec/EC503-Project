function falseNegativeAnalysisResult = runFalseNegativeAnalysisForClassification(yHat, trueRULs, warningHorizon)
    % RUNFALSENEGATIVEANALYSISFORCLASSIFICATION Analyzes false negatives produced by classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  falseNegativeAnalysisResult struct with fields
    %      .numFalseNegatives (nonnegative integer)
    %      .meanFalseNegativeRUL (double)
    %      .minFalseNegativeRUL (double)
    %      .maxFalseNegativeRUL (double)
    %
    % NOTES
    % - +1 indicates failure within warning horizon (positive class)
    % - -1 indicates outside warning horizon (negative class)

    % -- Identify true positives (within horizon) --
    truePositives = trueRULs <= warningHorizon;

    % -- Identify predicted negatives --
    predictedNegatives = (yHat == -1);

    % -- False negatives: predicted negative but actually positive --
    falseNegatives = predictedNegatives & truePositives;

    % -- Extract corresponding RULs --
    rulsForFalseNegatives = trueRULs(falseNegatives);

    % -- Compute decision-relevant performance metrics --
    numFalseNegatives = sum(falseNegatives);
    if numFalseNegatives > 0
        meanFalseNegativeRUL = mean(rulsForFalseNegatives);
        minFalseNegativeRUL = min(rulsForFalseNegatives);
        maxFalseNegativeRUL = max(rulsForFalseNegatives);
    else
        meanFalseNegativeRUL = NaN;
        minFalseNegativeRUL = NaN;
        maxFalseNegativeRUL = NaN;
    end

    % -- Populate output struct --
    falseNegativeAnalysisResult = struct();
    falseNegativeAnalysisResult.numFalseNegatives = numFalseNegatives;
    falseNegativeAnalysisResult.meanFalseNegativeRUL = meanFalseNegativeRUL;
    falseNegativeAnalysisResult.minFalseNegativeRUL = minFalseNegativeRUL;
    falseNegativeAnalysisResult.maxFalseNegativeRUL = maxFalseNegativeRUL;
end