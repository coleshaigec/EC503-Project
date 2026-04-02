function trainedModel = trainLogisticRegressionModel(trainingData, logisticRegressionHyperparameters)
    % TRAINLOGISTICREGRESSIONMODEL Fits logistic regression model to training data using specified hyperparameters
    %
    % INPUTS
    %  trainingData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %
    %  logisticRegressionHyperparameters struct with fields
    %      .lambda (double >= 0)       - regularization strength
    %      .maxIter (double)           - cap on number of iterations
    %      .solver (string)            - solver type for templateLinear
    %
    % OUTPUTS
    %  trainedModel struct with fields
    %      .modelObject                - trained MATLAB ECOC multiclass classification model
    %      .classLabels (m x 1 double) - unique labels present in training data
    %      .numClasses  (double)       - number of classes

    % -- Validate hyperparameters --
    validateLogisticRegressionHyperparameters(trainingData, logisticRegressionHyperparameters);

    % -- Construct binary learner template for ECOC multiclass logistic regression --
    logisticTemplate = templateLinear( ...
        'Learner', 'logistic', ...
        'Lambda', logisticRegressionHyperparameters.lambda, ...
        'Solver', logisticRegressionHyperparameters.solver, ...
        'IterationLimit', logisticRegressionHyperparameters.maxIter ...
    );

    % -- Train multiclass linear classifier using MATLAB built-in --
    modelObject = fitcecoc( ...
        trainingData.Xtrain, ...
        trainingData.ytrain, ...
        'Learners', logisticTemplate, ...
        'ClassNames', unique(trainingData.ytrain), ...
        'FitPosterior', true...
    );

    % -- Populate output struct --
    classes = unique(trainingData.ytrain);
    trainedModel = struct();
    trainedModel.modelObject = modelObject;
    trainedModel.classLabels = classes;
    trainedModel.numClasses = numel(classes);

    % -- Validate output struct --
    validateLogisticRegressionModel(trainedModel, trainingData, logisticRegressionHyperparameters);
end