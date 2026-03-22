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

    if pcaSpec.enabled
        if ~isfield(pcaSpec, 'varianceThreshold')
        error('validatePCASpec:MissingField', ...
            'pcaSpec must have a ''varianceThreshold'' field when PCA is enabled.');
        end
        varianceThresholdAttributes = {'scalar', 'finite', '>=', 0, '<=', 1};
        validateattributes(pcaSpec.varianceThreshold, {'numeric'}, varianceThresholdAttributes, mfilename, 'pcaSpec.varianceThreshold');
    elseif numel(fieldnames(pcaSpec)) ~= 1
            error('validatePCASpec:InvalidStruct', ...
                ['When pcaSpec.enabled is false, pcaSpec may contain ', ...
                 'only the ''enabled'' field.']);
    end
end