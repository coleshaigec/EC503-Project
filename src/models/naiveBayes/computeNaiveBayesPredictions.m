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

    naiveBayesResult = struct();

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateNaiveBayesResult( ...
        naiveBayesResult, ...
        dataset, ...
        naiveBayesModel);
end