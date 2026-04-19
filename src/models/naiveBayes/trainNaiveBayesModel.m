function naiveBayesModel = trainNaiveBayesModel(trainingData, naiveBayesHyperparameters)
    % TRAINNAIVEBAYESMODEL Trains Gaussian naive Bayes classification model using specified hyperparameters.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double) - training feature matrix
    %      .y (nTrain x 1 double) - training label vector
    %
    %  naiveBayesHyperparameters struct with fields
    %      .varianceSmoothing (double >= 0) - nonnegative variance regularization term
    %
    % OUTPUTS
    %  naiveBayesModel struct with fields
    %      .classLabels (K x 1 double)            - unique class labels
    %      .classPriors (K x 1 double)            - class prior probabilities
    %      .logClassPriors (K x 1 double)         - log class prior probabilities
    %      .classFeatureMeans (K x d double)      - class-conditional feature means
    %      .classFeatureVariances (K x d double)  - regularized class-conditional feature variances
    %      .varianceSmoothing (double >= 0)       - variance regularization term

    naiveBayesModel = struct();

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateNaiveBayesModel( ...
        naiveBayesModel, ...
        trainingData, ...
        naiveBayesHyperparameters);

end