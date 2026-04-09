function logisticRegressionResult = computeLogisticRegressionPredictions(dataset, logisticRegressionModel)
% COMPUTELOGISTICREGRESSIONPREDICTIONS Computes predictions of logistic regression multi-class classification model on dataset.
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double)    - feature matrix
    %      .y (n x 1 double)    - label vector
    %
    %  logisticRegressionModel struct with fields
    %      .modelObject                - trained MATLAB ECOC multiclass classification model
    %      .classLabels (m x 1 double) - unique labels present in training data
    %      .numClasses  (double)       - number of classes
    %
    % OUTPUT
    %  logisticRegressionResult struct with fields
    %      .yHat (n x 1 double)                              - predicted labels
    %      .metadata struct with fields
    %          .scores (n x m double)                        — class scores for training samples
    %          .logisticRegressionModel struct with fields
    %               .modelObject                             - trained MATLAB ECOC multiclass classification model
    %               .classLabels (m x 1 double)              - unique labels present in training data
    %               .numClasses  (double)                    - number of classes
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. To spare you the headache of manually implementing SGD, the
    % logistic regression model is already trained using MATLAB's built-in fitcecoc function.
    % If you need info on the modelObject and other info passed into this
    % function, consult the file trainLogisticRegressionModel.m and the
    % MATLAB documentation on fitcecoc.
    % 2. Predictions and class scores should be generated using MATLAB's built-in predict
    % method applied to logisticRegressionModel.modelObject.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    logisticRegressionResult = struct();
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateLogisticRegressionResult(logisticRegressionResult, dataset, logisticRegressionModel);

end