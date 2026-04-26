function qdaResult = computeQDAPredictions(dataset, qdaModel)
    % COMPUTEQDAPREDICTIONS Computes predictions of trained regularized QDA classifier on dataset.
    %
    % AUTHORS: [Youwei Chen/Kelly Falcon], Cole H. Shaigec
    %
    % INPUTS
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - true label vector
    %
    %  qdaModel struct with fields
    %      .classLabels (2 x 1 double)              - class labels, expected to be [-1; 1]
    %      .classPriors (2 x 1 double)              - empirical class prior probabilities
    %      .logClassPriors (2 x 1 double)           - log class prior probabilities
    %      .classMeans (2 x d double)               - class-conditional means
    %      .classCovariances (2 x 1 cell)           - regularized class covariance matrices, each d x d double
    %      .classCovarianceInverses (2 x 1 cell)    - inverses of regularized class covariance matrices, each d x d double
    %      .logDetCovariances (2 x 1 double)        - log determinants of regularized class covariance matrices
    %      .regularizationStrength (double >= 0)    - covariance regularization strength
    %
    % OUTPUT
    %  qdaResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .logPosteriorScores (n x 2 double)     - classwise unnormalized log-posterior scores
    %          .classLabels (2 x 1 double)            - class labels corresponding to score columns
    %          .regularizationStrength (double >= 0)  - echoed covariance regularization strength
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Please do not delete the docstring above.
    % 2. This function must compute predictions for a CLASSIFICATION QDA model,
    %    not a regression model.
    % 3. This implementation is binary-classification only. The class ordering
    %    must follow qdaModel.classLabels exactly, which is expected to be [-1; 1].
    % 4. Do not retrain, modify, or augment the model inside this function.
    %    This function is prediction-only.
    % 5. Do not normalize features inside this function. Any normalization and/or PCA
    %    has already been handled upstream by the pipeline when required.
    % 6. Use the precomputed quantities stored in qdaModel. In particular, reuse:
    %       - .logClassPriors
    %       - .classMeans
    %       - .classCovarianceInverses
    %       - .logDetCovariances
    %    Do not recompute covariance matrices, inverses, or log determinants here.
    % 7. Prediction must be computationally efficient. This function will be called
    %    many times throughout tuning and evaluation.
    % 8. For each class k, compute the unnormalized log-posterior score for each sample x as:
    %
    %       score_k(x) = log(pi_k)
    %                    - 0.5 * logdet(Sigma_k)
    %                    - 0.5 * (x - mu_k)' * inv(Sigma_k) * (x - mu_k)
    %
    %    where pi_k is the class prior, mu_k is the class mean, and Sigma_k is the
    %    regularized class covariance matrix for class k.
    %
    % 9. Do not include class-independent additive constants in the score computation.
    %    For example, the -0.5 * d * log(2*pi) term may be omitted because it is the
    %    same for both classes and does not affect argmax prediction.
    % 10. Be careful with dimensions when computing the quadratic form term.
    %     For an n x d feature matrix, the final quadratic-form contribution for each
    %     class must be an n x 1 vector.
    % 11. Prefer vectorized computation over looping over samples. It is acceptable
    %     to loop over classes because there are only two classes.
    % 12. Ensure that qdaResult.metadata.logPosteriorScores is stored as an n x 2
    %     double matrix whose i-th column corresponds exactly to qdaModel.classLabels(i).
    % 13. Form predictions by taking the columnwise argmax over the two score columns
    %     and mapping the winning column index back to qdaModel.classLabels.
    % 14. Ensure that yHat is returned as an n x 1 double column vector whose entries
    %     are class labels compatible with the rest of the pipeline (i.e., +1 and -1).
    % 15. Store qdaModel.classLabels unchanged in qdaResult.metadata.classLabels.
    % 16. Store qdaModel.regularizationStrength unchanged in
    %     qdaResult.metadata.regularizationStrength.
    % 17. Do not store the full model again inside metadata.
    % 18. Do not store redundant copies of X, y, covariance matrices, inverses, or
    %     other large intermediate arrays in the result struct.
    % 19. Do not compute optional diagnostics beyond the required log-posterior scores.
    % 20. The implementation should fail loudly if prediction cannot be computed using
    %     the stored QDA quantities. Do not silently continue with malformed outputs.
    % 21. The final output struct must satisfy validateQDAResult exactly.

    % -- YOUR IMPLEMENTATION HERE --
X = dataset.X;

n = size(X, 1);

classLabels = qdaModel.classLabels;
logPosteriorScores = zeros(n, 2);

for i = 1:2
    mu = qdaModel.classMeans(i, :);
    SigmaInv = qdaModel.classCovarianceInverses{i};
    logDetSigma = qdaModel.logDetCovariances(i);
    logPrior = qdaModel.logClassPriors(i);

    Xcentered = X - mu;

    quadraticTerms = sum((Xcentered * SigmaInv) .* Xcentered, 2);

    logPosteriorScores(:, i) = logPrior ...
        - 0.5 * logDetSigma ...
        - 0.5 * quadraticTerms;
end

[~, predictedIndices] = max(logPosteriorScores, [], 2);
yHat = classLabels(predictedIndices);

qdaResult = struct();
qdaResult.yHat = yHat;

qdaResult.metadata = struct();
qdaResult.metadata.logPosteriorScores = logPosteriorScores;
qdaResult.metadata.classLabels = classLabels;
qdaResult.metadata.regularizationStrength = qdaModel.regularizationStrength;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateQDAResult(qdaResult, dataset, qdaModel);

end