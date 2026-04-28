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

    if ~isstruct(knnResult)
        error('validateKNNResult:InvalidType', ...
            'knnResult must be a struct.');
    end

    requiredResultFields = {'yHat', 'metadata'};
    for i = 1:numel(requiredResultFields)
        if ~isfield(knnResult, requiredResultFields{i})
            error('validateKNNResult:MissingField', ...
                'knnResult must have a ''%s'' field.', requiredResultFields{i});
        end
    end

    if ~isstruct(knnResult.metadata)
        error('validateKNNResult:InvalidType', ...
            'knnResult.metadata must be a struct.');
    end

    requiredMetadataFields = {'knnDistances', 'knnIndices', 'k'};
    for i = 1:numel(requiredMetadataFields)
        if ~isfield(knnResult.metadata, requiredMetadataFields{i})
            error('validateKNNResult:MissingField', ...
                'knnResult.metadata must have a ''%s'' field.', requiredMetadataFields{i});
        end
    end

    if ~isstruct(dataset)
        error('validateKNNResult:InvalidType', ...
            'dataset must be a struct.');
    end

    requiredDatasetFields = {'X', 'y'};
    for i = 1:numel(requiredDatasetFields)
        if ~isfield(dataset, requiredDatasetFields{i})
            error('validateKNNResult:MissingField', ...
                'dataset must have a ''%s'' field.', requiredDatasetFields{i});
        end
    end

    validateattributes(dataset.X, {'numeric'}, ...
        {'2d', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.X');

    validateattributes(dataset.y, {'numeric'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'dataset.y');

    validateattributes(knnResult.yHat, {'numeric'}, ...
        {'vector', 'real', 'nonempty', 'finite'}, ...
        mfilename, 'knnResult.yHat');

    validateattributes(knnResult.metadata.knnDistances, {'numeric'}, ...
        {'2d', 'real', 'nonempty', 'finite', 'nonnegative'}, ...
        mfilename, 'knnResult.metadata.knnDistances');

    validateattributes(knnResult.metadata.knnIndices, {'numeric'}, ...
        {'2d', 'real', 'nonempty', 'finite', 'integer', 'positive'}, ...
        mfilename, 'knnResult.metadata.knnIndices');

    validateattributes(knnResult.metadata.k, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite'}, ...
        mfilename, 'knnResult.metadata.k');

    n = size(dataset.X, 1);
    d = size(dataset.X, 2);
    nTrain = size(knnModel.Xtrain, 1);
    k = knnModel.k;

    assert(numel(dataset.y) == n, ...
        'validateKNNResult:InvalidDatasetYSize', ...
        'dataset.y must have dimension n x 1.');

    assert(isequal(size(knnResult.yHat), [n, 1]), ...
        'validateKNNResult:InvalidYHatSize', ...
        'knnResult.yHat must have dimension n x 1.');

    assert(isequal(size(knnResult.metadata.knnDistances), [n, k]), ...
        'validateKNNResult:InvalidDistanceSize', ...
        'knnResult.metadata.knnDistances must have dimension n x k.');

    assert(isequal(size(knnResult.metadata.knnIndices), [n, k]), ...
        'validateKNNResult:InvalidIndexSize', ...
        'knnResult.metadata.knnIndices must have dimension n x k.');

    assert(knnResult.metadata.k == k, ...
        'validateKNNResult:MetadataKMismatch', ...
        'knnResult.metadata.k must equal knnModel.k.');

    assert(size(knnModel.Xtrain, 2) == d, ...
        'validateKNNResult:FeatureDimensionMismatch', ...
        'dataset.X and knnModel.Xtrain must have the same number of columns.');

    validClassLabels = unique(knnModel.ytrain);

    assert(isequal(validClassLabels, [-1; 1]), ...
        'validateKNNResult:InvalidClassLabels', ...
        'knnModel.ytrain must contain exactly the class labels -1 and +1.');

    assert(all(ismember(knnResult.yHat, validClassLabels)), ...
        'validateKNNResult:InvalidPredictedLabels', ...
        'knnResult.yHat must contain only labels present in knnModel.ytrain.');

    assert(all(knnResult.metadata.knnIndices(:) <= nTrain), ...
        'validateKNNResult:InvalidNeighborIndices', ...
        'knnResult.metadata.knnIndices must contain indices in the range 1:nTrain.');

    isSorted = all(all(diff(knnResult.metadata.knnDistances, 1, 2) >= 0));
    assert(isSorted, ...
        'validateKNNResult:UnsortedDistances', ...
        'knnResult.metadata.knnDistances must be sorted in nondecreasing order across neighbors.');

    isSameDatasetAsTraining = isequal(dataset.X, knnModel.Xtrain) ...
        && isequal(dataset.y(:), knnModel.ytrain);

    if isSameDatasetAsTraining
        rowIndices = (1:nTrain).';
        selfIncludedMask = any(knnResult.metadata.knnIndices == rowIndices, 2);

        assert(~any(selfIncludedMask), ...
            'validateKNNResult:SelfNeighborIncluded', ...
            'knnResult.metadata.knnIndices must exclude the sample itself when predicting on the training set.');
    end
end