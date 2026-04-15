function performanceMetrics = computeClassificationPerformanceMetricsForReporting(yHatTrain, yHatTest, ytrain, ytest)
    % COMPUTECLASSIFICATIONPERFORMANCEMETRICSFORREPORTING Computes full suite of performance metrics for trained classification model. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHatTrain (nTrain x 1 double)  - predicted training labels
    %  yHatTest  (nTest x 1 double)   - predicted test labels
    %  ytrain    (nTrain x 1 double)  - true training labels
    %  ytest     (nTest x 1 double)   - true testing labels
    %
    % OUTPUTS
    %  performanceMetrics struct with fields
    %      .train struct with fields
    %          .F1 (double in [0,100])        
    %          .accuracy (double in [0,100])  
    %          .precision (double in [0,100]) 
    %          .recall (double in [0,100])    
    %          .AUC_ROC (double in [0,1])     
    %          .confusionMatrix (table)       
    %      .test struct with fields 
    %          .F1 (double in [0,100])        
    %          .accuracy (double in [0,100])  
    %          .precision (double in [0,100]) 
    %          .recall (double in [0,100])    
    %          .AUC_ROC (double in [0,1])     
    %          .confusionMatrix (table)       
    
    performanceMetrics = struct();
    performanceMetrics.train = struct();
    performanceMetrics.test = struct();

    % -- Compute training metrics and add to struct -- 
    trainAccuracy = computeAccuracy(yHatTrain, ytrain);
    trainPrecision = computePrecision(yHatTrain, ytrain);
    trainRecall = computeRecall(yHatTrain, ytrain);
    trainF1 = computeF1(trainPrecision, trainRecall);
    trainAUC_ROC = computeAUCROC(yHatTrain, ytrain);
    trainConfusionMatrix = computeConfusionMatrix(yHatTrain, ytrain);

    
    performanceMetrics.train.accuracy = trainAccuracy;
    performanceMetrics.train.precision = trainPrecision;
    performanceMetrics.train.F1 = trainF1;
    performanceMetrics.train.recall = trainRecall;
    performanceMetrics.train.AUC_ROC = trainAUC_ROC;
    performanceMetrics.train.confusionMatrix = trainConfusionMatrix;
   
    % -- Compute test metrics and add to struct --         
    testAccuracy = computeAccuracy(yHatTest, ytest);
    testPrecision = computePrecision(yHatTest, ytest);
    testRecall = computeRecall(yHatTest, ytest);
    testF1 = computeF1(testPrecision, testRecall);
    testAUC_ROC = computeAUCROC(yHatTest, ytest);
    testConfusionMatrix = computeConfusionMatrix(yHatTest, ytest);
    
    performanceMetrics.test.accuracy = testAccuracy;
    performanceMetrics.test.precision = testPrecision;
    performanceMetrics.test.F1 = testF1;
    performanceMetrics.test.recall = testRecall;
    performanceMetrics.test.AUC_ROC = testAUC_ROC;
    performanceMetrics.test.confusionMatrix = testConfusionMatrix;
       
    % -- Validate result -- 
    validateClassificationPerformanceMetricsForReporting(model, performanceMetrics);
end