function validateGaussianNoiseParameters(gaussianParameters)
    %VALIDATEGAUSSIANNOISEPARAMETERS Validate gaussianParameters member of atomic run noiseSpec.
    %   VALIDATEGAUSSIANNOISEPARAMETERS(GAUSSIANPARAMETERS) throws an error if GAUSSIANPARAMETERS is not a legal,
    %   fully resolved Gaussian noise configuration for single-run pipeline execution.

    % Confirm struct
    if ~isstruct(gaussianParameters)
            error('validateGaussianNoiseParameters:InvalidType', ...
                'gaussianParameters must be a struct.');
    end

    % Check that necessary fields are present
    if ~isfield(gaussianParameters, 'dimension')
           error('validateGaussianNoiseParameters:MissingField', ...
               'gaussianParameters must have a ''dimension'' field.');
    end

    if ~isfield(gaussianParameters, 'mean')
           error('validateGaussianNoiseParameters:MissingField', ...
               'gaussianParameters must have a ''mean'' field.');
    end

    if ~isfield(gaussianParameters, 'covariance')
           error('validateGaussianNoiseParameters:MissingField', ...
               'gaussianParameters must have a ''covariance'' field.');
    end

    % Ensure that dimension is a positive integer
    validateattributes(gaussianParameters.dimension, {'numeric'}, {'scalar', 'finite', 'positive', 'integer'}, mfilename, 'gaussianParameters.dimension');

    % Ensure that mean and covariance are of appropriate type and dimension
    if ~(isnumeric(gaussianParameters.mean) && all(isfinite(gaussianParameters.mean), 'all') && isvector(gaussianParameters.mean))
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'gaussianParameters.mean must be a numeric and finite vector.');
    end

    if ~(isnumeric(gaussianParameters.covariance) && all(isfinite(gaussianParameters.covariance), 'all'))
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'gaussianParameters.covariance must be numeric and finite.');
    end

    if ~(ismatrix(gaussianParameters.covariance) && size(gaussianParameters.covariance, 1) == size(gaussianParameters.covariance, 2))
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'gaussianParameters.covariance must be a square matrix.');
    end

    if ~(issymmetric(gaussianParameters.covariance))
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'gaussianParameters.covariance must be a symmetric matrix.');
    end

    if ~(size(gaussianParameters.covariance, 1) == gaussianParameters.dimension)
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'Dimension of gaussianParameters.covariance must match gaussianParameters.dimension.');
    end

    if ~(numel(gaussianParameters.mean) == gaussianParameters.dimension)
           error('validateGaussianNoiseParameters:InvalidFieldValue', ...
               'Dimension of gaussianParameters.mean must match gaussianParameters.dimension.');
    end
end


