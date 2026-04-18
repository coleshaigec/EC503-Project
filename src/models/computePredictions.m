function predictionResult = computePredictions(dataset, model)
    %COMPUTEPREDICTIONS Computes predictions using a trained model. 
    %
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double)           - feature matrix
    %      .y (n x 1 double)           - label vector
    %
    %  model struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .hyperparameters (struct)   - hyperparameters used in training
    %
    % OUTPUT
    %  predictionResult struct with fields
    %      .yHat (n x 1 double)        - predicted labels
    %      .metadata struct with model-specific fields

    % -- Parse model and call appropriate model predictor --
    switch model.modelName
        case 'kernelSVM'
            predictionResult = computeKernelSVMPredictions(dataset, model);
        case 'randomForest'
            predictionResult = computeRandomForestPredictions(dataset, model);
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