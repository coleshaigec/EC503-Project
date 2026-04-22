function validateRidgeRegressionResult(ridgeRegressionResult, dataset, ridgeRegressionModel)
    % VALIDATERIDGEREGRESSIONRESULT Validates ridge regression prediction result produced by computeRidgeRegressionPredictions.
    %
    % INPUTS
    %  ridgeRegressionResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .ridgeRegressionModel struct with fields
    %              .coeff  (d x 1 double) - ridge regression coefficients
    %              .bias   (double)       - intercept term
    %              .lambda (double >= 0)  - regularization penalty
    %
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - label vector
    %
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double) - ridge regression coefficients
    %      .bias   (double)       - intercept term
    %      .lambda (double >= 0)  - regularization penalty

    % -- Validate structure of ridgeRegressionResult --
    if ~isstruct(ridgeRegressionResult)
        error('validateRidgeRegressionResult:InvalidType', ...
            'ridgeRegressionResult must be a struct.');
    end

    if ~isfield(ridgeRegressionResult, 'yHat')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult must have a ''yHat'' field.');
    end

    if ~isfield(ridgeRegressionResult, 'metadata')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult must have a ''metadata'' field.');
    end

    if ~isstruct(ridgeRegressionResult.metadata)
        error('validateRidgeRegressionResult:InvalidType', ...
            'ridgeRegressionResult.metadata must be a struct.');
    end

    if ~isfield(ridgeRegressionResult.metadata, 'ridgeRegressionModel')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult.metadata must have a ''ridgeRegressionModel'' field.');
    end

    % -- Validate dataset --
    if ~isstruct(dataset)
        error('validateRidgeRegressionResult:InvalidType', ...
            'dataset must be a struct.');
    end

    if ~isfield(dataset, 'X')
        error('validateRidgeRegressionResult:MissingField', ...
            'dataset must have an ''X'' field.');
    end

    if ~isfield(dataset, 'y')
        error('validateRidgeRegressionResult:MissingField', ...
            'dataset must have a ''y'' field.');
    end

    validateattributes(dataset.X, {'double'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.X');

    validateattributes(dataset.y, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.y');

    n = size(dataset.X, 1);
    d = size(dataset.X, 2);

    assert(numel(dataset.y) == n, ...
        'dataset.y must have dimension n x 1.');

    % -- Re-validate supplied ridge model --
    trainingDataForValidation = struct();
    trainingDataForValidation.Xtrain = dataset.X;
    trainingDataForValidation.ytrain = dataset.y;

    ridgeRegressionHyperparameters = struct();
    ridgeRegressionHyperparameters.lambda = ridgeRegressionModel.lambda;

    validateRidgeRegressionModel(ridgeRegressionModel, ...
        trainingDataForValidation, ridgeRegressionHyperparameters);

    % -- Define attributes --
    PREDICTION_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};

    % -- Validate attached model metadata field --
    assert(isequal(ridgeRegressionResult.metadata.ridgeRegressionModel, ridgeRegressionModel), ...
        'ridgeRegressionResult.metadata.ridgeRegressionModel must equal the supplied ridgeRegressionModel.');

    % -- Validate yHat --
    validateattributes(ridgeRegressionResult.yHat, {'double'}, ...
        PREDICTION_VECTOR_ATTRIBUTES, mfilename, 'ridgeRegressionResult.yHat');
    assert(numel(ridgeRegressionResult.yHat) == n, ...
        'ridgeRegressionResult.yHat must have dimension n x 1.');

    % -- Validate dimensional compatibility between dataset and model --
    assert(isequal(size(ridgeRegressionModel.coeff), [d, 1]), ...
        'ridgeRegressionModel.coeff must have dimension d x 1.');

    % -- Validate prediction semantics against supplied model --
    expectedYHat = dataset.X * ridgeRegressionModel.coeff + ridgeRegressionModel.bias;

    assert(isequal(size(expectedYHat), [n, 1]), ...
        'Internal error: expectedYHat must have dimension n x 1.');

    assert(isequal(ridgeRegressionResult.yHat, expectedYHat), ...
        'ridgeRegressionResult.yHat must equal dataset.X * coeff + bias.');
end