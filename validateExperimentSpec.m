function validateExperimentSpec(spec)
    %VALIDATEEXPERIMENTSPEC Validate resolved plan of experimentation.
    %   VALIDATEEXPERIMENTSPEC(SPEC) throws an error if SPEC is not a legal,
    %   fully resolved experimental configuration for multi-run pipeline execution.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate high-level structure  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~isstruct(spec)
        error('validateExperimentSpec:InvalidType', ...
            'experimentSpec must be a struct.');
    end

    if ~isfield(spec, 'id')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have an ''id'' field.');
    end

    if ~isfield(spec, 'name')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''name'' field.');
    end

    if ~isfield(spec, 'warningHorizons')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''warningHorizons'' field.');
    end

    if ~isfield(spec, 'noiseOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''noiseOptions'' field.');
    end

    if ~isfield(spec, 'missingnessOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''missingnessOptions'' field.');
    end

    if ~isfield(spec, 'pcaOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''pcaOptions'' field.');
    end

    if ~isfield(spec, 'imbalanceOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have an ''imbalanceOptions'' field.');
    end

    if ~isfield(spec, 'modelOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''modelOptions'' field.');
    end

    if ~isfield(spec, 'datasetOptions')
        error('validateExperimentSpec:MissingField', ...
            'experimentSpec must have a ''datasetOptions'' field.');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate metadata fields  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    POSITIVE_INTEGER_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer'};
    
    
    validateattributes(spec.id, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'spec.id');
    
    if ~(isstring(spec.name) && isscalar(spec.name) && strlength(spec.name) > 0)
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.name must be a non-empty string scalar.');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate warning horizons  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    POSITIVE_INTEGER_VECTOR_ATTRIBUTES = {'vector', 'nonempty', 'finite', 'positive', 'integer'};
    validateattributes(spec.warningHorizons, {'numeric'}, POSITIVE_INTEGER_VECTOR_ATTRIBUTES, mfilename, 'spec.warningHorizons');

    if numel(unique(spec.warningHorizons)) ~= numel(spec.warningHorizons)
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.warningHorizons may not contain duplicate values.');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate options structs  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~(isvector(spec.noiseOptions) && numel(spec.noiseOptions) > 0 && isstruct(spec.noiseOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.noiseOptions must be a non-empty struct array.');
    end

    if ~(isvector(spec.missingnessOptions) && numel(spec.missingnessOptions) > 0 && isstruct(spec.missingnessOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.missingnessOptions must be a non-empty struct array.');
    end

    if ~(isvector(spec.pcaOptions) && numel(spec.pcaOptions) > 0 && isstruct(spec.pcaOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.pcaOptions must be a non-empty struct array.');
    end

    if ~(isvector(spec.imbalanceOptions) && numel(spec.imbalanceOptions) > 0 && isstruct(spec.imbalanceOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.imbalanceOptions must be a non-empty struct array.');
    end

    if ~(isvector(spec.modelOptions) && numel(spec.modelOptions) > 0 && isstruct(spec.modelOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.modelOptions must be a non-empty struct array.');
    end

    if ~(isvector(spec.datasetOptions) && numel(spec.datasetOptions) > 0 && isstruct(spec.datasetOptions))
        error('validateExperimentSpec:InvalidFieldValue', ...
            'experimentSpec.datasetOptions must be a non-empty struct array.');
    end

    % Ensure that all spec objects are valid
    for i = 1 : numel(spec.noiseOptions)
        validateNoiseSpec(spec.noiseOptions(i));
    end

    for i = 1 : numel(spec.missingnessOptions)
        validateMissingnessSpec(spec.missingnessOptions(i));
    end

    for i = 1 : numel(spec.pcaOptions)
        validatePCASpec(spec.pcaOptions(i));
    end

    for i = 1 : numel(spec.imbalanceOptions)
        validateImbalanceSpec(spec.imbalanceOptions(i));
    end

    for i = 1 : numel(spec.modelOptions)
        validateModelSpec(spec.modelOptions(i));
    end

    for i = 1 : numel(spec.datasetOptions)
        validateDatasetSpec(spec.datasetOptions(i));
    end
end