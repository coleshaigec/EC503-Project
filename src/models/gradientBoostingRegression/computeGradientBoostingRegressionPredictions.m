function gradientBoostingRegressionResult = computeGradientBoostingRegressionPredictions(dataset, gradientBoostingRegressionModel)
% COMPUTEGRADIENTBOOSTINGREGRESSIONPREDICTIONS Computes predictions of gradient boosting regression model on dataset.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - response vector
    %
    %  gradientBoostingRegressionModel struct with fields
    %      .ensemble (CompactRegressionEnsemble) - trained boosted regression ensemble
    %      .T (positive integer)                 - number of learners
    %      .learningRate (double > 0)            - shrinkage parameter
    %      .maxNumSplits (nonnegative integer)   - tree complexity control
    %
    % OUTPUT
    %  gradientBoostingRegressionResult struct with fields
    %      .yHat (n x 1 double)
    %      .metadata struct with fields
    %          .T (positive integer)
    %          .learningRate (double > 0)
    %          .maxNumSplits (nonnegative integer)

    gradientBoostingRegressionResult = struct();

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateGradientBoostingRegressionResult( ...
        gradientBoostingRegressionResult, ...
        dataset, ...
        gradientBoostingRegressionModel);
end
