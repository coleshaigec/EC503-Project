function performanceMetrics = computeRegressionPerformanceMetricsForReporting(yHatTrain, yHatTest, ytrain, ytest)
    % COMPUTEREGRESSIONPERFORMANCEMETRICSFORREPORTING Computes full suite of performance metrics for trained regression model. 
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % INPUTS
    %  yHatTrain (nTrain x 1 double)  - predicted train labels
    %  yHatTest  (nTest x 1 double)   - predicted test labels
    %  ytrain    (nTrain x 1 double)  - true train labels
    %  ytest     (nTest x 1 double)   - true test labels
    %
    % OUTPUTS
    %  performanceMetrics struct with fields
    %     .train struct with fields
    %         .RMSE (double)                 
    %         .MAE (double)                  
    %         .R2 (double in [-1,1])          
    %     .test struct with fields
    %         .RMSE (double)                  
    %         .MAE (double)                   
    %         .R2 (double in [-1,1])   
   
    % -- Compute train metrics --
    trainRMSE = computeRMSE(yHatTrain, ytrain);
    trainMAE = computeMAE(yHatTrain, ytrain);
    trainMedAE = computeMedianAbsoluteError(yHatTrain, ytrain);
    trainR2 = computeR2(yHatTrain, ytrain);
    trainBias = computeBias(yHatTrain, ytrain);
    
    % -- Compute test metrics --
    testRMSE = computeRMSE(yHatTest, ytest);
    testMAE = computeMAE(yHatTest, ytest);
    testMedAE = computeMedianAbsoluteError(yHatTest, ytest);
    testR2 = computeR2(yHatTest, ytest);
    testBias = computeBias(yHatTest, ytest);

    % -- Populate output struct --
    performanceMetrics = struct();
    performanceMetrics.train = struct();
    performanceMetrics.test = struct();

    performanceMetrics.train.RMSE = trainRMSE;
    performanceMetrics.train.MAE = trainMAE;
    performanceMetrics.train.MedAE = trainMedAE;
    performanceMetrics.train.R2 = trainR2;
    performanceMetrics.train.bias = trainBias;


    performanceMetrics.test.RMSE = testRMSE;
    performanceMetrics.test.MAE = testMAE;
    performanceMetrics.test.MedAE = testMedAE;
    performanceMetrics.test.R2 = testR2;
    performanceMetrics.test.bias = testBias;

end