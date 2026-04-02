function validateKNNHyperparameters(knnHyperparameters, trainingData)
    % VALIDATEKNNHYPERPARAMETERS Validates hyperparameter struct passed to kNN model trainer.
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  knnHyperparameters struct with fields
    %      .k (int > 0)                - number of NNs used

    % -- Validate type --
    if ~isstruct(knnHyperparameters)
        error('validateKNNHyperparameters:InvalidType', ...
            'knnHyperparameters must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(knnHyperparameters, 'k')
        error('validateKNNHyperparameters:MissingField', ...
            'knnHyperparameters must contain field ''k''.');
    end

    % -- Validate k --
    validateattributes(knnHyperparameters.k, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite'}, ...
        mfilename, 'knnHyperparameters.k');

    k = knnHyperparameters.k;

    % -- Validate against training data --
    if ~isstruct(trainingData) || ~isfield(trainingData, 'Xtrain')
        error('validateKNNHyperparameters:InvalidTrainingData', ...
            'trainingData must be a struct with field ''Xtrain''.');
    end

    nTrain = size(trainingData.Xtrain, 1);

    % k cannot exceed number of training samples
    assert(k <= nTrain, ...
        'validateKNNHyperparameters:InvalidK', ...
        'k (%d) must be less than or equal to number of training samples (%d).', ...
        k, nTrain);
end