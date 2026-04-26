function weightedRidgeRegressionModel = trainWeightedRidgeRegressionModel(trainingData, weightedRidgeRegressionHyperparameters)
    % TRAINWEIGHTEDRIDGEREGRESSIONMODEL Fits weighted ridge regression model to training data using specified hyperparameters
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double)                - training feature matrix
    %      .y (nTrain x 1 double)                - training response vector
    %
    %  weightedRidgeRegressionHyperparameters struct with fields
    %      .eta (double > 0)           - temporal weighting parameter
    %      .tau (double > 0)           - RUL decay constant
    %      .lambda (double > 0)        - regularization penalty parameter
    % 
    % OUTPUT
    %  weightedRidgeRegressionModel struct with fields
    %      .coeff (d x 1 double) - ridge regression coefficients
    %      .bias (double)        - intercept term
    %      .gamma (n x 1 double) - weights
    %      .lambda (double > 0)  - regularization penalty
    %      .eta (double > 0)     - temporal weighting parameter
    %      .tau (double > 0)     - RUL decay constant
  
    % -- Extract dataset dimensions --
    [n,d] = size(trainingData.X);

    % -- Build weighting scheme --
    eta = weightedRidgeRegressionHyperparameters.eta;
    tau = weightedRidgeRegressionHyperparameters.tau;
    lambda = weightedRidgeRegressionHyperparameters.lambda;

    a = 1 + eta .* exp(-trainingData.y ./ tau);
    gamma = a ./sum(a);

    % -- Construct weighted mean vectors --
    muHatX = trainingData.X.' * gamma;
    muHatY = gamma.' * trainingData.y;

    % -- Center features and labels --
    XTilde = trainingData.X - muHatX.';
    yTilde = trainingData.y - muHatY;

    % -- Compute weighted covariance and cross-covariance matrices --
    weightedXTilde = XTilde .* gamma;

    sHatX = XTilde.' * weightedXTilde;
    sHatXY = XTilde.' * (gamma .* yTilde);

    % -- Compute ridge regression solution --
    wRidge = (sHatX + lambda/n * eye(d)) \ sHatXY;
    bRidge = muHatY - muHatX.' * wRidge;

    % -- Populate output struct --
    weightedRidgeRegressionModel = struct();
    weightedRidgeRegressionModel.coeff = wRidge;
    weightedRidgeRegressionModel.bias = bRidge;
    weightedRidgeRegressionModel.gamma = gamma;
    weightedRidgeRegressionModel.lambda = lambda;
    weightedRidgeRegressionModel.eta = eta;
    weightedRidgeRegressionModel.tau = tau;
end