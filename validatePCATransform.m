function validatePCATransform(pcaTransform, Xtrain)
    % VALIDATEPCATRANSFORM Validates pcaTransform constructed by fitPCATransform.
    % 
    % INPUT: 
    %  pcaTransform struct with fields: 
    %      .mu (1 x d double) - mean vector used for centering dataset
    %      .coeff (d x k double) - principal directions
    %      .explained (1 x k) - explained variance percentages
    %      .originalDimension (int) - original dataset dimension
    %      .projectedDimension (int) - projected dimension after PCA
    %      .eigenvalues (1 x k) - eigenvalues associated with PCA transform
    % 
    %  Xtrain (nTrain x d double) - training feature matrix 

    % -- Validate structure of pcaTransform --
     if ~isstruct(pcaTransform)
        error('validatePCATransform:InvalidType', ...
            'pcaTransform must be a struct.');
    end

    if ~isfield(pcaTransform, 'mu')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have a ''mu'' field.');
    end

    if ~isfield(pcaTransform, 'coeff')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have a ''coeff'' field.');
    end

    if ~isfield(pcaTransform, 'explained')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have an ''explained'' field.');
    end

    if ~isfield(pcaTransform, 'originalDimension')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have an ''originalDimension'' field.');
    end

    if ~isfield(pcaTransform, 'projectedDimension')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have a ''projectedDimension'' field.');
    end

    if ~isfield(pcaTransform, 'eigenvalues')
        error('validatePCATransform:MissingField', ...
            'pcaTransform must have an ''eigenvalues'' field.');
    end

    % -- Validate pcaTransform field values --
    [~, d] = size(Xtrain); % use Xtrain as source of truth
    POSITIVE_INTEGER_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer'};
    GENERAL_DOUBLE_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double'};
    EXPLAINED_VECTOR_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'positive', 'double', '>', 0, '<=', 100};
    DOUBLE_MATRIX_ATTRIBUTES = {'matrix', 'real', '2d', 'finite',  'double'};
    EIGENVALUES_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double', '>=', 0};

    % Validate mu
    assert(isequal(size(pcaTransform.mu), [1,d]), 'mu must be 1 x d.');
    validateattributes(pcaTransform.mu, {'numeric'}, GENERAL_DOUBLE_VECTOR_ATTRIBUTES, mfilename, 'pcaTransform.mu');
    
    % Validate projectedDimension
    validateattributes(pcaTransform.projectedDimension, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'pcaTransform.projectedDimension');
    k = pcaTransform.projectedDimension;

    % Validate originalDimension
    validateattributes(pcaTransform.originalDimension, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'pcaTransform.originalDimension');
    assert(pcaTransform.originalDimension == d, 'originalDimension must match the dimension of the original dataset.');
    assert(pcaTransform.originalDimension >= k, 'projectedDimension must be less than or equal to original dimension.');

    % validate coeff
    assert(isequal(size(pcaTransform.coeff), [d,k]), 'coeff must be d x k');
    validateattributes(pcaTransform.coeff, {'numeric'}, DOUBLE_MATRIX_ATTRIBUTES, mfilename, 'pcaTransform.coeff');
    identityMatrix = eye(k);
    isOrthonormal = norm(pcaTransform.coeff.' * pcaTransform.coeff - identityMatrix, 'fro') <= 1e-6;
    assert(isOrthonormal, 'pcaTransform.coeff must have orthonormal columns.');
    

    % validate explained
    assert(isequal(size(pcaTransform.explained), [1,k]), 'explained must be 1 x k');
    validateattributes(pcaTransform.explained, {'numeric'}, EXPLAINED_VECTOR_ATTRIBUTES, mfilename, 'pcaTransform.explained');

    % Validate eigenvalues
    assert(isequal(size(pcaTransform.eigenvalues), [1,k]), 'coeff must be d x k');
    validateattributes(pcaTransform.eigenvalues, {'numeric'}, EIGENVALUES_ATTRIBUTES, mfilename, 'pcaTransform.eigenvalues');
end