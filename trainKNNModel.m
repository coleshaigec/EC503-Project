function knnModel = trainKNNModel(trainingData, knnHyperparameters)
    % TRAINKNNMODEL Fits k-Nearest Neighbors classification model to training data using specified hyperparameters
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  knnHyperparameters struct with fields
    %      .k (int > 0)                - number of NNs used
    %
    % OUTPUTS
    %  knnModel struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .k (int > 0)                - number of NNs used

    % NOTE: For kNN, the training function does not fit parameters. 
    % It packages the training data and hyperparameter k into the kNN model object 
    % used by the standard trained-model interface elsewhere in the pipeline.
    % The real "work" is done by the computeKNNPredictions function, which
    % is called downstream in the pipeline.
    % All kNN implementation assumptions are documented in that function.

    % -- Validate hyperparameters -- 
    validateKNNHyperparameters(knnHyperparameters);

    % -- Construct kNN model struct --
    knnModel = struct();
    knnModel.Xtrain = trainingData.Xtrain;
    knnModel.ytrain = trainingData.ytrain;
    knnModel.k = knnHyperparameters.k;

    % -- Validate output --
    validateKNNModel(knnModel, trainingData, knnHyperparameters);
end