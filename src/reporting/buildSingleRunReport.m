function runReport = buildSingleRunReport(trainedModel, trainingData, testData, runPlan, trueRULs)
    % BUILDSINGLERUNREPORT Computes predictions and performance metrics for the trained model from a single pipeline run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  trainedModel struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .taskType  (string)         - 'classification' or 'regression'
    %      .hyperparameters            - hyperparameters used in training
    %  trainingData struct with fields
    %      .X (ntrain x d double)  - train features
    %      .y (ntrain x 1 double)  - train labels
    %  testData struct with fields
    %      .X (ntest x d double)   - train features
    %      .y (ntest x 1 double)   - test labels
    %  trueRULs (n x 1 double)     - true RUL values for test engines in chosen CMAPSS subset
    %
    % OUTPUTS
    %  runReport struct with fields
    %      .train struct with fields
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .test
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .trainedModel struct with fields
    %          .model (struct)             - trained model
    %          .modelName (string)         - model type to be trained
    %          .taskType  (string)         - 'classification' or 'regression'
    %          .hyperparameters            - hyperparameters used in training
    %      .runPlan struct with fields
    %          .runNumber (positive integer)
    %          .pcaSpec struct with fields
    %              .enabled (boolean)
    %              .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %              .varianceThreshold (double in [0,1]) - 
    %              .fixedNumComponents (int > 0) - number of principal components to compute 
    %    
    %          .modelSpec struct with fields
    %              .modelName (string)
    %              .hyperparameterGrid (struct with model-specific fields)
    %    
    %          .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %          .warningHorizon (positive integer)        - TTF classification threshold
    %          .windowSize (positive integer)            - for dataset windowing
    %       .policyAnalysisResult struct with fields
    %           .costModel struct with fields
    %               .name (string)
    %               .directMaintenanceCost (positive double) - cost of performing maintenance
    %               .failureCost (positive double) - cost of engine failure
    %               .alphaRUL (positive double) - scaling factor to price residual
    %               life wasted by premature maintenance
    %           .policyMetrics struct with fields
    %               .totalNumEngines (nonnegative integer)
    %               .totalMaintenanceJobs (nonnegative integer)
    %               .numPrematureMaintenanceJobs (nonnegative integer)
    %               .numTimelyMaintenanceJobs (nonnegative integer)
    %               .numMissedFailures (nonnegative integer)
    %               .numCorrectDeferments (nonnegative integer)
    %               .lostRULFromPrematureMaintenance (nonnegative integer)
    %           .policyCosts struct with fields
    %               .totalDirectMaintenanceCost (double)
    %               .totalFailureCost (double)
    %               .totalPrematureMaintenanceCost (double)
    %               .totalPolicyCost (double)   
    %       .errorDiagnosticsResult struct with task-specific fields

    % -- Compute predictions using trained model --
    trainPredictionResult = computePredictions(trainingData, trainedModel);
    yHatTrain = trainPredictionResult.yHat;

    testPredictionResult = computePredictions(testData, trainedModel);
    yHatTest = testPredictionResult.yHat;

    % -- Compute run-level performance metrics --
    if strcmp(trainedModel.taskType, 'classification')
        performanceMetrics = computeClassificationPerformanceMetricsForReporting(yHatTrain, yHatTest, trainingData.y, testData.y);
    elseif strcmp(trainedModel.taskType, 'regression')
        performanceMetrics = computeRegressionPerformanceMetricsForReporting(yHatTrain, yHatTest, trainingData.y, testData.y);
    else
        error('buildSingleRunReport:InvalidFieldValue', ...
            'trainedModel.taskType must be ''classification'' or ''regression''.');
    end

    % -- Run policy analysis --
    policyAnalysisResult = runPolicyAnalysis(yHatTest, trueRULs, runPlan.warningHorizon, trainedModel.taskType);

    % -- Run error diagnostics --
    errorDiagnosticsResult = runErrorDiagnostics(yHatTest, trueRULs, runPlan.warningHorizon, trainedModel.taskType);

    % -- Populate output struct --
    runReport = struct();
    runReport.train = struct();
    runReport.test = struct();

    runReport.train.yHat = yHatTrain;
    runReport.train.yTrue = trainingData.y;
    runReport.train.performanceMetrics = performanceMetrics.train;

    runReport.test.yHat = yHatTest;
    runReport.test.yTrue = testData.y;
    runReport.test.performanceMetrics = performanceMetrics.test;

    runReport.trainedModel = trainedModel;

    runReport.runPlan = runPlan;
    
    runReport.policyAnalysisResult = policyAnalysisResult;

    runReport.errorDiagnosticsResult = errorDiagnosticsResult;
end