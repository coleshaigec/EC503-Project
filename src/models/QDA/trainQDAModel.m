function qdaModel = trainQDAModel(trainingData, qdaHyperparameters)
    % TRAINQDAMODEL Trains regularized QDA model on specified dataset. 
    %
    % AUTHORS: [Youwei Chen/Kelly Falcon], Cole H. Shaigec
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double) - training feature matrix
    %      .y (nTrain x 1 double) - training label vector
    %
    %  qdaHyperparameters struct with fields
    %      .regularizationStrength (double >= 0) - covariance regularization strength
    %
    % OUTPUT
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Please do not delete the docstring above.
    % 2. This function must train a CLASSIFICATION QDA model, not a regression model.
    % 3. This implementation is binary-classification only. Training labels are
    %    expected to be exactly -1 and +1. Do not implement multiclass logic.
    % 4. Training labels are assumed to have already been prepared correctly by the pipeline.
    %    Do not remap labels inside this function.
    % 5. Do not normalize features inside this function. Any normalization and/or PCA
    %    has already been handled upstream by the pipeline when required.
    % 6. This model must be implemented as REGULARIZED QDA. Do not fit unregularized
    %    class covariance matrices and store them directly.
    % 7. Compute class labels using unique(trainingData.y) and ensure they are exactly
    %    [-1; 1] in that order. All class-specific quantities must use this exact ordering.
    % 8. For each class k, estimate the class mean vector mu_k and class covariance matrix Sigma_k
    %    using only the samples belonging to that class.
    % 9. Regularize each class covariance matrix as:
    %         SigmaReg_k = Sigma_k + lambda * eye(d)
    %    where lambda = qdaHyperparameters.regularizationStrength.
    % 10. The regularization strength must be treated as a nonnegative scalar.
    %     It must be stored unchanged in qdaModel.regularizationStrength.
    % 11. Compute and store class priors as empirical frequencies:
    %         prior_k = n_k / nTrain
    %     and also store their logs in .logClassPriors.
    % 12. Store class means as a 2 x d matrix whose i-th row corresponds to the i-th class
    %     in qdaModel.classLabels.
    % 13. Store each regularized covariance matrix in qdaModel.classCovariances{i}.
    %     Each cell entry must be a d x d double matrix.
    % 14. Also precompute and store the inverse of each regularized covariance matrix in
    %     qdaModel.classCovarianceInverses{i} and the corresponding log determinant in
    %     qdaModel.logDetCovariances(i). This avoids repeated expensive recomputation
    %     during prediction.
    % 15. Be careful with numerical stability when computing log determinants and inverses.
    %     Do not silently proceed with singular or non-finite covariance quantities.
    % 16. The regularized covariance matrices should be symmetric. If small floating-point
    %     asymmetries arise from computation, it is acceptable to symmetrize using:
    %         SigmaReg = (SigmaReg + SigmaReg.') / 2
    %     before storing downstream quantities.
    % 17. Prefer stable linear algebra. Do not recompute matrix inverses or determinants
    %     repeatedly inside loops when the result can be computed once and stored.
    % 18. Do not store redundant copies of the full training matrix X or label vector y
    %     inside qdaModel.
    % 19. This function is performance-critical. Avoid unnecessary temporary arrays,
    %     repeated passes over large matrices, or expensive recomputation.
    % 20. The implementation should fail loudly if a valid regularized covariance model
    %     cannot be constructed. Do not silently continue with malformed outputs.
    % 21. The final output struct must satisfy validateQDAModel exactly.

    % -- YOUR IMPLEMENTATION HERE --
X = trainingData.X;
y = trainingData.y;

[nTrain, d] = size(X);

lambda = qdaHyperparameters.regularizationStrength;

classLabels = unique(y);

classPriors = zeros(2, 1);
logClassPriors = zeros(2, 1);
classMeans = zeros(2, d);
classCovariances = cell(2, 1);
classCovarianceInverses = cell(2, 1);
logDetCovariances = zeros(2, 1);

for i = 1:2
    currentLabel = classLabels(i);
    classMask = (y == currentLabel);
    Xclass = X(classMask, :);

    nClass = size(Xclass, 1);

    classPriors(i) = nClass / nTrain;
    logClassPriors(i) = log(classPriors(i));

    mu = mean(Xclass, 1);
    classMeans(i, :) = mu;

    Sigma = cov(Xclass, 1);
    SigmaReg = Sigma + lambda * eye(d);
    SigmaReg = (SigmaReg + SigmaReg.') / 2;

    [R, p] = chol(SigmaReg);

    if p ~= 0
        error('trainQDAModel:InvalidCovariance', ...
            'Regularized covariance matrix is not positive definite.');
    end

    SigmaInv = inv(SigmaReg);

    logDetSigma = 2 * sum(log(diag(R)));

    if ~all(isfinite(SigmaInv), 'all') || ~isfinite(logDetSigma)
        error('trainQDAModel:NonfiniteCovarianceQuantity', ...
            'Covariance inverse or log determinant is not finite.');
    end

    classCovariances{i} = SigmaReg;
    classCovarianceInverses{i} = SigmaInv;
    logDetCovariances(i) = logDetSigma;
end

qdaModel = struct();
qdaModel.classLabels = classLabels;
qdaModel.classPriors = classPriors;
qdaModel.logClassPriors = logClassPriors;
qdaModel.classMeans = classMeans;
qdaModel.classCovariances = classCovariances;
qdaModel.classCovarianceInverses = classCovarianceInverses;
qdaModel.logDetCovariances = logDetCovariances;
qdaModel.regularizationStrength = lambda;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateQDAModel(qdaModel, trainingData, qdaHyperparameters);

end