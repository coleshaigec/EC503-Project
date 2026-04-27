function ridgeRegressionResult = computeRidgeRegressionPredictions(dataset, ridgeRegressionModel)
    % COMPUTERIDGEREGRESSIONPREDICTIONS Computes predictions of ridge regression model on dataset.
    %
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - label vector
    %
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double)      - ridge regression coefficients
    %      .bias  (double)             - intercept term
    %      .lambda (double >= 0)        - regularization penalty
    %
    % OUTPUT
    %  ridgeRegressionResult struct with fields
    %      .yHat (n x 1 double)           - predicted  labels
    %      .metadata struct with fields
    %          .ridgeRegressionModel struct with fields
    %              .coeff  (d x 1 double)      - ridge regression coefficients
    %              .bias  (double)             - intercept term
    %              .lambda (double >= 0)        - regularization penalty

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. Predictions are computed as yHat = X * coeff + bias.
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    X = dataset.X;
    coeff = ridgeRegressionModel.coeff;
    bias = ridgeRegressionModel.bias;
    yHat = X * coeff + bias;

    ridgeRegressionResult = struct();
    ridgeRegressionResult.yHat = yHat;
    ridgeRegressionResult.metadata = struct();
    ridgeRegressionResult.metadata.ridgeRegressionModel = ridgeRegressionModel;
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateRidgeRegressionResult(ridgeRegressionResult, dataset, ridgeRegressionModel);
end