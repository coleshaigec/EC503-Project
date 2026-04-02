function validateRidgeRegressionResult(ridgeRegressionResult, dataset, ridgeRegressionModel)
    % VALIDATERIDGEREGRESSIONRESULT Validates ridge regression prediction result produced by computeRidgeRegressionPredictions.
    %
    % INPUTS
    %  ridgeRegressionResult struct with fields
    %      .yHatTrain (nTrain x 1 double) - predicted training labels
    %      .yHatTest  (nTest x 1 double)  - predicted test labels
    %      .ridgeRegressionModel struct with fields
    %          .coeff  (d x 1 double)     - ridge regression coefficients
    %          .bias   (double)           - intercept term
    %          .lambda (double >= 0)      - regularization penalty
    %
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double)      - ridge regression coefficients
    %      .bias   (double)            - intercept term
    %      .lambda (double >= 0)       - regularization penalty

    % -- Validate structure of ridgeRegressionResult --
    if ~isstruct(ridgeRegressionResult)
        error('validateRidgeRegressionResult:InvalidType', ...
            'ridgeRegressionResult must be a struct.');
    end

    if ~isfield(ridgeRegressionResult, 'yHatTrain')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult must have a ''yHatTrain'' field.');
    end

    if ~isfield(ridgeRegressionResult, 'yHatTest')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult must have a ''yHatTest'' field.');
    end

    if ~isfield(ridgeRegressionResult, 'ridgeRegressionModel')
        error('validateRidgeRegressionResult:MissingField', ...
            'ridgeRegressionResult must have a ''ridgeRegressionModel'' field.');
    end

    % -- Re-validate supplied ridge model and recover dimensions --
    validateRidgeRegressionModel(ridgeRegressionModel, dataset, ...
        struct('lambda', ridgeRegressionModel.lambda));

    nTrain = dataset.ntrain;
    nTest = dataset.ntest;

    % -- Define attributes --
    PREDICTION_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};

    % -- Validate attached model metadata field --
    assert(isequal(ridgeRegressionResult.ridgeRegressionModel, ridgeRegressionModel), ...
        'ridgeRegressionResult.ridgeRegressionModel must equal the supplied ridgeRegressionModel.');

    % -- Validate yHatTrain --
    validateattributes(ridgeRegressionResult.yHatTrain, {'double'}, ...
        PREDICTION_VECTOR_ATTRIBUTES, mfilename, 'ridgeRegressionResult.yHatTrain');
    assert(numel(ridgeRegressionResult.yHatTrain) == nTrain, ...
        'ridgeRegressionResult.yHatTrain must have dimension nTrain x 1.');

    % -- Validate yHatTest --
    validateattributes(ridgeRegressionResult.yHatTest, {'double'}, ...
        PREDICTION_VECTOR_ATTRIBUTES, mfilename, 'ridgeRegressionResult.yHatTest');
    assert(numel(ridgeRegressionResult.yHatTest) == nTest, ...
        'ridgeRegressionResult.yHatTest must have dimension nTest x 1.');

    % -- Validate prediction semantics against supplied model --
    expectedYHatTrain = dataset.Xtrain * ridgeRegressionModel.coeff + ridgeRegressionModel.bias;
    expectedYHatTest = dataset.Xtest * ridgeRegressionModel.coeff + ridgeRegressionModel.bias;

    assert(isequal(size(expectedYHatTrain), [nTrain, 1]), ...
        'Internal error: expectedYHatTrain must have dimension nTrain x 1.');
    assert(isequal(size(expectedYHatTest), [nTest, 1]), ...
        'Internal error: expectedYHatTest must have dimension nTest x 1.');

    assert(isequal(ridgeRegressionResult.yHatTrain, expectedYHatTrain), ...
        'ridgeRegressionResult.yHatTrain must equal dataset.Xtrain * coeff + bias.');
    assert(isequal(ridgeRegressionResult.yHatTest, expectedYHatTest), ...
        'ridgeRegressionResult.yHatTest must equal dataset.Xtest * coeff + bias.');
end