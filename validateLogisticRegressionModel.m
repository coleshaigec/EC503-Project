function validateLogisticRegressionModel(logisticRegressionModel, trainingData, logisticRegressionHyperparameters)
    % VALIDATELOGISTICREGRESSIONMODEL Validates trained logistic regression model.
    %
    % INPUTS
    %  logisticRegressionModel struct with fields
    %      .modelObject                - trained MATLAB multiclass linear classification model
    %      .classLabels (m x 1 double) - unique labels present in training data
    %      .numClasses  (double)       - number of classes
    %
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  logisticRegressionHyperparameters struct with fields
    %      .lambda (double >= 0)       - regularization strength
    %      .maxIter (double)           - cap on number of iterations
    %      .solver (string)            - solver type for templateLinear

    % -- Validate type --
    if ~isstruct(logisticRegressionModel)
        error('validateLogisticRegressionModel:InvalidType', ...
            'logisticRegressionModel must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(logisticRegressionModel, 'modelObject')
        error('validateLogisticRegressionModel:MissingField', ...
            'logisticRegressionModel must contain field ''modelObject''.');
    end

    if ~isfield(logisticRegressionModel, 'classLabels')
        error('validateLogisticRegressionModel:MissingField', ...
            'logisticRegressionModel must contain field ''classLabels''.');
    end

    if ~isfield(logisticRegressionModel, 'numClasses')
        error('validateLogisticRegressionModel:MissingField', ...
            'logisticRegressionModel must contain field ''numClasses''.');
    end

    % -- Re-validate hyperparameters and training data context --
    validateLogisticRegressionHyperparameters(trainingData, logisticRegressionHyperparameters);

    % -- Validate modelObject --
    assert(isobject(logisticRegressionModel.modelObject), ...
        'validateLogisticRegressionModel:InvalidModelObject', ...
        'logisticRegressionModel.modelObject must be a MATLAB model object.');

    % -- Validate classLabels --
    validateattributes(logisticRegressionModel.classLabels, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'logisticRegressionModel.classLabels');

    expectedClassLabels = unique(trainingData.ytrain);
    assert(isequal(logisticRegressionModel.classLabels, expectedClassLabels), ...
        'validateLogisticRegressionModel:InvalidClassLabels', ...
        'logisticRegressionModel.classLabels must equal unique(trainingData.ytrain).');

    % -- Validate numClasses --
    validateattributes(logisticRegressionModel.numClasses, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive', 'integer'}, ...
        mfilename, 'logisticRegressionModel.numClasses');

    assert(logisticRegressionModel.numClasses == numel(expectedClassLabels), ...
        'validateLogisticRegressionModel:InvalidNumClasses', ...
        'logisticRegressionModel.numClasses must equal numel(unique(trainingData.ytrain)).');

    % -- Validate modelObject class metadata if available --
    if isprop(logisticRegressionModel.modelObject, 'ClassNames')
        assert(isequal(logisticRegressionModel.modelObject.ClassNames, expectedClassLabels), ...
            'validateLogisticRegressionModel:ClassNamesMismatch', ...
            'logisticRegressionModel.modelObject.ClassNames must match trainingData class labels.');
    end
end