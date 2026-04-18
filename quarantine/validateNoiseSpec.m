function validateNoiseSpec(noiseSpec)
    %VALIDATENOISESPEC Validate noiseSpec member of atomic run specification.
    %   VALIDATENOISESPEC(NOISESPEC) throws an error if NOISESPEC is not a legal,
    %   fully resolved noise configuration for single-run pipeline execution.

    allowableNoiseTypes = ["gaussian", "impulse", "hybrid"];

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
            'noiseSpec.enabled must be a logical scalar.');
    end

    if noiseSpec.enabled
        if ~isfield(noiseSpec, 'noiseType')
            error('validateNoiseSpec:MissingField', ...
                'noiseSpec must have a ''noiseType'' field when noise is enabled.');
        end

        if ~(ischar(noiseSpec.noiseType) || ...
                (isstring(noiseSpec.noiseType) && isscalar(noiseSpec.noiseType)))
            error('validateNoiseSpec:InvalidFieldType', ...
                'noiseSpec.noiseType must be a character vector or string scalar.');
        end

        noiseType = lower(string(noiseSpec.noiseType));

        if ~ismember(noiseType, allowableNoiseTypes)
            error('validateNoiseSpec:InvalidFieldValue', ...
                ['noiseSpec.noiseType must be one of ', ...
                 '{''gaussian'', ''impulse'', ''hybrid''}.']);
        end

        if noiseType == "gaussian"
            if ~isfield(noiseSpec, 'gaussianParameters')
                error('validateNoiseSpec:MissingField', ...
                    ['If noiseSpec.noiseType is ''gaussian'', noiseSpec must ', ...
                     'have a ''gaussianParameters'' field.']);
            end
            validateGaussianNoiseParameters(noiseSpec.gaussianParameters);
        end

        if noiseType == "impulse"
            if ~isfield(noiseSpec, 'impulseParameters')
                error('validateNoiseSpec:MissingField', ...
                    ['If noiseSpec.noiseType is ''impulse'', noiseSpec must ', ...
                     'have an ''impulseParameters'' field.']);
            end
            validateImpulseNoiseParameters(noiseSpec.impulseParameters);
        end

        if noiseType == "hybrid"
            if ~isfield(noiseSpec, 'gaussianParameters')
                error('validateNoiseSpec:MissingField', ...
                    ['If noiseSpec.noiseType is ''hybrid'', noiseSpec must ', ...
                     'have a ''gaussianParameters'' field.']);
            end

            if ~isfield(noiseSpec, 'impulseParameters')
                error('validateNoiseSpec:MissingField', ...
                    ['If noiseSpec.noiseType is ''hybrid'', noiseSpec must ', ...
                     'have an ''impulseParameters'' field.']);
            end

            validateGaussianNoiseParameters(noiseSpec.gaussianParameters);
            validateImpulseNoiseParameters(noiseSpec.impulseParameters);
        end
    else
        if numel(fieldnames(noiseSpec)) ~= 1
            error('validateNoiseSpec:InvalidStruct', ...
                ['When noiseSpec.enabled is false, noiseSpec may contain ', ...
                 'only the ''enabled'' field.']);
        end
    end
end