function validateKNNResult(knnResult, dataset, knnModel)
    % VALIDATEKNNRESULT Validates kNN prediction result produced by computeKNNPredictions.
    %
    % INPUTS
    %  knnResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .knnDistances (n x k double) - distances of k-nearest neighbors of each sample
    %          .knnIndices (n x k int)      - indices of k-nearest neighbors of each sample
    %          .knnModel struct with fields
    %              .Xtrain (nTrain x d double) - training feature matrix
    %              .ytrain (nTrain x 1 double) - training label vector
    %              .k (int > 0)                - number of NNs used
    %
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - label vector
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

    if ~isfield(knnResult, 'yHat')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''yHat'' field.');
    end

    if ~isfield(knnResult, 'metadata')
        error('validateKNNResult:MissingField', ...
            'knnResult must have a ''metadata'' field.');
    end

    if ~isstruct(knnResult.metadata)
        error('validateKNNResult:InvalidType', ...
            'knnResult.metadata must be a struct.');
    end

    if ~isfield(knnResult.metadata, 'knnDistances')
        error('validateKNNResult:MissingField', ...
            'knnResult.metadata must have a ''knnDistances'' field.');
    end

    if ~isfield(knnResult.metadata, 'knnIndices')
        error('validateKNNResult:MissingField', ...
            'knnResult.metadata must have a ''knnIndices'' field.');
    end

    if ~isfield(knnResult.metadata, 'knnModel')
        error('validateKNNResult:MissingField', ...
            'knnResult.metadata must have a ''knnModel'' field.');
    end

    % -- Validate dataset --
    if ~isstruct(dataset)
        error('validateKNNResult:InvalidType', ...
            'dataset must be a struct.');
    end

    if ~isfield(dataset, 'X')
        error('validateKNNResult:MissingField', ...
            'dataset must have an ''X'' field.');
    end

    if ~isfield(dataset, 'y')
        error('validateKNNResult:MissingField', ...
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

    % -- Re-validate supplied kNN model and recover dimensions --
    validateKNNModel(knnModel, ...
        struct('Xtrain', knnModel.Xtrain, 'ytrain', knnModel.ytrain), ...
        struct('k', knnModel.k));

    nTrain = size(knnModel.Xtrain, 1);
    k = knnModel.k;
    validClassLabels = unique(knnModel.ytrain);

    % -- Define attributes --
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    DISTANCE_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double', 'nonnegative'};
    INDEX_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'integer', 'positive'};

    % -- Validate yHat --
    validateattributes(knnResult.yHat, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'knnResult.yHat');
    assert(numel(knnResult.yHat) == n, ...
        'knnResult.yHat must have dimension n x 1.');
    assert(all(ismember(knnResult.yHat, validClassLabels)), ...
        'knnResult.yHat must contain only labels present in knnModel.ytrain.');

    % -- Validate knnDistances --
    validateattributes(knnResult.metadata.knnDistances, {'double'}, ...
        DISTANCE_MATRIX_ATTRIBUTES, mfilename, 'knnResult.metadata.knnDistances');
    assert(isequal(size(knnResult.metadata.knnDistances), [n, k]), ...
        'knnResult.metadata.knnDistances must have dimension n x k.');

    % -- Validate knnIndices --
    validateattributes(knnResult.metadata.knnIndices, {'numeric'}, ...
        INDEX_MATRIX_ATTRIBUTES, mfilename, 'knnResult.metadata.knnIndices');
    assert(isequal(size(knnResult.metadata.knnIndices), [n, k]), ...
        'knnResult.metadata.knnIndices must have dimension n x k.');
    assert(all(knnResult.metadata.knnIndices(:) <= nTrain), ...
        'knnResult.metadata.knnIndices must contain indices in the range 1:nTrain.');

    % -- Validate ordering of distances --
    isSorted = all(all(diff(knnResult.metadata.knnDistances, 1, 2) >= 0));
    assert(isSorted, ...
        'knnResult.metadata.knnDistances must be sorted in nondecreasing order across neighbors.');

    % -- Validate attached model metadata --
    assert(isequal(knnResult.metadata.knnModel, knnModel), ...
        'knnResult.metadata.knnModel must equal the supplied knnModel.');

    % -- Validate consistency between attached model and supplied model --
    assert(isequal(knnResult.metadata.knnModel.Xtrain, knnModel.Xtrain), ...
        'knnResult.metadata.knnModel.Xtrain must equal knnModel.Xtrain.');
    assert(isequal(knnResult.metadata.knnModel.ytrain, knnModel.ytrain), ...
        'knnResult.metadata.knnModel.ytrain must equal knnModel.ytrain.');
    assert(knnResult.metadata.knnModel.k == knnModel.k, ...
        'knnResult.metadata.knnModel.k must equal knnModel.k.');

    % -- Validate dimensional compatibility between dataset and model --
    assert(size(knnModel.Xtrain, 2) == d, ...
        'dataset.X and knnModel.Xtrain must have the same number of columns.');

    % -- Validate self-neighbor exclusion when dataset matches model training data --
    isSameDatasetAsTraining = isequal(dataset.X, knnModel.Xtrain) && isequal(dataset.y, knnModel.ytrain);
    if isSameDatasetAsTraining
        rowIndices = (1:nTrain).';
        selfIncludedMask = any(knnResult.metadata.knnIndices == rowIndices, 2);
        assert(~any(selfIncludedMask), ...
            'knnResult.metadata.knnIndices must exclude the sample itself when predicting on the training set.');
    end
end