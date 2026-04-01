function normalizationParameters = fitNormalizationTransform(Xtrain)
    % FITNORMALIZATIONTRANSFORM Fit z-score normalization parameters on training data.
    %
    % INPUT:
    %   Xtrain (n x d double) - training feature matrix
    %
    % OUTPUT:
    %   normalizationParameters struct with fields:
    %       .mu    (1 x d)
    %       .sigma (1 x d)

    % --- Invariants ---
    assert(isnumeric(Xtrain), 'Xtrain must be numeric');
    assert(~isempty(Xtrain), 'Xtrain cannot be empty');
    assert(all(isfinite(Xtrain(:))), 'Xtrain cannot contain NaN or Inf');

    % --- Fit parameters ---
    mu = mean(Xtrain, 1);
    sigma = std(Xtrain, 0, 1); 

    % --- Prevent division by zero ---
    sigma(sigma == 0) = 1;

    % --- Populate output struct ---
    normalizationParameters = struct();
    normalizationParameters.mu = mu;
    normalizationParameters.sigma = sigma;
end