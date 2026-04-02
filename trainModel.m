function trainedModel = trainModel(trainingData, modelSpec)
    % TRAINMODEL Trains a single model with given data and a specified hyperparameter configuration
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  modelSpec struct with fields
    %      .modelName (string)         - model type to be trained
    %      .hyperparameters (struct)   - hyperparameters for use in training
    %
    % OUTPUT
    %  trainedModel struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .hyperparameters            - hyperparameters used in training

    
    % -- Validate modelSpec --
    validateModelSpec(modelSpec); % Validator to be written

    % -- Construct output struct --
    trainedModel = struct();
    trainedModel.modelName = modelSpec.modelName;
    trainedModel.hyperparameters = modelSpec.hyperparameters;

    % -- Parse modelSpec and call appropriate model trainer --
    switch modelSpec.modelName
        case 'logisticRegression'
            trainedModel.model = trainLogisticRegressionModel(trainingData, modelSpec.hyperparameters);
        case 'kernelSVM'
            trainedModel.model = trainKernelSVMModel(trainingData, modelSpec.hyperparameters);
        case 'randomForest'
            trainedModel.model = trainRandomForestModel(trainingData, modelSpec.hyperparameters);
        case 'gradientBoostingClassifier'
            trainedModel.model = trainGradientBoostingClassificationModel(trainingData, modelSpec.hyperparameters);
        case 'gradientBoostingRegression'
            trainedModel.model = trainGradientBoostingRegressionModel(trainingData, modelSpec.hyperparameters);
        case 'naiveBayes'
            trainedModel.model = trainNaiveBayesModel(trainingData, modelSpec.hyperparameters);
        case 'ridgeRegression'
            trainedModel.model = trainRidgeRegressionModel(trainingData, modelSpec.hyperparameters);
        case 'kNN'
            trainedModel.model = trainKNNModel(trainingData, modelSpec.hyperparameters);
        otherwise
            error('trainModel:InvalidModelName', 'Unsupported model name: %s', modelSpec.modelName);
    end

    % -- Output validation --
    validateTrainedModel(trainedModel);
end