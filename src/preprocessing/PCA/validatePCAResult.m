function validatePCAResult(pcaResult, rawData, pcaTransform)
    % VALIDATEPCARESULT Validates pcaResult constructed by applyPCATransform.
    % 
    % INPUT: 
    %  pcaResult struct with fields:
    %      .Xtrain (nTrain x k double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x k double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - projected dataset dimension
    %      .pcaTransform (struct)      - unchanged from implementation
    % 
    %  rawData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  pcaTransform struct with fields: 
    %      .mu (1 x d double) - mean vector used for centering dataset
    %      .coeff (d x k double) - principal directions
    %      .explained (1 x k) - explained variance percentages
    %      .originalDimension (int) - original dataset dimension
    %      .projectedDimension (int) - projected dimension after PCA
    %      .eigenvalues (1 x k) - eigenvalues associated with PCA transform

    % -- Validate structure of pcaResult --
    if ~isstruct(pcaResult)
        error('validatePCAResult:InvalidType', ...
            'pcaResult must be a struct.');
    end

    if ~isfield(pcaResult, 'Xtrain')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have an ''Xtrain'' field.');
    end

    if ~isfield(pcaResult, 'Xtest')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have an ''Xtest'' field.');
    end

    if ~isfield(pcaResult, 'ytrain')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have a ''ytrain'' field.');
    end

    if ~isfield(pcaResult, 'ytest')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have a ''ytest'' field.');
    end

    if ~isfield(pcaResult, 'ntrain')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have an ''ntrain'' field.');
    end
    
    if ~isfield(pcaResult, 'ntest')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have an ''ntest'' field.');
    end

    if ~isfield(pcaResult, 'd')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have a ''d'' field.');
    end

    if ~isfield(pcaResult, 'pcaTransform')
        error('validatePCAResult:MissingField', ...
            'pcaResult must have a ''pcaTransform'' field.');
    end

    % -- Validate pcaResult field values -- 

    % Define attributes
    DATA_MATRIX_ATTRIBUTES = {'matrix', 'real', '2d', 'finite',  'double'};
    LABEL_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};

    % Validate pcaTransform metadata field
    validatePCATransform(pcaResult.pcaTransform, rawData.Xtrain);
    assert(isequal(pcaResult.pcaTransform, pcaTransform),'pcaResult.pcaTransform must equal the supplied pcaTransform');

    % Validate Xtrain
    validateattributes(pcaResult.Xtrain, {'numeric'}, DATA_MATRIX_ATTRIBUTES, mfilename, 'pcaResult.Xtrain');
    assert(isequal(size(pcaResult.Xtrain), [rawData.ntrain, pcaTransform.projectedDimension]), 'pcaResult.Xtrain must have dimension ntrain x k');

    % Validate ytrain
    validateattributes(pcaResult.ytrain, {'numeric'}, LABEL_VECTOR_ATTRIBUTES, mfilename, 'pcaResult.ytrain');
    assert(numel(pcaResult.ytrain) == rawData.ntrain, 'pcaResult.ytrain must have dimension ntrain x 1');
     assert(isequal(pcaResult.ytrain, rawData.ytrain), 'pcaResult.ytrain must equal rawData.ytrain');

    % Validate Xtest
    validateattributes(pcaResult.Xtest, {'numeric'}, DATA_MATRIX_ATTRIBUTES, mfilename, 'pcaResult.Xtest');
    assert(isequal(size(pcaResult.Xtest), [rawData.ntest, pcaTransform.projectedDimension]), 'pcaResult.Xtest must have dimension ntest x k');

    % Validate ytest
    validateattributes(pcaResult.ytest, {'numeric'}, LABEL_VECTOR_ATTRIBUTES, mfilename, 'pcaResult.ytest');
    assert(numel(pcaResult.ytest) == rawData.ntest, 'pcaResult.ytest must have dimension ntest x 1');
    assert(isequal(pcaResult.ytest, rawData.ytest), 'pcaResult.ytest must equal rawData.ytest');

    % Validate ntrain
    assert(pcaResult.ntrain == rawData.ntrain, 'pcaResult.ntrain must equal rawData.ntrain');

    % Validate ntest
    assert(pcaResult.ntest == rawData.ntest, 'pcaResult.ntest must equal rawData.ntest');

    % Validate d
    assert(pcaResult.d == pcaTransform.projectedDimension, 'pcaResult.d must equal transformed dimension pcaTransform.projectedDimension');
end