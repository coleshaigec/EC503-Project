function performanceMetrics = computeRegressionPerformanceMetricsForReporting(model, dataset)
    % COMPUTEREGRESSIONPERFORMANCEMETRICSFORREPORTING Computes full suite of performance metrics for trained regression model against full test and train datasets. 
    %
    % INPUTS
    %  model struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be analyzed
    %      .taskType  (string)         - 'classification' or 'regression'
    %      .hyperparameters (struct)   - hyperparameters used in training
    %  
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    % OUTPUTS
    %  performanceMetrics struct with fields
    %     .modelName (string)
    %     .train struct with fields
    %         .RMSE (double)                 
    %         .MAE (double)                  
    %         .R2 (double in [-1,1])          
    %     .test struct with fields
    %         .RMSE (double)                  
    %         .MAE (double)                   
    %         .R2 (double in [-1,1])   
    
    % -- Compute predictions --
    predictionResult = computePredictions(model, dataset);

    % -- Compute train metrics --
    trainRMSE = computeRMSE(predictionResult.yHatTrain, dataset.ytrain);
    trainMAE = computeMAE(predictionResult.yHatTrain, dataset.ytrain);
    trainR2 = computeR2(predictionResult.yHatTrain, dataset.ytrain);
    
    % -- Compute test metrics --
    testRMSE = computeRMSE(predictionResult.yHatTest, dataset.ytest);
    testMAE = computeMAE(predictionResult.yHatTest, dataset.ytest);
    testR2 = computeR2(predictionResult.yHatTest, dataset.ytest);

    % -- Populate output struct --
    performanceMetrics = struct();
    performanceMetrics.modelName = model.modelName;
    performanceMetrics.train = struct();
    performanceMetrics.test = struct();

    performanceMetrics.train.RMSE = trainRMSE;
    performanceMetrics.train.MAE = trainMAE;
    performanceMetrics.train.R2 = trainR2;

    performanceMetrics.test.RMSE = testRMSE;
    performanceMetrics.test.MAE = testMAE;
    performanceMetrics.test.R2 = testR2;

    % -- Validate output struct --
    validateRegressionPerformanceMetricsForReporting(performanceMetrics, model, dataset);

end