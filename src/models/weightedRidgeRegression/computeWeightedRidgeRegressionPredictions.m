function weightedRidgeRegressionResult = computeWeightedRidgeRegressionPredictions(dataset, weightedRidgeRegressionModel)
% COMPUTEWEIGHTEDRIDGEREGRESSIONPREDICTIONS Computes predictions of weighted ridge regression model on dataset.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - response vector
    %
    %  weightedRidgeRegressionModel struct with fields
    %      .coeff (d x 1 double) - ridge regression coefficients
    %      .bias (double)        - intercept term
    %      .gamma (n x 1 double) - weights
    %      .lambda (double > 0)  - regularization penalty
    %      .eta (double > 0)     - temporal weighting parameter
    %      .tau (double > 0)     - RUL decay constant
    %
    % OUTPUT
    %  weightedRidgeRegressionResult struct with fields
    %      .yHat (n x 1 double)
    %      .metadata struct with fields
    %          .coeff (d x 1 double) - ridge regression coefficients
    %          .bias (double)        - intercept term
    %          .lambda (double > 0)  - regularization penalty
    %          .eta (double > 0)     - temporal weighting parameter
    %          .tau (double > 0)     - RUL decay constant

    % -- Compute predictions --
    yHat = dataset.X * weightedRidgeRegressionModel.coeff + weightedRidgeRegressionModel.bias;

    % -- Populate output struct --
    weightedRidgeRegressionResult = struct();
    weightedRidgeRegressionResult.yHat = yHat;
    weightedRidgeRegressionResult.metadata = struct();
    weightedRidgeRegressionResult.metadata.coeff = weightedRidgeRegressionModel.coeff;
    weightedRidgeRegressionResult.metadata.bias = weightedRidgeRegressionModel.bias;
    weightedRidgeRegressionResult.metadata.lambda = weightedRidgeRegressionModel.lambda;
    weightedRidgeRegressionResult.metadata.eta = weightedRidgeRegressionModel.eta;
    weightedRidgeRegressionResult.metadata.tau = weightedRidgeRegressionModel.tau;
end
