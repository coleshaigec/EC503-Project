function validateClassificationDataset(classificationDataset, rawData, warningHorizons)
    % VALIDATECLASSIFICATIONDATASET Validates classification dataset produced by remapLabels.
    %
    % INPUTS
    %  classificationDataset struct with fields
    %      .Xtrain (nTrain x d double)             - training feature matrix
    %      .ytrain (nTrain x 1 double)             - remapped training label vector
    %      .Xtest  (nTest x d double)              - test feature matrix
    %      .ytest  (nTest x 1 double)              - remapped test label vector
    %      .ntrain (int)                           - training dataset size
    %      .ntest  (int)                           - test dataset size
    %      .d      (int)                           - dataset dimension
    %      .warningHorizons (m x 1 double)         - metadata field preserving bin edges
    %      .numWarningHorizons (int)               - number of warning horizons considered
    %      .numClasses (int)                       - number of classification bins
    %
    %  rawData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - original training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - original test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  warningHorizons (m x 1 double)  - upper limits for warning horizon bins

    % -- Validate structure of classificationDataset --
    if ~isstruct(classificationDataset)
        error('validateClassificationDataset:InvalidType', ...
            'classificationDataset must be a struct.');
    end

    if ~isfield(classificationDataset, 'Xtrain')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have an ''Xtrain'' field.');
    end

    if ~isfield(classificationDataset, 'ytrain')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''ytrain'' field.');
    end

    if ~isfield(classificationDataset, 'Xtest')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have an ''Xtest'' field.');
    end

    if ~isfield(classificationDataset, 'ytest')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''ytest'' field.');
    end

    if ~isfield(classificationDataset, 'ntrain')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have an ''ntrain'' field.');
    end

    if ~isfield(classificationDataset, 'ntest')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have an ''ntest'' field.');
    end

    if ~isfield(classificationDataset, 'd')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''d'' field.');
    end

    if ~isfield(classificationDataset, 'warningHorizons')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''warningHorizons'' field.');
    end

    if ~isfield(classificationDataset, 'numWarningHorizons')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''numWarningHorizons'' field.');
    end

    if ~isfield(classificationDataset, 'numClasses')
        error('validateClassificationDataset:MissingField', ...
            'classificationDataset must have a ''numClasses'' field.');
    end

    % -- Define attributes --
    DATA_MATRIX_ATTRIBUTES = {'2d', 'real', 'nonempty', 'finite', 'double'};
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    POSITIVE_INTEGER_ATTRIBUTES = {'scalar', 'real', 'finite', 'positive', 'integer'};
    WARNING_HORIZON_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double', 'positive'};

    % -- Validate copied dataset fields --
    validateattributes(classificationDataset.Xtrain, {'double'}, ...
        DATA_MATRIX_ATTRIBUTES, mfilename, 'classificationDataset.Xtrain');
    validateattributes(classificationDataset.Xtest, {'double'}, ...
        DATA_MATRIX_ATTRIBUTES, mfilename, 'classificationDataset.Xtest');
    validateattributes(classificationDataset.ytrain, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'classificationDataset.ytrain');
    validateattributes(classificationDataset.ytest, {'double'}, ...
        LABEL_VECTOR_ATTRIBUTES, mfilename, 'classificationDataset.ytest');
    validateattributes(classificationDataset.ntrain, {'numeric'}, ...
        POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'classificationDataset.ntrain');
    validateattributes(classificationDataset.ntest, {'numeric'}, ...
        POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'classificationDataset.ntest');
    validateattributes(classificationDataset.d, {'numeric'}, ...
        POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'classificationDataset.d');

    % -- Validate warning horizon metadata --
    warningHorizons = sort(unique(warningHorizons), 'ascend');
    validateattributes(warningHorizons, {'numeric'}, ...
        WARNING_HORIZON_ATTRIBUTES, mfilename, 'warningHorizons');

    validateattributes(classificationDataset.warningHorizons, {'numeric'}, ...
        WARNING_HORIZON_ATTRIBUTES, mfilename, 'classificationDataset.warningHorizons');
    assert(isequal(classificationDataset.warningHorizons, warningHorizons), ...
        'classificationDataset.warningHorizons must equal the supplied warningHorizons.');

    validateattributes(classificationDataset.numWarningHorizons, {'numeric'}, ...
        POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'classificationDataset.numWarningHorizons');
    assert(classificationDataset.numWarningHorizons == numel(warningHorizons), ...
        'classificationDataset.numWarningHorizons must equal numel(warningHorizons).');

    validateattributes(classificationDataset.numClasses, {'numeric'}, ...
        POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'classificationDataset.numClasses');
    assert(classificationDataset.numClasses == classificationDataset.numWarningHorizons + 1, ...
        'classificationDataset.numClasses must equal numWarningHorizons + 1.');

    % -- Validate unchanged copied fields against rawData --
    assert(isequal(classificationDataset.Xtrain, rawData.Xtrain), ...
        'classificationDataset.Xtrain must equal rawData.Xtrain.');
    assert(isequal(classificationDataset.Xtest, rawData.Xtest), ...
        'classificationDataset.Xtest must equal rawData.Xtest.');
    assert(classificationDataset.ntrain == rawData.ntrain, ...
        'classificationDataset.ntrain must equal rawData.ntrain.');
    assert(classificationDataset.ntest == rawData.ntest, ...
        'classificationDataset.ntest must equal rawData.ntest.');
    assert(classificationDataset.d == rawData.d, ...
        'classificationDataset.d must equal rawData.d.');

    % -- Validate dimensions --
    assert(isequal(size(classificationDataset.Xtrain), [rawData.ntrain, rawData.d]), ...
        'classificationDataset.Xtrain must have dimension nTrain x d.');
    assert(isequal(size(classificationDataset.Xtest), [rawData.ntest, rawData.d]), ...
        'classificationDataset.Xtest must have dimension nTest x d.');
    assert(numel(classificationDataset.ytrain) == rawData.ntrain, ...
        'classificationDataset.ytrain must have dimension nTrain x 1.');
    assert(numel(classificationDataset.ytest) == rawData.ntest, ...
        'classificationDataset.ytest must have dimension nTest x 1.');

    % -- Validate remapped class labels --
    maxClassLabel = classificationDataset.numClasses;

    assert(all(mod(classificationDataset.ytrain, 1) == 0), ...
        'classificationDataset.ytrain must contain integer-valued class labels.');
    assert(all(mod(classificationDataset.ytest, 1) == 0), ...
        'classificationDataset.ytest must contain integer-valued class labels.');

    assert(all(classificationDataset.ytrain >= 1 & classificationDataset.ytrain <= maxClassLabel), ...
        'classificationDataset.ytrain must contain class labels in the range 1:numClasses.');
    assert(all(classificationDataset.ytest >= 1 & classificationDataset.ytest <= maxClassLabel), ...
        'classificationDataset.ytest must contain class labels in the range 1:numClasses.');

    % -- Validate remapping semantics against original RUL labels --
    expectedYtrain = ones(rawData.ntrain, 1);
    expectedYtest = ones(rawData.ntest, 1);

    for i = 1:numel(warningHorizons)
        expectedYtrain(rawData.ytrain > warningHorizons(i)) = i + 1;
        expectedYtest(rawData.ytest > warningHorizons(i)) = i + 1;
    end

    assert(isequal(classificationDataset.ytrain, expectedYtrain), ...
        'classificationDataset.ytrain does not match the expected warning-horizon remapping.');
    assert(isequal(classificationDataset.ytest, expectedYtest), ...
        'classificationDataset.ytest does not match the expected warning-horizon remapping.');
end