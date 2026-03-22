function validateImpulseNoiseParameters(impulseParameters)
    %VALIDATEIMPULSENOISEPARAMETERS Validate ImpulseParameters member of atomic run noiseSpec.
    %   VALIDATEIMPULSENOISEPARAMETERS(IMPULSEPARAMETERS) throws an error if IMPULSEPARAMETERS is not a legal,
    %   fully resolved impulse noise configuration for single-run pipeline execution.

    %%%%%%%%%%%%%%%%%%%%
    %%% NOTE TO SELF %%%
    %%%%%%%%%%%%%%%%%%%%

    %%% We will revisit this later when impulse noise architecture is more
    %%% clear

    % Confirm struct
    if ~isstruct(impulseParameters)
            error('validateImpulseNoiseParameters:InvalidType', ...
                'impulseParameters must be a struct.');
    end
end