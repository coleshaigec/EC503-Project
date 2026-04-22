function runReport = runPipeline(cmapssData, runPlan)
    % RUNPIPELINE Executes a single run of the preprocessing + training + reporting pipeline on a single windowed CMAPSS subset. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  cmapssData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    % 
    %  runPlan struct with fields
    %      .runNumber (positive integer)
    %      .pcaSpec struct with fields
    %          .enabled (boolean)
    %          .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %          .varianceThreshold (double in [0,1]) - 
    %          .fixedNumComponents (int > 0) - number of principal components to compute 
    %
    %      .modelSpec struct with fields
    %          .modelName (string)
    %          .hyperparameterGrid (struct with model-specific fields)
    %
    %      .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %      .warningHorizon (positive integer)        - TTF threshold for classification
    %      .windowSize (positive integer)            - for dataset windowing
    %
    % OUTPUT
    %  runReport struct with fields
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
    %          .warningHorizon (positive integer)        - TTF threshold for classification
    %          .windowSize (positive integer)            - for dataset windowing
    %          .numFolds (positive integer)              - number of cross-validation folds

    % -- Extract desired subset of CMAPSS data -- 
    rawDataset = cmapssData.(runPlan.cmapssSubset);

    % -- Run k-fold cross-validation to tune hyperparameters --
    bestHyperparameters = runKFoldCrossValidation(rawDataset, runPlan);

    % -- Build full datasets for final model run -- 
    finalModelSpec = struct( ...
        'modelName', runPlan.modelSpec.modelName, ...
        'hyperparameters', bestHyperparameters ...
    );

    fullTrainingSet = windowTrainingDataset(rawDataset.train.engines, runPlan.windowSize);
    fullTestSet = windowTestDataset(cmapssData.(runPlan.cmapssSubset).test, runPlan.windowSize);

    if strcmp(getTaskTypeFromModelName(finalModelSpec.modelName), 'classification')
        fullTrainingSet.y = remapLabels(fullTrainingSet.y, runPlan.warningHorizon);
        fullTestSet.y = remapLabels(fullTestSet.y, runPlan.warningHorizon);
    end
    
    trainedModel = trainModel(fullTrainingSet, finalModelSpec);

    % -- Build run report --
    runReport = buildSingleRunReport(trainedModel, fullTrainingSet, fullTestSet, runPlan);
end