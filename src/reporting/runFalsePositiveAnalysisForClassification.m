function falsePositiveAnalysisResult = runFalsePositiveAnalysisForClassification(yHat, trueRULs, warningHorizon)
    % RUNFALSEPOSITIVEANALYSISFORCLASSIFICATION Extracts RULs for false positives and computes relevant metrics.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  trueRULs (n x 1 double)            - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  falsePositiveAnalysisResult struct with fields
    %      .numFalsePositives (nonnegative integer)
    %      .maxFalsePositiveRUL (double)
    %      .minFalsePositiveRUL (double)
    %      .meanFalsePositiveRUL (double)
    %
    % NOTES
    % - +1 indicates failure within warning horizon (positive class)
    % - -1 indicates outside warning horizon (negative class)

    % -- Identify true negatives (beyond horizon) --
    actualNegatives = trueRULs > warningHorizon;

    % -- Identify predicted positives --
    predictedPositives = (yHat == 1);

    % -- False positives: predicted positive but actually negatives --
    falsePositives = predictedPositives & actualNegatives;

    % -- Extract corresponding RULs --
    rulsForFalsePositives = trueRULs(falsePositives);

    % -- Compute decision-relevant metrics --
    numFalsePositives = sum(falsePositives);
    if numFalsePositives > 0
        meanFalsePositiveRUL = mean(rulsForFalsePositives);
        maxFalsePositiveRUL = max(rulsForFalsePositives);
        minFalsePositiveRUL = min(rulsForFalsePositives);
    else
        meanFalsePositiveRUL = NaN;
        maxFalsePositiveRUL = NaN;
        minFalsePositiveRUL = NaN;
    end
    
    % -- Populate output struct --
    falsePositiveAnalysisResult = struct();
    falsePositiveAnalysisResult.numFalsePositives = numFalsePositives;
    falsePositiveAnalysisResult.maxFalsePositiveRUL = maxFalsePositiveRUL;
    falsePositiveAnalysisResult.minFalsePositiveRUL = minFalsePositiveRUL;
    falsePositiveAnalysisResult.meanFalsePositiveRUL = meanFalsePositiveRUL;
end