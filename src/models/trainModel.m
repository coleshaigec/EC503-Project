function trainedModel = trainModel(trainingData, modelSpec)
    % TRAINMODEL Trains a single model with given data and a specified hyperparameter configuration
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double) - training feature matrix
    %      .y (nTrain x 1 double) - training label vector
    %
    %  modelSpec struct with fields
    %      .modelName (string)         - model type to be trained
    %      .hyperparameters (struct)   - hyperparameters for use in training
    %
    % OUTPUT
    %  trainedModel struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .taskType  (string)         - 'classification' or 'regression'
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
            trainedModel.taskType = 'classification';
        case 'kernelSVM'
            trainedModel.model = trainKernelSVMModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'classification';
        case 'randomForest'
            trainedModel.model = trainRandomForestModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'classification';
        case 'gradientBoostingClassifier'
            trainedModel.model = trainGradientBoostingClassificationModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'classification';
        case 'gradientBoostingRegression'
            trainedModel.model = trainGradientBoostingRegressionModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'regression';
        case 'naiveBayes'
            trainedModel.model = trainNaiveBayesModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'classification';
        case 'ridgeRegression'
            trainedModel.model = trainRidgeRegressionModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'regression';
        case 'kNN'
            trainedModel.model = trainKNNModel(trainingData, modelSpec.hyperparameters);
            trainedModel.taskType = 'classification';
        otherwise
            error('trainModel:InvalidModelName', 'Unsupported model name: %s', modelSpec.modelName);
    end

    trainedModel.modelName = modelSpec.modelName;

    % -- Output validation --
    validateTrainedModel(trainedModel);
end