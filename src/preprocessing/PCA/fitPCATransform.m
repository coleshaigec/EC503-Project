function pcaTransform = fitPCATransform(X, pcaSpec)
    % FITPCATRANSFORM Fits a PCA transform on a feature matrix according to pcaSpec.
    %
    % AUTHOR: Kelly Falcon
    %
    % INPUTS
    %  X (n x d double) - training feature matrix
    %
    %  pcaSpec struct with fields:
    %      .enabled (logical scalar)
    %      .selectionMode (string) - 'varianceThreshold' or 'fixedNumComponents'
    %      .varianceThreshold (double in [0, 1])
    %      .fixedNumComponents (positive integer)
    %
    % OUTPUTS
    %  pcaTransform struct with fields:
    %      .mu (1 x d double)                - feature means from training data
    %      .coeff (d x k double)             - retained principal directions
    %      .explained (1 x k double)         - explained variance percentages
    %      .originalDimension (positive int) - original feature dimension d
    %      .projectedDimension (positive int)- retained dimension k
    %      .eigenvalues (1 x k double)       - retained PCA eigenvalues
    %
    % IMPLEMENTATION REQUIREMENTS AND NOTES
    %  0. Please do not delete the docstring above these notes.
    %  1. You may ignore pcaSpec.enabled; this function is only called when PCA is enabled.
    %  2. Fit PCA using the training matrix X only.
    %  3. Compute and store the training-data mean in pcaTransform.mu. This
    %     mean must later be reused unchanged in applyPCATransform.
    %  4. If selectionMode is 'varianceThreshold', retain the smallest k such
    %     that the cumulative explained variance is at least the specified threshold.
    %  5. If selectionMode is 'fixedNumComponents', retain exactly that many components.
    %  6. Ignore the inactive selection parameter.
    %  7. coeff must be returned as a d x k matrix whose columns are the retained
    %     orthonormal principal directions.
    %  8. This function is performance-critical. Avoid unnecessary recomputation,
    %     temporary arrays, or repeated passes over large matrices.
    %  9. Do not store unused large intermediate arrays in pcaTransform.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pcaTransform = struct();

    % -- Output validation - PLEASE DO NOT REMOVE --
    validatePCATransform(pcaTransform, X);
end