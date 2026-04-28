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

    if ~isstruct(knnModel)
        error('validateKNNModel:InvalidType', ...
            'knnModel must be a struct.');
    end

    requiredFields = {'Xtrain', 'ytrain', 'k'};
    for i = 1:numel(requiredFields)
        if ~isfield(knnModel, requiredFields{i})
            error('validateKNNModel:MissingField', ...
                'knnModel must contain field ''%s''.', requiredFields{i});
        end
    end

    validateattributes(knnModel.Xtrain, {'numeric'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'knnModel.Xtrain');

    validateattributes(knnModel.ytrain, {'numeric'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'knnModel.ytrain');

    validateattributes(knnModel.k, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite'}, ...
        mfilename, 'knnModel.k');

    nTrain = size(trainingData.X, 1);
    d = size(trainingData.X, 2);

    assert(isequal(size(knnModel.Xtrain), [nTrain, d]), ...
        'validateKNNModel:InvalidXtrainSize', ...
        'knnModel.Xtrain must have dimension nTrain x d.');

    assert(isequal(size(knnModel.ytrain), [nTrain, 1]), ...
        'validateKNNModel:InvalidYtrainSize', ...
        'knnModel.ytrain must have dimension nTrain x 1.');

    assert(isequal(knnModel.Xtrain, trainingData.X), ...
        'validateKNNModel:XtrainMismatch', ...
        'knnModel.Xtrain must equal trainingData.X.');

    assert(isequal(knnModel.ytrain, trainingData.y(:)), ...
        'validateKNNModel:YtrainMismatch', ...
        'knnModel.ytrain must equal trainingData.y as a column vector.');

    assert(knnModel.k == hyperparameters.k, ...
        'validateKNNModel:HyperparameterMismatch', ...
        'knnModel.k must equal hyperparameters.k.');

    assert(knnModel.k <= nTrain, ...
        'validateKNNModel:KTooLarge', ...
        'knnModel.k must not exceed the number of training samples.');

    classLabels = unique(knnModel.ytrain);

    assert(isequal(classLabels, [-1; 1]), ...
        'validateKNNModel:InvalidClassLabels', ...
        'knnModel.ytrain must contain exactly the class labels -1 and +1.');
end