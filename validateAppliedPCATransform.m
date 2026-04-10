function validateAppliedPCATransform(Xtransformed, X, pcaTransform)
    % VALIDATEAPPLIEDPCATRANSFORM Validates result of applying PCA transform.
    %
    % INPUTS
    %  Xtransformed (n x k double) - projected feature matrix
    %  X            (n x d double) - original feature matrix
    %  pcaTransform struct         - fitted PCA transform
    %
    % OUTPUT
    %  None. Throws an error if validation fails.

    % Validate source inputs first
    assert(isnumeric(X) && ismatrix(X) && ~isempty(X), ...
        'X must be a nonempty numeric 2D matrix.');

    assert(all(isfinite(X), 'all'), ...
        'X must contain only finite values.');

    validatePCATransform(pcaTransform, X);

    % Validate transformed output
    assert(isnumeric(Xtransformed) && ismatrix(Xtransformed), ...
        'Xtransformed must be a numeric 2D matrix.');

    assert(all(isfinite(Xtransformed), 'all'), ...
        'Xtransformed must contain only finite values.');

    [n, ~] = size(X);
    k = pcaTransform.projectedDimension;

    transformedSize = size(Xtransformed);
    assert(isequal(transformedSize, [n, k]), ...
        ['Xtransformed must have size (n x k) = (%d x %d). ' ...
         'Got (%d x %d).'], n, k, transformedSize(1), transformedSize(2));

    % Strong functional correctness check:
    % verify that output matches the contract Xtransformed = (X - mu) * coeff
    expectedXtransformed = (X - pcaTransform.mu) * pcaTransform.coeff;

    absoluteTolerance = 1e-10;
    relativeTolerance = 1e-8;

    maxAbsError = max(abs(Xtransformed - expectedXtransformed), [], 'all');
    scale = max(1, max(abs(expectedXtransformed), [], 'all'));
    maxRelError = maxAbsError / scale;

    assert(maxAbsError <= absoluteTolerance || maxRelError <= relativeTolerance, ...
        ['Xtransformed does not match PCA projection implied by pcaTransform. ' ...
         'Max absolute error = %.3e, max relative error = %.3e.'], ...
         maxAbsError, maxRelError);
end