function classificationErrorDiagnostics = performClassificationErrorDiagnostics(yHat, trueRULs, warningHorizon)
    % PERFORMCLASSIFICATIONERRORDIAGNOSTICS Extracts decision-relevant classification error diagnostics.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted RUL values
    %  trueRULs (n x 1 double)            - predicted labels (+1 or -1)
    %  warningHorizon (positive integer)  - TTF threshold used for warning analysis
    %
    % OUTPUTS
    %  classificationErrorDiagnostics struct with fields
    %      .truePositives struct with fields
    %          .numTruePositives (nonnegative integer)
    %          .meanTruePositiveRUL (double)
    %          .maxTruePositiveRUL (double)
    %          .minTruePositiveRUL (double)
    %      .falsePositives struct with fields
    %          .numFalsePositives (nonnegative integer)
    %          .maxFalsePositiveRUL (double)
    %          .minFalsePositiveRUL (double)
    %          .meanFalsePositiveRUL (double)
    %      .falseNegatives struct with fields
    %          .numFalseNegatives (nonnegative integer)
    %          .meanFalseNegativeRUL (double)
    %          .minFalseNegativeRUL (double)
    %          .maxFalseNegativeRUL (double)

    classificationErrorDiagnostics = struct();

    classificationErrorDiagnostics.falsePositives = runFalsePositiveAnalysisForClassification(yHat, trueRULs, warningHorizon);
    classificationErrorDiagnostics.falseNegatives = runFalseNegativeAnalysisForClassification(yHat, trueRULs, warningHorizon);
    classificationErrorDiagnostics.truePositives = runTruePositiveAnalysisForClassification(yHat, trueRULs, warningHorizon);
end