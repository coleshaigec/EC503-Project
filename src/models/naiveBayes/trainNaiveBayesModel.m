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
    
    labels = unique(trainingData.y);
    numClasses = numel(labels);

    epsilon = naiveBayesHyperparameters.varianceSmoothing;
    [n, d] = size(trainingData.X);
    priors = zeros(numClasses, 1);
    classFeatureMeans = zeros(numClasses, d); % store each class mean as a row vector
    classFeatureVariances = zeros(numClasses, d);

    for i = 1 : numClasses
        currentLabel = labels(i);

        % -- Estimate class priors --
        Ik = trainingData.y == currentLabel;
        nk = sum(Ik);
        priors(i) = nk / n;

        % -- Estimate class feature means --
        samplesOfCurrentClass = trainingData.X(Ik,:);
        classFeatureMeans(i, :) = mean(samplesOfCurrentClass, 1);
        classFeatureVariances(i, :) = var(samplesOfCurrentClass, 1, 1) + epsilon;
    end

    % -- Populate output struct --
    naiveBayesModel = struct();
    naiveBayesModel.classLabels = labels;
    naiveBayesModel.classPriors = priors;
    naiveBayesModel.logClassPriors = log(priors);
    naiveBayesModel.classFeatureMeans = classFeatureMeans;
    naiveBayesModel.classFeatureVariances = classFeatureVariances;
    naiveBayesModel.varianceSmoothing = epsilon;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateNaiveBayesModel( ...
        naiveBayesModel, ...
        trainingData, ...
        naiveBayesHyperparameters);

end