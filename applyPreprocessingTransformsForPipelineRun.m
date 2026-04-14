function dataset = applyPreprocessingTransformsForPipelineRun(rawDataset, runPlan)
    % APPLYPREPROCESSINGTRANSFORMSFORPIPELINERUN Applies preprocessing transforms for a single pipeline run.
    % 
    % INPUTS 
    %  rawDataset struct with fields
    %      .train struct with fields
    %          .X (ntrain x d double)       - training feature matrix
    %          .y (ntrain x 1 double)       - training labels
    %      .validation struct with fields
    %          .X (nvalidation x d double)  - validation feature matrix
    %          .y (nvalidation x 1 double)  - validation labels
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

    % -- Initialize output struct --
    dataset = struct( ...
        'train', [], ...
        'validation', [] ...
    );

    % -- Remap labels for classification --
    if ismember(runPlan.modelSpec.modelName, CLASSIFICATION_MODELS)
        % Remap labels
        yTrainRemapped = remapLabels(rawDataset.train.y, runPlan.warningHorizons);
        yValidationRemapped = remapLabels(rawDataset.validation.y, runPlan.warningHorizons);
        
        % Overwrite originals
        dataset.train.y = yTrainRemapped;
        dataset.validation.y = yValidationRemapped;
    end

    % -- If missingness is enabled, inject it --
    if runPlan.missingnessSpec.enabled
        error('buildDatasetForPipelineRun:MissingnessNotImplemented', 'Missingness injection is not yet implemented.');
    end

    % -- Normalize data --
    normalizationParameters = fitNormalizationTransform(rawDataset.train.X);
    dataset.train.X = applyNormalizationTransform(rawDataset.train.X, normalizationParameters);
    dataset.validation.X = applyNormalizationTransform(rawDataset.validation.X, normalizationParameters);

    % -- If PCA is enabled, fit and apply it --
    if runPlan.pcaSpec.enabled
        pcaTransform = fitPCATransform(dataset.train.X, runPlan.pcaSpec);
        dataset.train.X = applyPCATransform(dataset.train.X, pcaTransform);
        dataset.validation.X = applyPCATransform(dataset.validation.X, pcaTransform);
    end

end