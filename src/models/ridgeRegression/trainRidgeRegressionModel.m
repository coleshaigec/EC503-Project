function ridgeRegressionModel = trainRidgeRegressionModel(trainingData, ridgeRegressionHyperparameters)
    % TRAINRIDGEREGRESSIONMODEL Fits ridge regression model to training data using specified hyperparameters
    %
    % AUTHORS: Kelly Falcon, Cole H. Shaigec
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double)      - training feature matrix
    %      .y (nTrain x 1 double)      - training label vector
    %
    %  ridgeRegressionHyperparameters struct with fields
    %      .lambda (double > 0)        - regularization penalty parameter
    %
    % OUTPUTS
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double)      - ridge regression coefficients
    %      .bias  (double)             - intercept term
    %      .lambda (double > 0)        - regularization penalty

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. Squared error loss with L2 regularization will be used for model training.
    % 2. Lambda = 0 (in which case ridge becomes OLS) is permitted.
    % 3. The data has already been normalized by the pipeline, so there is
    % no need for normalization within this function.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    X = trainingData.X;
    y = trainingData.y;
    lambda = ridgeRegressionHyperparameters.lambda;
    [nTrain, d] = size(X);

    muX = mean(X, 1)'; %empirical means
    muY = mean(y);
    Xtilde = X - muX'; %mean centered data
    ytilde = y - muY;
    Sx = (Xtilde' * Xtilde) / nTrain; %empirical
    Sxy = (Xtilde' * ytilde) / nTrain;
    coeff = ((lambda / nTrain) * eye(d) + Sx) \ Sxy; %ridge solution
    bias = muY - muX' * coeff; %intercept

    ridgeRegressionModel = struct();
    ridgeRegressionModel.coeff = coeff;
    ridgeRegressionModel.bias = bias;
    ridgeRegressionModel.lambda = lambda;

    trainingDataForValidation = struct();
    trainingDataForValidation.Xtrain = trainingData.X;
    trainingDataForValidation.ytrain = trainingData.y;
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateRidgeRegressionModel(ridgeRegressionModel, trainingDataForValidation, ridgeRegressionHyperparameters);

end