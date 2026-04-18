function XNormalized = applyNormalizationTransform(X, normalizationParameters)
    % APPLYNORMALIZATIONTRANSFORM Apply normalization transform to feature matrix.
    %
    % INPUT: 
    %   X (n x d double) - feature matrix
    %
    %   normalizationParameters struct with fields:
    %       .mu    (1 x d)
    %       .sigma (1 x d)
    %
    % OUTPUT:
    %  XNormalized (n x d) - normalized feature matrix

    % -- Input validation --
    mu = normalizationParameters.mu;
    sigma = normalizationParameters.sigma;

    assert(isnumeric(mu), 'mu must be numeric');
    assert(isnumeric(sigma), 'sigma must be numeric');
    assert(all(isfinite(mu(:))), 'mu must be finite');
    assert(all(isfinite(sigma(:))), 'sigma must be finite');

    assert(isrow(mu) && numel(mu) == dTrain, ...
        'mu must be a 1 x d row vector');
    assert(isrow(sigma) && numel(sigma) == dTrain, ...
        'sigma must be a 1 x d row vector');
    assert(all(sigma ~= 0), 'sigma must contain no zeros');

    % -- Apply normalization transform --
    XNormalized = (X - mu) ./ normalizationParameters.sigma;

end