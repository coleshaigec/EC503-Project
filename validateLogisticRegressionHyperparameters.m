function validateLogisticRegressionHyperparameters(trainingData, logisticRegressionHyperparameters)
    % VALIDATELOGISTICREGRESSIONHYPERPARAMETERS Validates hyperparameter struct passed to logistic regression model trainer.
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  logisticRegressionHyperparameters struct with fields
    %      .lambda (double >= 0)       - regularization strength
    %      .maxIter (double)           - cap on number of iterations
    %      .solver (string)            - solver type for templateLinear

    % -- Validate type --
    if ~isstruct(logisticRegressionHyperparameters)
        error('validateLogisticRegressionHyperparameters:InvalidType', ...
            'logisticRegressionHyperparameters must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(logisticRegressionHyperparameters, 'lambda')
        error('validateLogisticRegressionHyperparameters:MissingField', ...
            'logisticRegressionHyperparameters must contain field ''lambda''.');
    end

    if ~isfield(logisticRegressionHyperparameters, 'maxIter')
        error('validateLogisticRegressionHyperparameters:MissingField', ...
            'logisticRegressionHyperparameters must contain field ''maxIter''.');
    end

    if ~isfield(logisticRegressionHyperparameters, 'solver')
        error('validateLogisticRegressionHyperparameters:MissingField', ...
            'logisticRegressionHyperparameters must contain field ''solver''.');
    end

    % -- Validate lambda --
    validateattributes(logisticRegressionHyperparameters.lambda, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'nonnegative'}, ...
        mfilename, 'logisticRegressionHyperparameters.lambda');

    % -- Validate maxIter --
    validateattributes(logisticRegressionHyperparameters.maxIter, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive', 'integer'}, ...
        mfilename, 'logisticRegressionHyperparameters.maxIter');

    % -- Validate solver --
    if ~(ischar(logisticRegressionHyperparameters.solver) || ...
            (isstring(logisticRegressionHyperparameters.solver) && isscalar(logisticRegressionHyperparameters.solver)))
        error('validateLogisticRegressionHyperparameters:InvalidSolverType', ...
            'logisticRegressionHyperparameters.solver must be a character vector or string scalar.');
    end

    solver = char(logisticRegressionHyperparameters.solver);
    validSolvers = {'sgd', 'asgd', 'dual', 'lbfgs', 'sparsa'};
    assert(any(strcmp(solver, validSolvers)), ...
        'validateLogisticRegressionHyperparameters:InvalidSolver', ...
        'solver must be one of: sgd, asgd, dual, lbfgs, sparsa.');

    % -- Validate training data context --
    if ~isstruct(trainingData)
        error('validateLogisticRegressionHyperparameters:InvalidTrainingDataType', ...
            'trainingData must be a struct.');
    end

    if ~isfield(trainingData, 'Xtrain')
        error('validateLogisticRegressionHyperparameters:MissingField', ...
            'trainingData must contain field ''Xtrain''.');
    end

    if ~isfield(trainingData, 'ytrain')
        error('validateLogisticRegressionHyperparameters:MissingField', ...
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
        'validateLogisticRegressionHyperparameters:DimensionMismatch', ...
        'trainingData.ytrain must have dimension nTrain x 1.');

    classLabels = unique(trainingData.ytrain);
    assert(numel(classLabels) >= 2, ...
        'validateLogisticRegressionHyperparameters:InsufficientClasses', ...
        'trainingData.ytrain must contain at least two distinct classes.');
end