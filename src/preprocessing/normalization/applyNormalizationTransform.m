function XNormalized = applyNormalizationTransform(X, normalizationParameters)
    % APPLYNORMALIZATIONTRANSFORM Apply normalization transform to feature matrix.
    %
    % AUTHOR: Cole H. Shaigec
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

    % -- Apply normalization transform --
    XNormalized = (X - normalizationParameters.mu) ./ normalizationParameters.sigma;

end