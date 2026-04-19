function performanceMetrics = computeClassificationPerformanceMetricsForReporting(yHatTrain, yHatTest, ytrain, ytest, warningHorizon)
    % COMPUTECLASSIFICATIONPERFORMANCEMETRICSFORREPORTING Computes full suite of performance metrics for trained classification model. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHatTrain (nTrain x 1 double)      - predicted training labels
    %  yHatTest  (nTest x 1 double)       - predicted test labels
    %  ytrain    (nTrain x 1 double)      - true training labels
    %  ytest     (nTest x 1 double)       - true testing labels
    %  warningHorizon (positive integer)  - TTF threshold for classification
    %
    % OUTPUTS
    %  performanceMetrics struct with fields
    %      .train struct with fields
    %          .F1 (double in [0,100])        
    %          .accuracy (double in [0,100])  
    %          .precision (double in [0,100]) 
    %          .recall (double in [0,100])   
    %          .balancedAccuracy (double in [0,100])
    %          .specificity (double in [0,100])
    %          .confusionMatrix (table)       
    %      .test struct with fields 
    %          .F1 (double in [0,100])        
    %          .accuracy (double in [0,100])  
    %          .precision (double in [0,100]) 
    %          .recall (double in [0,100])
    %          .balancedAccuracy (double in [0,100])
    %          .specificity (double in [0,100])
    %          .confusionMatrix (table)       
    
    performanceMetrics = struct();
    performanceMetrics.train = struct();
    performanceMetrics.test = struct();

    % -- Compute training metrics and add to struct -- 
    trainAccuracy = computeAccuracy(yHatTrain, ytrain);
    trainPrecision = computePrecision(yHatTrain, ytrain, warningHorizon);
    trainRecall = computeRecall(yHatTrain, ytrain, warningHorizon);
    trainF1 = computeF1(trainPrecision, trainRecall);
    trainSpecificity = computeSpecificity(yHatTrain, ytrain, warningHorizon);
    trainBalancedAccuracy = computeBalancedAccuracy(yHatTrain, ytrain, warningHorizon);
    trainConfusionMatrix = computeConfusionMatrix(yHatTrain, ytrain);

    performanceMetrics.train.accuracy = trainAccuracy;
    performanceMetrics.train.precision = trainPrecision;
    performanceMetrics.train.F1 = trainF1;
    performanceMetrics.train.recall = trainRecall;
    performanceMetrics.train.balancedAccuracy = trainBalancedAccuracy;
    performanceMetrics.train.specificity = trainSpecificity;
    performanceMetrics.train.confusionMatrix = trainConfusionMatrix;
   
    % -- Compute test metrics and add to struct --         
    testAccuracy = computeAccuracy(yHatTest, ytest);
    testPrecision = computePrecision(yHatTest, ytest, warningHorizon);
    testRecall = computeRecall(yHatTest, ytest, warningHorizon);
    testF1 = computeF1(testPrecision, testRecall);
    testSpecificity = computeSpecificity(yHatTest, ytest, warningHorizon);
    testBalancedAccuracy = computeBalancedAccuracy(yHatTest, ytest, warningHorizon);
    testConfusionMatrix = computeConfusionMatrix(yHatTest, ytest);
    
    performanceMetrics.test.accuracy = testAccuracy;
    performanceMetrics.test.precision = testPrecision;
    performanceMetrics.test.F1 = testF1;
    performanceMetrics.test.recall = testRecall;
    performanceMetrics.test.specificity = testSpecificity;
    performanceMetrics.test.balancedAccuracy = testBalancedAccuracy;
    performanceMetrics.test.confusionMatrix = testConfusionMatrix;
end