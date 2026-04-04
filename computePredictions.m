function predictionResult = computePredictions(dataset, model)
    %COMPUTEPREDICTIONS Computes predictions using a trained model. 
    %
    % INPUT 
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  model struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .taskType  (string)         - 'classification' or 'regression'
    %      .hyperparameters (struct)   - hyperparameters used in training
    %
    % OUTPUT
    %  predictions struct with fields
    %      .yHatTrain (ntrain x 1 double)
    %      .yHatTest  (ntest x 1 double)
    %      other model-specific fields

    % -- Parse model and call appropriate model predictor --
    switch model.modelName
        case 'logisticRegression'
            predictionResult = computeKNNPredictions(dataset, model);
        case 'kernelSVM'
            predictionResult = computeKernelSVMPredictions(dataset, model);
        case 'randomForest'
            predictionResult = computeRandomForestPredictions(dataset, model);
        case 'gradientBoostingClassifier'
            predictionResult = computeGradientBoostingClassifierPredictions(dataset, model);
        case 'gradientBoostingRegression'
            predictionResult = computeGradientBoostingRegressionPredictions(dataset, model);
        case 'naiveBayes'
            predictionResult = computeNaiveBayesPredictions(dataset, model);
        case 'ridgeRegression'
            predictionResult = computeRidgeRegressionPredictions(dataset, model);
        case 'kNN'
            predictionResult = computeKNNPredictions(dataset, model);
        otherwise
            error('computePredictions:InvalidModelName', 'Unsupported model name: %s', modelSpec.modelName);
    end
end