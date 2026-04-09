function validateLogisticRegressionResult(logisticRegressionResult, dataset, logisticRegressionModel)
    % VALIDATELOGISTICREGRESSIONRESULT Validates logistic regression prediction result produced by computeLogisticRegressionPredictions.
    %
    % INPUTS
    %  logisticRegressionResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .scores (n x m double) - class scores for samples
    %          .logisticRegressionModel struct with fields
    %              .modelObject                - trained MATLAB ECOC multiclass classification model
    %              .classLabels (m x 1 double) - unique labels present in training data
    %              .numClasses  (double)       - number of classes
    %
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - label vector
    %
    %  logisticRegressionModel struct with fields
    %      .modelObject                - trained MATLAB ECOC multiclass classification model
    %      .classLabels (m x 1 double) - unique labels present in training data
    %      .numClasses  (double)       - number of classes

    % -- Validate structure of logisticRegressionResult --
    if ~isstruct(logisticRegressionResult)
        error('validateLogisticRegressionResult:InvalidType', ...
            'logisticRegressionResult must be a struct.');
    end

    if ~isfield(logisticRegressionResult, 'yHat')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''yHat'' field.');
    end

    if ~isfield(logisticRegressionResult, 'metadata')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''metadata'' field.');
    end

    if ~isstruct(logisticRegressionResult.metadata)
        error('validateLogisticRegressionResult:InvalidType', ...
            'logisticRegressionResult.metadata must be a struct.');
    end

    if ~isfield(logisticRegressionResult.metadata, 'scores')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult.metadata must have a ''scores'' field.');
    end

    if ~isfield(logisticRegressionResult.metadata, 'logisticRegressionModel')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult.metadata must have a ''logisticRegressionModel'' field.');
    end

    % -- Validate dataset --
    if ~isstruct(dataset)
        error('validateLogisticRegressionResult:InvalidType', ...
            'dataset must be a struct.');
    end

    if ~isfield(dataset, 'X')
        error('validateLogisticRegressionResult:MissingField', ...
            'dataset must have an ''X'' field.');
    end

    if ~isfield(dataset, 'y')
        error('validateLogisticRegressionResult:MissingField', ...
            'dataset must have a ''y'' field.');
    end

    validateattributes(dataset.X, {'double'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.X');

    validateattributes(dataset.y, {'double'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.y');

    n = size(dataset.X, 1);
    assert(numel(dataset.y) == n, ...
        'dataset.y must have dimension n x 1.');

    % -- Recover dimensions and metadata --
    m = logisticRegressionModel.numClasses;
    classLabels = logisticRegressionModel.classLabels;

    % -- Define attributes --
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    SCORE_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double'};

    % -- Validate attached model metadata field --
    assert(isequal(logisticRegressionResult.metadata.logisticRegressionModel, logisticRegressionModel), ...
        'logisticRegressionResult.metadata.logisticRegressionModel must equal the supplied logisticRegressionModel.');

    % -- Validate yHat --
    validateattributes(logisticRegressionResult.yHat, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'logisticRegressionResult.yHat');
    assert(numel(logisticRegressionResult.yHat) == n, ...
        'logisticRegressionResult.yHat must have dimension n x 1.');
    assert(all(ismember(logisticRegressionResult.yHat, classLabels)), ...
        'logisticRegressionResult.yHat must contain only labels present in logisticRegressionModel.classLabels.');

    % -- Validate scores --
    validateattributes(logisticRegressionResult.metadata.scores, {'double'}, ...
        SCORE_MATRIX_ATTRIBUTES, mfilename, 'logisticRegressionResult.metadata.scores');
    assert(isequal(size(logisticRegressionResult.metadata.scores), [n, m]), ...
        'logisticRegressionResult.metadata.scores must have dimension n x m.');

    % -- Validate label consistency with score argmax --
    [~, scoreArgmax] = max(logisticRegressionResult.metadata.scores, [], 2);
    expectedYHat = classLabels(scoreArgmax);

    assert(isequal(logisticRegressionResult.yHat, expectedYHat), ...
        'logisticRegressionResult.yHat must match the argmax of scores mapped through classLabels.');
end