function XStandardized = applyStandardizationTransform(X, standardizationParameters)
    % APPLYSTANDARDIZATIONTRANSFORM Apply standardization transform to feature matrix.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT: 
    %   X (n x d double) - feature matrix
    %
    %   standardizationParameters struct with fields:
    %       .mu    (1 x d)
    %       .sigma (1 x d)
    %
    % OUTPUT:
    %  XStandardized (n x d) - standardized feature matrix

    % -- Apply standardization transform --
    XStandardized = (X - standardizationParameters.mu) ./ standardizationParameters.sigma;

end