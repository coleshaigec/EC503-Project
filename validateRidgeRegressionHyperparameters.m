function validateRidgeRegressionHyperparameters(trainingData, ridgeRegressionHyperparameters)
    % VALIDATERIDGEREGRESSIONHYPERPARAMETERS Validates hyperparameter struct passed to ridge regression model trainer.
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  ridgeRegressionHyperparameters struct with fields
    %      .lambda (double >= 0)       - regularization penalty parameter

    % -- Validate type --
    if ~isstruct(ridgeRegressionHyperparameters)
        error('validateRidgeRegressionHyperparameters:InvalidType', ...
            'ridgeRegressionHyperparameters must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(ridgeRegressionHyperparameters, 'lambda')
        error('validateRidgeRegressionHyperparameters:MissingField', ...
            'ridgeRegressionHyperparameters must contain field ''lambda''.');
    end

    % -- Validate lambda --
    validateattributes(ridgeRegressionHyperparameters.lambda, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'nonnegative', 'double'}, ...
        mfilename, 'ridgeRegressionHyperparameters.lambda');

    % -- Validate training data context --
    if ~isstruct(trainingData)
        error('validateRidgeRegressionHyperparameters:InvalidTrainingDataType', ...
            'trainingData must be a struct.');
    end

    if ~isfield(trainingData, 'Xtrain')
        error('validateRidgeRegressionHyperparameters:MissingField', ...
            'trainingData must contain field ''Xtrain''.');
    end

    if ~isfield(trainingData, 'ytrain')
        error('validateRidgeRegressionHyperparameters:MissingField', ...
            'trainingData must contain field ''ytrain''.');
    end

    validateattributes(trainingData.Xtrain, {'double'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'trainingData.Xtrain');

    validateattributes(trainingData.ytrain, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'trainingData.ytrain');

    nTrain = size(trainingData.Xtrain, 1);
    assert(numel(trainingData.ytrain) == nTrain, ...
        'validateRidgeRegressionHyperparameters:DimensionMismatch', ...
        'trainingData.ytrain must have dimension nTrain x 1.');
end