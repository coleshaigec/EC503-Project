function Xtransformed = applyPCATransform(X, pcaTransform)
    % APPLYPCATRANSFORM Applies a previously fitted PCA transform to feature matrix X.
    %
    % AUTHOR: Kelly Falcon
    %
    % INPUTS
    %  X (n x d double) - feature matrix to transform
    %
    %  pcaTransform struct with fields:
    %      .mu (1 x d double)                - feature means from training data
    %      .coeff (d x k double)             - retained principal directions
    %      .explained (1 x k double)         - explained variance percentages
    %      .originalDimension (positive int) - original feature dimension d
    %      .projectedDimension (positive int)- retained dimension k
    %      .eigenvalues (1 x k double)       - retained PCA eigenvalues
    %
    % OUTPUTS
    %  Xtransformed (n x k double) - PCA-projected feature matrix
    
    mu = pcaTransform.mu;
    coeff = pcaTransform.coeff;
    Xtransformed = (X-mu) * coeff;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateAppliedPCATransform(Xtransformed, X, pcaTransform);

end