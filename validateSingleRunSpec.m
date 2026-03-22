function validateSingleRunSpec(spec)
    %VALIDATESINGLERUNSPEC Validate resolved atomic run specification.
    %   VALIDATESINGLERUNSPEC(SPEC) throws an error if SPEC is not a legal,
    %   fully resolved single-run configuration for pipeline execution.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate high-level structure  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~isstruct(spec)
        error('validateSingleRunSpec:InvalidType', ...
            'singleRunSpec must be a struct.');
    end

    if ~isfield(spec, 'id')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have an ''id'' field.');
    end

    if ~isfield(spec, 'experimentKey')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have an ''experimentKey'' field.');
    end

    if ~isfield(spec, 'warningHorizon')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''warningHorizon'' field.');
    end

    if ~isfield(spec, 'noiseSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''noiseSpec'' field.');
    end

    if ~isfield(spec, 'missingnessSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''missingnessSpec'' field.');
    end

    if ~isfield(spec, 'pcaSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''pcaSpec'' field.');
    end

    if ~isfield(spec, 'imbalanceSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have an ''imbalanceSpec'' field.');
    end

    if ~isfield(spec, 'modelSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''modelSpec'' field.');
    end

    if ~isfield(spec, 'datasetSpec')
        error('validateSingleRunSpec:MissingField', ...
            'singleRunSpec must have a ''datasetSpec'' field.');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Define attributes for modular validation  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    POSITIVE_INTEGER_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer'};
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate metadata fields  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    validateattributes(spec.id, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'spec.id');
    validateattributes(spec.experimentKey, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'spec.experimentKey');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate warning horizon  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    validateattributes(spec.warningHorizon, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'spec.warningHorizon');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate pipeline specification structs  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    validateNoiseSpec(spec.noiseSpec);
    validateMissingnessSpec(spec.missingnessSpec);
    

    





end