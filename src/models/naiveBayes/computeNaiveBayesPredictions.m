function naiveBayesResult = computeNaiveBayesPredictions(dataset, naiveBayesModel)
    % COMPUTENAIVEBAYESPREDICTIONS Computes predictions of trained Gaussian naive Bayes classifier.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  dataset struct with fields
    %      .X (n x d double)                - feature matrix
    %      .y (n x 1 double)                - true label vector
    %
    %  naiveBayesModel struct with fields
    %      .classLabels (K x 1 double)            - unique class labels
    %      .classPriors (K x 1 double)            - class prior probabilities
    %      .logClassPriors (K x 1 double)         - log class prior probabilities
    %      .classFeatureMeans (K x d double)      - class-conditional feature means
    %      .classFeatureVariances (K x d double)  - regularized class-conditional feature variances
    %      .varianceSmoothing (double >= 0)       - variance regularization term
    %
    % OUTPUT
    %  naiveBayesResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .logPosteriorScores (n x K double) - classwise unnormalized log-posterior scores
    %          .classLabels (K x 1 double)        - class labels corresponding to score columns
    %          .varianceSmoothing (double >= 0)   - echoed variance regularization term

    % -- Initialize and preallocate --
    [n, ~] = size(dataset.X);
    numClasses = numel(naiveBayesModel.classLabels);
    logPosteriorScores = zeros(n, numClasses);

    % -- Compute log posterior scores --
    for i = 1:numClasses
        currentMeans = naiveBayesModel.classFeatureMeans(i, :);
        currentVariances = naiveBayesModel.classFeatureVariances(i, :);

        quadraticTerms = ((dataset.X - currentMeans) .^ 2) ./ currentVariances;
        logNormalizationTerm = sum(log(2 * pi * currentVariances));
        quadraticPenalty = sum(quadraticTerms, 2);

        logPosteriorScores(:, i) = naiveBayesModel.logClassPriors(i) ...
            - 0.5 * (logNormalizationTerm + quadraticPenalty);
    end

    % -- Form predictions --
    [~, idxBestScores] = max(logPosteriorScores, [], 2);
    yHat = naiveBayesModel.classLabels(idxBestScores);

    % -- Populate output struct --
    naiveBayesResult = struct();
    naiveBayesResult.yHat = yHat;
    naiveBayesResult.metadata = struct();
    naiveBayesResult.metadata.logPosteriorScores = logPosteriorScores;
    naiveBayesResult.metadata.classLabels = naiveBayesModel.classLabels;
    naiveBayesResult.metadata.varianceSmoothing = naiveBayesModel.varianceSmoothing;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateNaiveBayesResult( ...
        naiveBayesResult, ...
        dataset, ...
        naiveBayesModel);

end