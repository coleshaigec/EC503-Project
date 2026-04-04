function performanceMetrics = computeClassificationPerformanceMetricsForReporting(model, dataset)
    % COMPUTECLASSIFICATIONPERFORMANCEMETRICSFORREPORTING Computes full suite of performance metrics for trained classification model against full test and train datasets. 

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
    %      .modelName (string)         - model type to be analyzed
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
    performanceMetrics.modelName = model.modelName;
    performanceMetrics.train = struct();
    performanceMetrics.test = struct();

    % -- Compute predictions --
    predictionResult = computePredictions(model, dataset);

    % -- Compute training metrics and add to struct -- 
    trainAccuracy = computeAccuracy(predictionResult.yHatTrain, dataset.ytrain);
    trainPrecision = computePrecision(predictionResult.yHatTrain, dataset.ytrain);
    trainRecall = computeRecall(predictionResult.yHatTrain, dataset.ytrain);
    trainF1 = computeF1(trainPrecision, trainRecall);
    trainAUC_ROC = computeAUCROC(predictionResult.yHatTrain, dataset.ytrain);
    trainConfusionMatrix = computeConfusionMatrix(predictionResult.yHatTrain, dataset.ytrain);

    
    performanceMetrics.train.accuracy = trainAccuracy;
    performanceMetrics.train.precision = trainPrecision;
    performanceMetrics.train.F1 = trainF1;
    performanceMetrics.train.recall = trainRecall;
    performanceMetrics.train.AUC_ROC = trainAUC_ROC;
    performanceMetrics.train.confusionMatrix = trainConfusionMatrix;
   
    % -- Compute test metrics and add to struct --         
    testAccuracy = computeAccuracy(predictionResult.yHatTest, dataset.ytest);
    testPrecision = computePrecision(predictionResult.yHatTest, dataset.ytest);
    testRecall = computeRecall(predictionResult.yHatTest, dataset.ytest);
    testF1 = computeF1(testPrecision, testRecall);
    testAUC_ROC = computeAUCROC(predictionResult.yHatTest, dataset.ytest);
    testConfusionMatrix = computeConfusionMatrix(predictionResult.yHatTest, dataset.ytest);
    
    performanceMetrics.test.accuracy = testAccuracy;
    performanceMetrics.test.precision = testPrecision;
    performanceMetrics.test.F1 = testF1;
    performanceMetrics.test.recall = testRecall;
    performanceMetrics.test.AUC_ROC = testAUC_ROC;
    performanceMetrics.test.confusionMatrix = testConfusionMatrix;
       
    % -- Validate result -- 
    validateClassificationPerformanceMetricsForReporting(model, dataset, performanceMetrics);
end