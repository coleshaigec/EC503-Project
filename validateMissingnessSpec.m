function validateMissingnessSpec(missingnessSpec)
    %VALIDATEMISSINGNESSSPEC Validate missingnessSpec member of atomic run specification.
    %   VALIDATEMISSINGNESSSPEC(MISSINGNESSSPEC) throws an error if
    %   MISSINGNESSSPEC is not a legal, fully resolved missingness
    %   configuration for single-run pipeline execution.

    allowableMissingnessTypes = ["MCAR", "MNAR"];

    if ~isstruct(missingnessSpec)
        error('validateMissingnessSpec:InvalidType', ...
            'missingnessSpec must be a struct.');
    end

    if ~isfield(missingnessSpec, 'enabled')
        error('validateMissingnessSpec:MissingField', ...
            'missingnessSpec must have an ''enabled'' field.');
    end

    if ~(islogical(missingnessSpec.enabled) && isscalar(missingnessSpec.enabled))
        error('validateMissingnessSpec:InvalidFieldType', ...
            'missingnessSpec.enabled must be a logical scalar.');
    end

    if missingnessSpec.enabled
        if ~isfield(missingnessSpec, 'missingnessType')
            error('validateMissingnessSpec:MissingField', ...
                ['missingnessSpec must have a ''missingnessType'' field ', ...
                 'when missingness is enabled.']);
        end

        if ~(ischar(missingnessSpec.missingnessType) || ...
                (isstring(missingnessSpec.missingnessType) && isscalar(missingnessSpec.missingnessType)))
            error('validateMissingnessSpec:InvalidFieldType', ...
                ['missingnessSpec.missingnessType must be a character ', ...
                 'vector or string scalar.']);
        end

        missingnessType = upper(string(missingnessSpec.missingnessType));

        if ~ismember(missingnessType, allowableMissingnessTypes)
            error('validateMissingnessSpec:InvalidFieldValue', ...
                ['missingnessSpec.missingnessType must be one of ', ...
                 '{''MCAR'', ''MNAR''}.']);
        end

        if missingnessType == "MCAR"
            if ~isfield(missingnessSpec, 'mcarParameters')
                error('validateMissingnessSpec:MissingField', ...
                    ['missingnessSpec must have an ''mcarParameters'' field ', ...
                     'when missingness type is MCAR.']);
            end
            validateMCARSpec(missingnessSpec.mcarParameters);
        end

        if missingnessType == "MNAR"
            if ~isfield(missingnessSpec, 'mnarParameters')
                error('validateMissingnessSpec:MissingField', ...
                    ['missingnessSpec must have an ''mnarParameters'' field ', ...
                     'when missingness type is MNAR.']);
            end
            validateMNARSpec(missingnessSpec.mnarParameters);
        end
    else
        if numel(fieldnames(missingnessSpec)) ~= 1
            error('validateMissingnessSpec:InvalidStruct', ...
                ['When missingnessSpec.enabled is false, missingnessSpec may ', ...
                 'contain only the ''enabled'' field.']);
        end
    end
end