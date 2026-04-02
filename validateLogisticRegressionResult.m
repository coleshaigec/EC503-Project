function validateLogisticRegressionResult(logisticRegressionResult, dataset, logisticRegressionModel)
    % VALIDATELOGISTICREGRESSIONRESULT Validates logistic regression prediction result produced by computeLogisticRegressionPredictions.
    %
    % INPUTS
    %  logisticRegressionResult struct with fields
    %      .yHatTrain (nTrain x 1 double)            - predicted training labels
    %      .yHatTest  (nTest x 1 double)             - predicted test labels
    %      .scoresTrain (nTrain x m double)          - class scores for training samples
    %      .scoresTest  (nTest x m double)           - class scores for test samples
    %      .posteriorTrain (nTrain x m double)       - posterior probabilities for training samples
    %      .posteriorTest  (nTest x m double)        - posterior probabilities for test samples
    %      .logisticRegressionModel struct with fields
    %          .modelObject                - trained MATLAB multiclass classification model
    %          .classLabels (m x 1 double) - unique labels present in training data
    %          .numClasses  (double)       - number of classes
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
    %  logisticRegressionModel struct with fields
    %      .modelObject                - trained MATLAB multiclass classification model
    %      .classLabels (m x 1 double) - unique labels present in training data
    %      .numClasses  (double)       - number of classes

    % -- Validate structure of logisticRegressionResult --
    if ~isstruct(logisticRegressionResult)
        error('validateLogisticRegressionResult:InvalidType', ...
            'logisticRegressionResult must be a struct.');
    end

    if ~isfield(logisticRegressionResult, 'yHatTrain')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''yHatTrain'' field.');
    end

    if ~isfield(logisticRegressionResult, 'yHatTest')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''yHatTest'' field.');
    end

    if ~isfield(logisticRegressionResult, 'scoresTrain')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''scoresTrain'' field.');
    end

    if ~isfield(logisticRegressionResult, 'scoresTest')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''scoresTest'' field.');
    end

    if ~isfield(logisticRegressionResult, 'posteriorTrain')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''posteriorTrain'' field.');
    end

    if ~isfield(logisticRegressionResult, 'posteriorTest')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''posteriorTest'' field.');
    end

    if ~isfield(logisticRegressionResult, 'logisticRegressionModel')
        error('validateLogisticRegressionResult:MissingField', ...
            'logisticRegressionResult must have a ''logisticRegressionModel'' field.');
    end

    % -- Recover dimensions and metadata --
    nTrain = dataset.ntrain;
    nTest = dataset.ntest;
    m = logisticRegressionModel.numClasses;
    classLabels = logisticRegressionModel.classLabels;
    PROBABILITY_SUM_TOLERANCE = 1e-8;

    % -- Define attributes --
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    SCORE_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double'};
    POSTERIOR_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double', '>=', 0, '<=', 1};

    % -- Validate attached model metadata field --
    assert(isequal(logisticRegressionResult.logisticRegressionModel, logisticRegressionModel), ...
        'logisticRegressionResult.logisticRegressionModel must equal the supplied logisticRegressionModel.');

    % -- Validate yHatTrain --
    validateattributes(logisticRegressionResult.yHatTrain, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'logisticRegressionResult.yHatTrain');
    assert(numel(logisticRegressionResult.yHatTrain) == nTrain, ...
        'logisticRegressionResult.yHatTrain must have dimension nTrain x 1.');
    assert(all(ismember(logisticRegressionResult.yHatTrain, classLabels)), ...
        'logisticRegressionResult.yHatTrain must contain only labels present in logisticRegressionModel.classLabels.');

    % -- Validate yHatTest --
    validateattributes(logisticRegressionResult.yHatTest, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'logisticRegressionResult.yHatTest');
    assert(numel(logisticRegressionResult.yHatTest) == nTest, ...
        'logisticRegressionResult.yHatTest must have dimension nTest x 1.');
    assert(all(ismember(logisticRegressionResult.yHatTest, classLabels)), ...
        'logisticRegressionResult.yHatTest must contain only labels present in logisticRegressionModel.classLabels.');

    % -- Validate scoresTrain --
    validateattributes(logisticRegressionResult.scoresTrain, {'double'}, ...
        SCORE_MATRIX_ATTRIBUTES, mfilename, 'logisticRegressionResult.scoresTrain');
    assert(isequal(size(logisticRegressionResult.scoresTrain), [nTrain, m]), ...
        'logisticRegressionResult.scoresTrain must have dimension nTrain x m.');

    % -- Validate scoresTest --
    validateattributes(logisticRegressionResult.scoresTest, {'double'}, ...
        SCORE_MATRIX_ATTRIBUTES, mfilename, 'logisticRegressionResult.scoresTest');
    assert(isequal(size(logisticRegressionResult.scoresTest), [nTest, m]), ...
        'logisticRegressionResult.scoresTest must have dimension nTest x m.');

    % -- Validate posteriorTrain --
    validateattributes(logisticRegressionResult.posteriorTrain, {'double'}, ...
        POSTERIOR_MATRIX_ATTRIBUTES, mfilename, 'logisticRegressionResult.posteriorTrain');
    assert(isequal(size(logisticRegressionResult.posteriorTrain), [nTrain, m]), ...
        'logisticRegressionResult.posteriorTrain must have dimension nTrain x m.');
    assert(all(abs(sum(logisticRegressionResult.posteriorTrain, 2) - 1) <= PROBABILITY_SUM_TOLERANCE), ...
        'Rows of logisticRegressionResult.posteriorTrain must sum to 1 within tolerance.');

    % -- Validate posteriorTest --
    validateattributes(logisticRegressionResult.posteriorTest, {'double'}, ...
        POSTERIOR_MATRIX_ATTRIBUTES, mfilename, 'logisticRegressionResult.posteriorTest');
    assert(isequal(size(logisticRegressionResult.posteriorTest), [nTest, m]), ...
        'logisticRegressionResult.posteriorTest must have dimension nTest x m.');
    assert(all(abs(sum(logisticRegressionResult.posteriorTest, 2) - 1) <= PROBABILITY_SUM_TOLERANCE), ...
        'Rows of logisticRegressionResult.posteriorTest must sum to 1 within tolerance.');

    % -- Validate label consistency with posterior argmax --
    [~, posteriorTrainArgmax] = max(logisticRegressionResult.posteriorTrain, [], 2);
    [~, posteriorTestArgmax] = max(logisticRegressionResult.posteriorTest, [], 2);

    expectedYHatTrain = classLabels(posteriorTrainArgmax);
    expectedYHatTest = classLabels(posteriorTestArgmax);

    assert(isequal(logisticRegressionResult.yHatTrain, expectedYHatTrain), ...
        'logisticRegressionResult.yHatTrain must match the argmax of posteriorTrain mapped through classLabels.');
    assert(isequal(logisticRegressionResult.yHatTest, expectedYHatTest), ...
        'logisticRegressionResult.yHatTest must match the argmax of posteriorTest mapped through classLabels.');
end