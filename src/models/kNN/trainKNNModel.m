function knnModel = trainKNNModel(trainingData, knnHyperparameters)
    % TRAINKNNMODEL Fits k-Nearest Neighbors classification model on training data using specified hyperparameters
    %
    % AUTHOR: Youwei Chen 
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (n x d double) - training feature matrix
    %      .y (n x 1 double) - training label vector
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

    Xtrain = trainingData.X;
    ytrain = trainingData.y(:);
    k = knnHyperparameters.k;

    nTrain = size(Xtrain, 1);

    assert(k <= nTrain, ...
        'trainKNNModel:KTooLarge', ...
        'k must not exceed the number of training samples.');

    knnModel = struct();
    knnModel.Xtrain = Xtrain;
    knnModel.ytrain = ytrain;
    knnModel.k = k;

    % -- Validate output --
    validateKNNModel(knnModel, trainingData, knnHyperparameters);

end