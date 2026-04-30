function dataset = fitAndApplyPreprocessingForCVFold(rawDataset, runPlan)
    % FITANDAPPLYPREPROCESSINGFORCVFOLD Applies preprocessing transforms for a single cross-validation run.
    %
    % AUTHOR: Cole H. Shaigec
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
    %      .modelSpec struct with fields
    %          .modelName (string)
    %          .hyperparameterGrid (struct with model-specific fields)
    %
    %      .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %      .warningHorizon (positive integer)        - TTF threshold for classification
    %      .windowSize (positive integer)            - for dataset windowing
    %      .numFolds (positive integer)              - number of CV folds
    %
    % OUTPUTS

    % -- Initialize output struct --
    dataset = struct( ...
        'train', [], ...
        'validation', [] ...
    );

    % -- Normalize data --
    standardizationParameters = fitStandardizationTransform(rawDataset.train.X);
    dataset.train.X = applyStandardizationTransform(rawDataset.train.X, standardizationParameters);
    dataset.validation.X = applyStandardizationTransform(rawDataset.validation.X, standardizationParameters);

    % -- If PCA is enabled, fit and apply it --
    if runPlan.pcaSpec.enabled
        pcaTransform = fitPCATransform(dataset.train.X, runPlan.pcaSpec);
        dataset.train.X = applyPCATransform(dataset.train.X, pcaTransform);
        dataset.validation.X = applyPCATransform(dataset.validation.X, pcaTransform);
    end

    % -- Add labels onto final result --
    dataset.train.y = rawDataset.train.y;
    dataset.validation.y = rawDataset.validation.y;
end