function runReport = buildSingleRunReport(trainedModel, trainingData, testData)
    % BUILDSINGLERUNREPORT Computes predictions and performance metrics for the trained model from a single pipeline run.
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
    %      .trainedModel struct with fields
    %          .model (struct)             - trained model
    %          .modelName (string)         - model type to be trained
    %          .taskType  (string)         - 'classification' or 'regression'
    %          .hyperparameters            - hyperparameters used in training

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
end