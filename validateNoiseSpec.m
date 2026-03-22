function validateNoiseSpec(noiseSpec)
    %VALIDATENOISESPEC Validate noiseSpec member of atomic run specification.
    %   VALIDATENOISESPEC(NOISESPEC) throws an error if NOISESPEC is not a legal,
    %   fully resolved noise configuration for single-run pipeline execution.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate high-level structure  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ~isstruct(noiseSpec)
        error('validateNoiseSpec:InvalidType', ...
            'noiseSpec must be a struct.');
    end

    if ~isfield(noiseSpec, 'enabled')
        error('validateNoiseSpec:MissingField', ...
            'noiseSpec must have an ''enabled'' field.');
    end

    if ~(islogical(noiseSpec.enabled) && isscalar(noiseSpec.enabled))
        error('validateNoiseSpec:InvalidFieldType', ...
            '''enabled'' field in noiseSpec must be a logical scalar.');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Validate field values based on specified noise type  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ALLOWABLE_NOISE_TYPES = {'gaussian', 'impulse', 'hybrid'};

    if noiseSpec.enabled
        if ~isfield(noiseSpec, 'noiseType')
            error('validateNoiseSpec:MissingField', ...
                'noiseSpec must have a ''noiseType'' field.');
        end

        if ~ismember(noiseSpec.noiseType, ALLOWABLE_NOISE_TYPES)
            error('validateNoiseSpec:InvalidFieldValue', ...
            '''noiseType'' field in noiseSpec must be in {''gaussian'', ''impulse'', ''hybrid''}.');
        end

        % Validate parameters for Gaussian noise, if selected
        if noiseSpec.noiseType == "gaussian"
            if ~isfield(noiseSpec, 'gaussianParameters')
                error('validateNoiseSpec:MissingField', ...
                     'If noiseSpec.noiseType is ''gaussian'', noiseSpec must have a ''gaussianParameters'' field.');
            end

            
        end
    else
        % If noise is not enabled, no other fields may be in noiseSpec
        if numel(fieldnames(noiseSpec)) ~= 1
            error('validateNoiseSpec:InvalidFieldType', ...
                'When noise is disabled, noiseSpec may only have an ''enabled'' field.');
        end
    end

    
end