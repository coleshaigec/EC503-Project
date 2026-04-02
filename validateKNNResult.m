function validateKNNResult(knnResult, dataset, knnModel)
    % VALIDATEKNNRESULT Validates kNN prediction result produced by computeKNNPredictions.
    %
    % INPUTS
    %  knnResult struct with fields
    %      .yHatTrain (ntrain x 1 double)           - predicted training labels
    %      .yHatTest  (ntest x 1 double)            - predicted test labels
    %      .knnDistancesTrain (ntrain x k double)   - distances of k-nearest neighbors of each training sample
    %      .knnDistancesTest  (ntest x k double)    - distances of k-nearest neighbors of each test sample
    %      .knnIndicesTrain   (ntrain x k int)      - indices of k-nearest neighbors of each training point
    %      .knnIndicesTest    (ntest x k int)       - indices of k-nearest neighbors of each test point
    %      .knnModel struct with fields
    %          .Xtrain (nTrain x d double)          - training feature matrix
    %          .ytrain (nTrain x 1 double)          - training label vector
    %          .k (int > 0)                         - number of NNs used
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
    %  knnModel struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .k (int > 0)                - number of NNs used

    % -- Validate structure of knnResult --
    if ~isstruct(knnResult)
        error('validateKNNResult:InvalidType', ...
            'knnResult must be a struct.');
    end

    if ~isfield(knnResult, 'yHatTrain')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''yHatTrain'' field.');
    end

    if ~isfield(knnResult, 'yHatTest')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''yHatTest'' field.');
    end

    if ~isfield(knnResult, 'knnDistancesTrain')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''knnDistancesTrain'' field.');
    end

    if ~isfield(knnResult, 'knnDistancesTest')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''knnDistancesTest'' field.');
    end

    if ~isfield(knnResult, 'knnIndicesTrain')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''knnIndicesTrain'' field.');
    end

    if ~isfield(knnResult, 'knnIndicesTest')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''knnIndicesTest'' field.');
    end

    if ~isfield(knnResult, 'knnModel')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''knnModel'' field.');
    end

    % -- Re-validate supplied kNN model and recover dimensions --
    validateKNNModel(knnModel, dataset, struct('k', knnModel.k));

    nTrain = dataset.ntrain;
    nTest = dataset.ntest;
    k = knnModel.k;
    validClassLabels = unique(dataset.ytrain);

    % -- Define attributes --
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    DISTANCE_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double', 'nonnegative'};
    INDEX_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'integer', 'positive'};

    % -- Validate yHatTrain --
    validateattributes(knnResult.yHatTrain, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'knnResult.yHatTrain');
    assert(numel(knnResult.yHatTrain) == nTrain, ...
        'knnResult.yHatTrain must have dimension nTrain x 1.');
    assert(all(ismember(knnResult.yHatTrain, validClassLabels)), ...
        'knnResult.yHatTrain must contain only labels present in dataset.ytrain.');

    % -- Validate yHatTest --
    validateattributes(knnResult.yHatTest, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'knnResult.yHatTest');
    assert(numel(knnResult.yHatTest) == nTest, ...
        'knnResult.yHatTest must have dimension nTest x 1.');
    assert(all(ismember(knnResult.yHatTest, validClassLabels)), ...
        'knnResult.yHatTest must contain only labels present in dataset.ytrain.');

    % -- Validate knnDistancesTrain --
    validateattributes(knnResult.knnDistancesTrain, {'double'}, ...
        DISTANCE_MATRIX_ATTRIBUTES, mfilename, 'knnResult.knnDistancesTrain');
    assert(isequal(size(knnResult.knnDistancesTrain), [nTrain, k]), ...
        'knnResult.knnDistancesTrain must have dimension nTrain x k.');

    % -- Validate knnDistancesTest --
    validateattributes(knnResult.knnDistancesTest, {'double'}, ...
        DISTANCE_MATRIX_ATTRIBUTES, mfilename, 'knnResult.knnDistancesTest');
    assert(isequal(size(knnResult.knnDistancesTest), [nTest, k]), ...
        'knnResult.knnDistancesTest must have dimension nTest x k.');

    % -- Validate knnIndicesTrain --
    validateattributes(knnResult.knnIndicesTrain, {'numeric'}, ...
        INDEX_MATRIX_ATTRIBUTES, mfilename, 'knnResult.knnIndicesTrain');
    assert(isequal(size(knnResult.knnIndicesTrain), [nTrain, k]), ...
        'knnResult.knnIndicesTrain must have dimension nTrain x k.');
    assert(all(knnResult.knnIndicesTrain(:) <= nTrain), ...
        'knnResult.knnIndicesTrain must contain indices in the range 1:nTrain.');

    % -- Validate knnIndicesTest --
    validateattributes(knnResult.knnIndicesTest, {'numeric'}, ...
        INDEX_MATRIX_ATTRIBUTES, mfilename, 'knnResult.knnIndicesTest');
    assert(isequal(size(knnResult.knnIndicesTest), [nTest, k]), ...
        'knnResult.knnIndicesTest must have dimension nTest x k.');
    assert(all(knnResult.knnIndicesTest(:) <= nTrain), ...
        'knnResult.knnIndicesTest must contain indices in the range 1:nTrain.');

    % -- Validate ordering of distances --
    isTrainSorted = all(all(diff(knnResult.knnDistancesTrain, 1, 2) >= 0));
    isTestSorted = all(all(diff(knnResult.knnDistancesTest, 1, 2) >= 0));
    assert(isTrainSorted, ...
        'knnResult.knnDistancesTrain must be sorted in nondecreasing order across neighbors.');
    assert(isTestSorted, ...
        'knnResult.knnDistancesTest must be sorted in nondecreasing order across neighbors.');

    % -- Validate self-neighbor exclusion for training predictions --
    trainRowIndices = (1:nTrain).';
    selfIncludedMask = any(knnResult.knnIndicesTrain == trainRowIndices, 2);
    assert(~any(selfIncludedMask), ...
        'knnResult.knnIndicesTrain must exclude the sample itself from its own neighbor set.');

    % -- Validate attached model metadata --
    assert(isequal(knnResult.knnModel, knnModel), ...
        'knnResult.knnModel must equal the supplied knnModel.');

    % -- Validate consistency between attached model and supplied model --
    assert(isequal(knnResult.knnModel.Xtrain, dataset.Xtrain), ...
        'knnResult.knnModel.Xtrain must equal dataset.Xtrain.');
    assert(isequal(knnResult.knnModel.ytrain, dataset.ytrain), ...
        'knnResult.knnModel.ytrain must equal dataset.ytrain.');
end