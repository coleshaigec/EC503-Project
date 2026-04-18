function validatePCASpec(pcaSpec)
    %VALIDATEPCASPEC Validate pcaSpec member of atomic run specification.
    %   VALIDATEPCASPEC(PCASPEC) throws an error if PCASPEC is not a legal,
    %   fully resolved pca configuration for single-run pipeline execution.

     if ~isstruct(pcaSpec)
        error('validatePCASpec:InvalidType', ...
            'pcaSpec must be a struct.');
    end

    if ~isfield(pcaSpec, 'enabled')
        error('validatePCASpec:MissingField', ...
            'pcaSpec must have an ''enabled'' field.');
    end

    if ~(islogical(pcaSpec.enabled) && isscalar(pcaSpec.enabled))
        error('validatePCASpec:InvalidFieldType', ...
            'pcaSpec.enabled must be a logical scalar.');
    end

    if ~isfield(pcaSpec, 'varianceThreshold')
    error('validatePCASpec:MissingField', ...
        'pcaSpec must have a ''varianceThreshold'' field.');
    end

    if ~isfield(pcaSpec, 'selectionMode')
        error('validatePCASpec:MissingField', ...
        'pcaSpec must have a ''selectionMode'' field.');
    end

    if ~isfield(pcaSpec, 'fixedNumComponents')
        error('validatePCASpec:MissingField', ...
        'pcaSpec must have a ''fixedNumComponents'' field.');
    end

    if ~ismember(pcaSpec.selectionMode, ["varianceThreshold", "fixedNumComponents"])
        error('validatePCASpec:InvalidFieldValue', ...
                'pcaSpec.selectionMode must be one of ''varianceThreshold'' or ''fixedNumComponents''.');
    end


    varianceThresholdAttributes = {'scalar', 'finite', '>', 0, '<=', 1};
    numComponentsAttributes = {'scalar', 'finite', 'integer' '>', 0};
    validateattributes(pcaSpec.varianceThreshold, {'numeric'}, varianceThresholdAttributes, mfilename, 'pcaSpec.varianceThreshold');
    validateattributes(pcaSpec.fixedNumComponents, {'numeric'}, numComponentsAttributes, mfilename, 'pcaSpec.fixedNumComponents');

end