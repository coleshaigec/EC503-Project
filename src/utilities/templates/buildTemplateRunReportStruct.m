function templateRunReport = buildTemplateRunReportStruct()
    % BUILDTEMPLATERUNREPORTSTRUCT Utility that constructs template runReport struct for use in preallocation.
    %  OUTPUTS
    %   runReport struct with fields
    %       .train struct with fields
    %           .yHat   - predicted labels
    %           .yTrue  - true labels
    %           .performanceMetrics struct with model-dependent fields
    %       .test
    %           .yHat   - predicted labels
    %           .yTrue  - true labels
    %           .performanceMetrics struct with model-dependent fields
    %       .trainedModel struct with fields
    %           .model (struct)             - trained model
    %           .modelName (string)         - model type to be trained
    %           .taskType  (string)         - 'classification' or 'regression'
    %           .hyperparameters            - hyperparameters used in training
    %       .runPlan struct with fields
    %           .runNumber (positive integer)
    %           .pcaSpec struct with fields
    %               .enabled (boolean)
    %               .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %               .varianceThreshold (double in [0,1]) - 
    %               .fixedNumComponents (int > 0) - number of principal components to compute 
    %     
    %           .modelSpec struct with fields
    %               .modelName (string)
    %               .hyperparameterGrid (struct with model-specific fields)
    %     
    %           .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %           .warningHorizon (positive integer)        - TTF threshold for classification
    %           .windowSize (positive integer)            - for dataset windowing
    %       .policyAnalysisResult struct with fields
    %       .errorDiagnosticsResult struct with fields

    templateRunReport = struct();
    templateRunReport.train = [];
    templateRunReport.test = [];
    templateRunReport.trainedModel = [];
    templateRunReport.runPlan = [];
    templateRunReport.policyAnalysisResult = [];
    templateRunReport.errorDiagnosticsResult = [];

end