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
    %
    % IMPLEMENTATION REQUIREMENTS AND NOTES
    %  0. Please do not delete the docstring above these notes.
    %  1. This function applies an already-fitted PCA transform. It must not
    %     refit PCA or call pca().
    %  2. Projection must be performed as:
    %         Xtransformed = (X - pcaTransform.mu) * pcaTransform.coeff
    %  3. The centering mean pcaTransform.mu comes from the training set and
    %     must be used unchanged for both training and test transformations.
    %  4. This function is performance-critical. Use fully vectorized matrix
    %     operations. Do not loop over samples or features.
    %  5. Do not recompute quantities already stored in pcaTransform.
    %  6. Assume X has already been normalized upstream if normalization is
    %     enabled in the pipeline.
    %  7. This skeleton has been implemented as an identity function (i.e.,
    %  it doesn't do anything except return the input in its original
    %  form). This was done so that the pipeline just ignores it and keeps
    %  going until PCA is implemented. 
    %  8. When you're finished, get rid of everything in the output
    %  validation block except the call to validateAppliedPCATransform
    %  (i.e., delete the if/else block and the Xtransformed = X line).

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mu = pcaTransform.mu;
    coeff = pcaTransform.coeff;
    Xtransformed = (X-mu) * coeff;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateAppliedPCATransform(Xtransformed, X, pcaTransform);

end