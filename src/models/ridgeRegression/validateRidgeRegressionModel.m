function validateRidgeRegressionModel(ridgeRegressionModel, trainingData, ridgeRegressionHyperparameters)
    % VALIDATERIDGEREGRESSIONMODEL Validates trained ridge regression model.
    %
    % INPUTS
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double)      - ridge regression coefficients
    %      .bias   (double)            - intercept term
    %      .lambda (double >= 0)       - regularization penalty
    %
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  ridgeRegressionHyperparameters struct with fields
    %      .lambda (double >= 0)       - regularization penalty parameter

    % -- Validate structure of ridgeRegressionModel --
    if ~isstruct(ridgeRegressionModel)
        error('validateRidgeRegressionModel:InvalidType', ...
            'ridgeRegressionModel must be a struct.');
    end

    if ~isfield(ridgeRegressionModel, 'coeff')
        error('validateRidgeRegressionModel:MissingField', ...
            'ridgeRegressionModel must have a ''coeff'' field.');
    end

    if ~isfield(ridgeRegressionModel, 'bias')
        error('validateRidgeRegressionModel:MissingField', ...
            'ridgeRegressionModel must have a ''bias'' field.');
    end

    if ~isfield(ridgeRegressionModel, 'lambda')
        error('validateRidgeRegressionModel:MissingField', ...
            'ridgeRegressionModel must have a ''lambda'' field.');
    end

    % -- Recover dimensions --
    d = size(trainingData.Xtrain, 2);

    % -- Define attributes --
    COEFFICIENT_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    SCALAR_DOUBLE_ATTRIBUTES = {'scalar', 'real', 'finite', 'double'};
    LAMBDA_ATTRIBUTES = {'scalar', 'real', 'finite', 'double', 'nonnegative'};

    % -- Validate coeff --
    validateattributes(ridgeRegressionModel.coeff, {'double'}, ...
        COEFFICIENT_ATTRIBUTES, mfilename, 'ridgeRegressionModel.coeff');
    assert(isequal(size(ridgeRegressionModel.coeff), [d, 1]), ...
        'ridgeRegressionModel.coeff must have dimension d x 1.');

    % -- Validate bias --
    validateattributes(ridgeRegressionModel.bias, {'double'}, ...
        SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'ridgeRegressionModel.bias');

    % -- Validate lambda --
    validateattributes(ridgeRegressionModel.lambda, {'double'}, ...
        LAMBDA_ATTRIBUTES, mfilename, 'ridgeRegressionModel.lambda');
    assert(ridgeRegressionModel.lambda == ridgeRegressionHyperparameters.lambda, ...
        'ridgeRegressionModel.lambda must equal ridgeRegressionHyperparameters.lambda.');
end