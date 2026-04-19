function analyzeBestRuns(bestRuns, bestRunReports)
    % ANALYZEBESTRUNS Executes full analysis of best runs of pipeline.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  bestRuns struct with fields
    %      .classification table
    %          Top classification runs ranked by
    %          0.75 * testF1 + 0.25 * testAccuracy, descending.
    %          Empty table if no valid classification runs exist.
    %
    %      .regression table
    %          Top regression runs ranked by testRMSE, ascending.
    %          Empty table if no valid regression runs exist.
    %
    %  bestRunReports array of structs, each with fields
    %      .train struct with fields
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .test
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .trainedModel struct with fields
    %          .model (struct)             - trained model
    %          .modelName (string)         - model type to be trained
    %          .taskType  (string)         - 'classification' or 'regression'
    %          .hyperparameters            - hyperparameters used in training
    %      .runPlan struct with fields
    %          .runNumber (positive integer)
    %          .pcaSpec struct with fields
    %              .enabled (boolean)
    %              .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %              .varianceThreshold (double in [0,1]) - 
    %              .fixedNumComponents (int > 0) - number of principal components to compute 
    %    
    %          .modelSpec struct with fields
    %              .modelName (string)
    %              .hyperparameterGrid (struct with model-specific fields)
    %    
    %          .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %          .warningHorizon (positive integer)        - TTF classification threshold
    %          .windowSize (positive integer)            - for dataset windowing
    %
    % SIDE EFFECTS
    %  experimentReport


    % Tasks
    % 
    % Show confusion matrices for the best runs if classification
    % Feed best run info to policy analysis utility
    % 
end