function truePositiveAnalysisResult = runTruePositiveAnalysisForClassification(yHat, trueRULs, warningHorizon)
    % RUNTRUEPOSITIVEANALYSISFORCLASSIFICATION Analyzes true positives produced by classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted labels (+1 or -1)
    %  trueRULs (n x 1 double)            - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  truePositiveAnalysisResult struct with fields
    %      .numTruePositives (nonnegative integer)
    %      .meanTruePositiveRUL (double)
    %      .maxTruePositiveRUL (double)
    %      .minTruePositiveRUL (double)
    %      
    % NOTES
    % - +1 indicates failure within warning horizon (positive class)
    % - -1 indicates outside warning horizon (negative class)

    % -- Identify true positives (within horizon) --
    actualPositives = trueRULs <= warningHorizon;

    % -- Identify predicted positives --
    predictedPositives = (yHat == 1);

    % -- False positives: predicted positive but actually negatives --
    truePositives = predictedPositives & actualPositives;

    % -- Extract corresponding RULs --
    rulsForTruePositives = trueRULs(truePositives);

    % -- Compute decision-relevant metrics --
    numTruePositives = sum(truePositives);
    meanTruePositiveRUL = mean(rulsForTruePositives);
    maxTruePositiveRUL = max(rulsForTruePositives);
    minTruePositiveRUL = min(rulsForTruePositives);

    % -- Populate output struct --
    truePositiveAnalysisResult = struct();
    truePositiveAnalysisResult.numTruePositives = numTruePositives;
    truePositiveAnalysisResult.meanTruePositiveRUL = meanTruePositiveRUL;
    truePositiveAnalysisResult.minTruePositiveRUL = minTruePositiveRUL;
    truePositiveAnalysisResult.maxTruePositiveRUL = maxTruePositiveRUL;
end