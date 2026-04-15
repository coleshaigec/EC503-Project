function runReport = buildSingleRunReport(trainedModel, trainingData, testData)
    % BUILDSINGLERUNREPORT Computes predictions and performance metrics for the trained model from a single pipeline run.
    %
    % INPUTS
    %  trainedModel struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .taskType  (string)         - 'classification' or 'regression'
    %      .hyperparameters            - hyperparameters used in training
    %
    %  trainingData struct with fields
    %      .X (ntrain x d double)  - train features
    %      .y (ntrain x 1 double)  - train labels
    %  testData struct with fields
    %      .X (ntest x d double)   - train features
    %      .y (ntest x 1 double)   - test labls
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

    % -- Compute predictions using trained model --
    trainPredictionResult = computePredictions(trainingData, trainedModel);
    testPredictionResult = computePredictions(testData, trainedModel);

    % -- Compute run-level performance metrics --
    if strcmp(trainedModel.taskType, 'classification')
        trainPerformanceMetrics = computeClassificationPerformanceMetricsForReporting(trainedModel, trainingData);
        testPerformanceMetrics = computeClassificationPerformanceMetricsForReporting(trainedModel, testData);
    elseif strcmp(trainedModel.taskType, 'regression')
    else
        error('buildSingleRunReport:InvalidFieldValue', ...
            'trainedModel.taskType must be ''classification'' or ''regression''.');
    end



end