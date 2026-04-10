function dataset = buildDatasetForPipelineRun(windowedCMAPSSData, runPlan)
    % BUILDDATASETFORPIPELINERUN Builds pipeline-ready tabular dataset from windowed CMAPSS data according to plan for a single pipeline run. 
    % 
    % INPUTS 
    %  windowedCMAPSSData struct with fields
    %      .FD001 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD002 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD003 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD004 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
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
        error('buildDatasetForPipelineRun:MissingnessNotImplemented', 'Missingness injection is not yet implemented.'); % TO BE IMPLEMENTEd
    end

    % -- Normalize data --
    normalizationParameters = fitNormalizationTransform(chosenSubset.Xtrain);
    chosenSubset.Xtrain = applyNormalizationTransform(chosenSubset.Xtrain, normalizationParameters);
    chosenSubset.Xtest = applyNormalizationTransform(chosenSubset.Xtest, normalizationParameters);

    % -- If PCA is enabled, fit and apply it --
    if runPlan.pcaSpec.enabled
        pcaTransform = fitPCATransform(chosenSubset.Xtrain, runPlan.pcaSpec);
        chosenSubset.Xtrain = applyPCATransform(chosenSubset.Xtrain, pcaTransform);
        chosenSubset.Xtest = applyPCATransform(chosenSubset.Xtest, pcaTransform);
    end

    % -- Populate output struct --
    dataset = struct();
    dataset.Xtrain = chosenSubset.Xtrain;
    dataset.Xtest = chosenSubset.Xtest;
    dataset.ytrain = chosenSubset.ytrain;
    dataset.ytest = chosenSubset.ytest;
    dataset.ntrain = size(chosenSubset.Xtrain, 1);
    dataset.ntest = size(chosenSubset.Xtest, 1);
    dataset.d = size(chosenSubset.Xtrain, 2);

end