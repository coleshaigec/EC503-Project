function validateLogisticRegressionModel(trainedModel, trainingData, logisticRegressionHyperparameters)
    % VALIDATELOGISTICREGRESSIONMODEL Validates trained logistic regression model.
    %
    % INPUTS
    %  trainedModel struct with fields
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
    if ~isstruct(trainedModel)
        error('validateLogisticRegressionModel:InvalidType', ...
            'trainedModel must be a struct.');
    end

    % -- Validate required field existence --
    if ~isfield(trainedModel, 'modelObject')
        error('validateLogisticRegressionModel:MissingField', ...
            'trainedModel must contain field ''modelObject''.');
    end

    if ~isfield(trainedModel, 'classLabels')
        error('validateLogisticRegressionModel:MissingField', ...
            'trainedModel must contain field ''classLabels''.');
    end

    if ~isfield(trainedModel, 'numClasses')
        error('validateLogisticRegressionModel:MissingField', ...
            'trainedModel must contain field ''numClasses''.');
    end

    % -- Re-validate hyperparameters and training data context --
    validateLogisticRegressionHyperparameters(trainingData, logisticRegressionHyperparameters);

    % -- Validate modelObject --
    assert(isobject(trainedModel.modelObject), ...
        'validateLogisticRegressionModel:InvalidModelObject', ...
        'trainedModel.modelObject must be a MATLAB model object.');

    % -- Validate classLabels --
    validateattributes(trainedModel.classLabels, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'trainedModel.classLabels');

    expectedClassLabels = unique(trainingData.ytrain);
    assert(isequal(trainedModel.classLabels, expectedClassLabels), ...
        'validateLogisticRegressionModel:InvalidClassLabels', ...
        'trainedModel.classLabels must equal unique(trainingData.ytrain).');

    % -- Validate numClasses --
    validateattributes(trainedModel.numClasses, {'numeric'}, ...
        {'scalar', 'real', 'finite', 'positive', 'integer'}, ...
        mfilename, 'trainedModel.numClasses');

    assert(trainedModel.numClasses == numel(expectedClassLabels), ...
        'validateLogisticRegressionModel:InvalidNumClasses', ...
        'trainedModel.numClasses must equal numel(unique(trainingData.ytrain)).');

    % -- Validate modelObject class metadata if available --
    if isprop(trainedModel.modelObject, 'ClassNames')
        assert(isequal(trainedModel.modelObject.ClassNames, expectedClassLabels), ...
            'validateLogisticRegressionModel:ClassNamesMismatch', ...
            'trainedModel.modelObject.ClassNames must match trainingData class labels.');
    end
end