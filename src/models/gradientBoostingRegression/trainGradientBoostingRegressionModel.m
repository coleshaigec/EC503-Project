function gradientBoostingRegressionModel = trainGradientBoostingRegressionModel(trainingData, gradientBoostingRegressionHyperparameters)
% TRAINGRADIENTBOOSTINGREGRESSIONMODEL Fits gradient boosting regression model to training data using specified hyperparameters
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  trainingData struct with fields
    %      .X (nTrain x d double)                - training feature matrix
    %      .y (nTrain x 1 double)                - training response vector
    %
    %  gradientBoostingRegressionHyperparameters struct with fields
    %      .T (positive integer)                 - number of learners
    %      .learningRate (double > 0)      
    %      .maxNumSplits (positive integer)      - controls weak learner complexity
    %
    % OUTPUTS
    %  gradientBoostingRegressionModel struct with fields
    %      .ensemble (CompactRegressionEnsemble) - trained boosted regression ensemble
    %      .T (positive integer)                 - number of learners
    %      .learningRate (double > 0)            - shrinkage parameter
    %      .maxNumSplits (nonnegative integer)   - tree complexity control

    gradientBoostingRegressionModel = struct();

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateGradientBoostingRegressionModel( ...
        gradientBoostingRegressionModel, ...
        trainingData, ...
        gradientBoostingRegressionHyperparameters);

end