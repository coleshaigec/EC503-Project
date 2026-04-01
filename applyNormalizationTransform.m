function normalizedData = applyNormalizationTransform(rawData, normalizationParameters)
    % APPLYNORMALIZATIONTRANSFORM Apply normalization parameters to train
    % and test sets.
    %
    % INPUT: 
    %   rawData struct with fields:
    %       .Xtrain (nTrain x d double) - training feature matrix
    %       .ytrain (nTrain x 1 double)    - training label vector
    %       .Xtest  (nTest x d double)  - test feature matrix
    %       .ytest  (nTest x 1 double)     - test label vector
    %       .ntrain (int)               - training dataset size
    %       .ntest  (int)               - test dataset size
    %       .d      (int)               - dataset dimension
    %
    %   normalizationParameters struct with fields:
    %       .mu    (1 x d)
    %       .sigma (1 x d)
    %
    % OUTPUT:
    %  normalizedData struct with fields:
    %       .Xtrain (nTrain x d double) - normalized training feature matrix
    %       .ytrain (nTrain x 1 double)    - training label vector
    %       .Xtest  (nTest x d double)  - normalized test feature matrix
    %       .ytest  (nTest x 1 double)     - test label vector
    %       .ntrain (int)               - training dataset size
    %       .ntest  (int)               - test dataset size
    %       .d      (int)               - dataset dimension

    % --- Invariants: rawData fields exist ---
    assert(isfield(rawData, 'Xtrain'), 'rawData must contain field Xtrain');
    assert(isfield(rawData, 'Xtest'),  'rawData must contain field Xtest');
    assert(isfield(rawData, 'ytrain'), 'rawData must contain field ytrain');
    assert(isfield(rawData, 'ytest'),  'rawData must contain field ytest');
    assert(isfield(rawData, 'ntrain'), 'rawData must contain field ntrain');
    assert(isfield(rawData, 'ntest'),  'rawData must contain field ntest');
    assert(isfield(rawData, 'd'),      'rawData must contain field d');

    % --- Invariants: feature matrices ---
    assert(isnumeric(rawData.Xtrain), 'Xtrain must be numeric');
    assert(~isempty(rawData.Xtrain), 'Xtrain cannot be empty');
    assert(all(isfinite(rawData.Xtrain(:))), 'Xtrain cannot contain NaN or Inf');

    assert(isnumeric(rawData.Xtest), 'Xtest must be numeric');
    assert(~isempty(rawData.Xtest), 'Xtest cannot be empty');
    assert(all(isfinite(rawData.Xtest(:))), 'Xtest cannot contain NaN or Inf');

    % --- Invariants: labels ---
    assert(isnumeric(rawData.ytrain), 'ytrain must be numeric');
    assert(~isempty(rawData.ytrain), 'ytrain cannot be empty');
    assert(all(isfinite(rawData.ytrain(:))), 'ytrain cannot contain NaN or Inf');

    assert(isnumeric(rawData.ytest), 'ytest must be numeric');
    assert(~isempty(rawData.ytest), 'ytest cannot be empty');
    assert(all(isfinite(rawData.ytest(:))), 'ytest cannot contain NaN or Inf');

    % --- Invariants: dimensional consistency ---
    nTrain = size(rawData.Xtrain, 1);
    nTest = size(rawData.Xtest, 1);
    dTrain = size(rawData.Xtrain, 2);
    dTest = size(rawData.Xtest, 2);

    assert(nTrain == numel(rawData.ytrain), ...
        'Number of rows in Xtrain must match length of ytrain');
    assert(nTest == numel(rawData.ytest), ...
        'Number of rows in Xtest must match length of ytest');
    assert(dTrain == dTest, ...
        'Xtrain and Xtest must have the same number of features');

    assert(isscalar(rawData.ntrain) && rawData.ntrain == nTrain, ...
        'rawData.ntrain must match size(Xtrain, 1)');
    assert(isscalar(rawData.ntest) && rawData.ntest == nTest, ...
        'rawData.ntest must match size(Xtest, 1)');
    assert(isscalar(rawData.d) && rawData.d == dTrain, ...
        'rawData.d must match feature dimension');

    % --- Invariants: normalization parameters ---
    assert(isfield(normalizationParameters, 'mu'), ...
        'normalizationParameters must contain field mu');
    assert(isfield(normalizationParameters, 'sigma'), ...
        'normalizationParameters must contain field sigma');

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

    % -- Apply normalization transforms --
    normalizedXtrain = rawData.Xtrain - normalizationParameters.mu;
    normalizedXtrain = normalizedXtrain ./ normalizationParameters.sigma;

    normalizedXtest = rawData.Xtest - normalizationParameters.mu;
    normalizedXtest = normalizedXtest ./ normalizationParameters.sigma;

    % --- Postconditions ---
    assert(isequal(size(normalizedXtrain), size(rawData.Xtrain)), ...
        'Normalized Xtrain must preserve original shape');
    assert(isequal(size(normalizedXtest), size(rawData.Xtest)), ...
        'Normalized Xtest must preserve original shape');
    assert(all(isfinite(normalizedXtrain(:))), ...
        'Normalized Xtrain contains NaN or Inf');
    assert(all(isfinite(normalizedXtest(:))), ...
        'Normalized Xtest contains NaN or Inf');

    % -- Populate output struct --
    normalizedData = rawData;
    normalizedData.Xtrain = normalizedXtrain;
    normalizedData.Xtest = normalizedXtest;
end