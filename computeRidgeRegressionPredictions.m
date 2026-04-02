function ridgeRegressionResult = computeRidgeRegressionPredictions(dataset, ridgeRegressionModel)
    % COMPUTERIDGEREGRESSIONPREDICTIONS Computes predictions of ridge regression model on dataset.
    %
    % INPUT 
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  ridgeRegressionModel struct with fields
    %      .coeff  (d x 1 double)      - ridge regression coefficients
    %      .bias  (double)             - intercept term
    %      .lambda (double >= 0)        - regularization penalty
    %
    % OUTPUT
    %  ridgeRegressionResult struct with fields
    %      .yHatTrain (ntrain x 1 double)           - predicted training labels
    %      .yHatTest  (ntest x 1 double)            - predicted test labels
    %      .ridgeRegressionModel struct with fields
    %          .coeff  (d x 1 double)      - ridge regression coefficients
    %          .bias  (double)             - intercept term
    %          .lambda (double >= 0)        - regularization penalty

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. Predictions are computed as yHat = X * coeff + bias.
    % 2. Predictions should be computed for both training and test feature matrices.
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ridgeRegressionResult = struct();
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateRidgeRegressionResult(ridgeRegressionResult, dataset, ridgeRegressionModel);
end