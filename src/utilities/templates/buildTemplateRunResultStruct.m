function templateRunReportStruct = buildTemplateRunResultStruct()
    % BUILDTEMPLATERUNRESULTSTRUCT Builds template runResult struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateRunReport struct with fields
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
    %          .warningHorizon (positive scalar array)   - TTF threshold for classification
    %          .windowSize (positive integer)            - for dataset windowing
    %          .numFolds (positive integer)              - number of CV folds

    templateRunReportStruct = struct();
    templateRunReportStruct.train = [];
    templateRunReportStruct.test = [];
    templateRunReportStruct.trainedModel = [];
    templateRunReportStruct.runPlan = [];
end