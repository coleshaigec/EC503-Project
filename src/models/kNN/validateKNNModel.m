function validateKNNModel(knnModel, trainingData, hyperparameters)
    % VALIDATEKNNMODEL Validates trained kNN model.
    %
    % INPUTS
    %  knnModel struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .k (int > 0)                - number of NNs used
    %
    %  trainingData struct with fields
    %      .X (n x d double) - training feature matrix
    %      .y (n x 1 double) - training label vector
    %
    %  hyperparameters struct with fields
    %      .k (int > 0)                - number of NNs used

    % -- Validate type --
    if ~isstruct(knnModel)
        error('validateKNNModel:InvalidType', ...
            'knnModel must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(knnModel, 'Xtrain')
        error('validateKNNModel:MissingField', ...
            'knnModel must contain field ''Xtrain''.');
    end

    if ~isfield(knnModel, 'ytrain')
        error('validateKNNModel:MissingField', ...
            'knnModel must contain field ''ytrain''.');
    end

    if ~isfield(knnModel, 'k')
        error('validateKNNModel:MissingField', ...
            'knnModel must contain field ''k''.');
    end

    % -- Validate model field types --
    validateattributes(knnModel.Xtrain, {'double'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'knnModel.Xtrain');

    validateattributes(knnModel.ytrain, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'knnModel.ytrain');

    validateattributes(knnModel.k, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite'}, ...
        mfilename, 'knnModel.k');

    % -- Validate dimensional consistency --
    nTrain = size(trainingData.X, 1);
    d = size(trainingData.X, 2);

    assert(isequal(size(knnModel.Xtrain), [nTrain, d]), ...
        'knnModel.Xtrain must have dimension nTrain x d.');
    assert(numel(knnModel.ytrain) == nTrain, ...
        'knnModel.ytrain must have dimension nTrain x 1.');

    % -- Validate model contents against training data and hyperparameters --
    assert(isequal(knnModel.Xtrain, trainingData.X), ...
        'knnModel.Xtrain must equal trainingData.X.');
    assert(isequal(knnModel.ytrain, trainingData.y), ...
        'knnModel.ytrain must equal trainingData.y.');
    assert(knnModel.k == hyperparameters.k, ...
        'knnModel.k must equal hyperparameters.k.');
end