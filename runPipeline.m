function runReport = runPipeline(cmapssData, runPlan)
    % RUNPIPELINE Executes a single run of the preprocessing + training + reporting pipeline on a single windowed CMAPSS subset. 
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
    %      .experimentId (matches experimentSpec.id)
    %      .pcaSpec struct with fields
    %          .enabled (boolean)
    %          .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %          .varianceThreshold (double in [0,1]) - 
    %          .fixedNumComponents (int > 0) - number of principal components to compute 
    %
    %      .missingnessSpec struct with fields
    %          TBD FOR NOW
    %
    %      .modelSpec struct with fields
    %          .modelName (string)
    %          .hyperparameterGrid (struct with model-specific fields)
    %
    %      .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %      .warningHorizons (positive scalar array)  - classes for classification
    %      .windowSize (positive integer)            - for dataset windowing
    %
    %
    % DOCSTRING TO BE POPULATED

    % -- Extract desired subset of CMAPSS data -- 
    rawDataset = cmapssData.(runPlan.cmapssSubset);

    % -- Run k-fold cross-validation to tune hyperparameters --
    bestHyperparameters = runKFoldCrossValidation(rawDataset, runPlan);

    % -- Train full model using best hyperparameters -- 
    fullTrainingSet = windowTrainingDataset(rawDataset.engines, runPlan.windowSize);

    finalModelSpec = struct( ...
        'modelName', runPlan.modelSpec.modelName, ...
        'hyperparameters', bestHyperparameters ...
    );

    trainedModel = trainModel(fullTrainingSet, finalModelSpec);

    % -- Build run report --
    runReport = buildSingleRunReport();
end