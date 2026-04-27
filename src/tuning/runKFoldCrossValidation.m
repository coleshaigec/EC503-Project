function bestHyperparameters = runKFoldCrossValidation(cmapssSubset, runPlan)
    % RUNKFOLDCROSSVALIDATION Runs group k-fold cross-validation to tune hyperparameters for a specified model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  cmapssSubset struct with fields
    %      .train struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (ntrain x d double)
    %              .RUL (ntrain x 1 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .test struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (n x d double)
    %              .RULFinal (double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .name (string)
    %  runPlan struct with fields
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
    %      .warningHorizon (positive scalar array)  - classes for classification
    %      .windowSize (positive integer)            - for dataset windowing
    %      .numFolds (positive integer)              - number of CV folds
    %
    % OUTPUT
    %  bestHyperparameters (struct with model-specific fields)

    % -- Build cross-validation folds --
    folds = buildCrossValidationFolds(cmapssSubset, runPlan.windowSize, runPlan.numFolds, getTaskTypeFromModelName(runPlan.modelSpec.modelName), runPlan.warningHorizon);

    % -- Run core KFCV loop --
    templateTuningResultStruct = buildTemplateTuningResultStruct();
    tuningResults = repmat(templateTuningResultStruct, numel(folds), 1);

    for i = 1 : numel(folds)
        % -- Apply preprocessing to chosen folds --
        rawDataset = struct( ...
            'train', folds(i).train, ...
            'validation', folds(i).validation ...
        );

        preprocessedDataset = fitAndApplyPreprocessingForCVFold(rawDataset, runPlan);

        tuningResults(i) = tuneHyperparameters( ...
            preprocessedDataset.train, ...
            preprocessedDataset.validation, ...
            runPlan.modelSpec.modelName, ...
            runPlan.modelSpec.hyperparameterGrid, ...
            getTaskTypeFromModelName(runPlan.modelSpec.modelName), ...
            runPlan.warningHorizon...
        );
    end

    % -- Chose optimal hyperparameter values from tuning results
    bestHyperparameters = chooseBestHyperparameters(tuningResults);
end