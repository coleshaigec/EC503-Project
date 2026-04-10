function dataset = buildDatasetForPipelineRun(rawCMAPSSData, runPlan)
    % BUILDDATASETFORPIPELINERUN Applies preprocessing transforms to raw CMAPSS data according to plan for a single pipeline run. 
    % 
    % INPUTS 
    %  rawCMAPSSData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %
    %  runPlan struct with fields
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
    % OUTPUTS


    % -- Trim off undesired sensors and apply windowing -- 
    trimmedCMAPSSData = trimSensorReadings(cmapssData);
    windowedCMAPSSData = buildWindowedDataset(trimmedCMAPSSData, runPlan.windowSize);

    % -- Choose desired CMAPSS subset from windowed data --
    chosenSubset = windowedCMAPSSData.(runPlan.cmapssSubset);

    % -- Remap labels for classification --
    if ismember(runPlan.modelSpec.modelName, CLASSIFICATION_MODELS)
        % Remap labels
        yTrainRemapped = remapLabels(chosenSubset.ytrain, runPlan.warningHorizons);
        yTestRemapped = remapLabels(chosenSubset.ytest, runPlan.warningHorizons);
        
        % Overwrite originals
        chosenSubset.ytrain = yTrainRemapped;
        chosenSubset.ytest = yTestRemapped;
    end

    % -- If missingness is enabled, inject it --
    if runPlan.missingnessSpec.enabled
        fprintf('!!! MISSINGNESS TO BE IMPLEMENTED !!!'); % TO BE IMPLEMENTEd
    end

    % -- Normalize data --
    normalizationParameters = fitNormalizationTransform(chosenSubset.Xtrain);
    chosenSubset.Xtrain = applyNormalizationTransform(chosenSubset.Xtrain, normalizationParameters);
    chosenSubset.Xtest = applyNormalizationTransform(chosenSubset.Xtest, normalizationParameters);

    % -- If PCA is enabled, apply it --
    if runPlan.pcaSpec.enabled
        pcaTransform = fitPCATransform(chosenSubset.Xtrain, runPlan.pcaSpec);
        
    end


    
end