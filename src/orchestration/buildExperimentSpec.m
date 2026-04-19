function experimentSpec = buildExperimentSpec()
    % BUILDEXPERIMENTSPEC Defines plan of experimentation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  experimentSpec struct with fields
    %      .modelSpecs (array of modelSpec structs)
    %      .pcaSpecs   (array of pcaSpec structs)
    %      .warningHorizons (nonempty cell array; each cell contains a positive numeric vector)
    %      .cmapssSubsets (nonempty cell array of subset names: 'FD001', 'FD002', 'FD003', or 'FD004')
    %      .windowSizes (array of positive integers)
    %      .numFolds (positive integer)
    %
    %
    % NOTES
    % - This function is the source of truth for defining the
    % experimentation plan. To change the scope of experimentation, change
    % the hard-coded parameters in this file. 

    % -- Add models --
    numberOfModelsToAnalyze = 1; % must equal the number of models below
    modelSpecs = repmat(buildTemplateModelSpecStruct(), numberOfModelsToAnalyze, 1);

    % Naive Bayes used as initial "happy path" model to get pipeline working
    % This may be removed/replaced later
    modelSpecs(1) = struct( ...
        'modelName', 'naiveBayes', ...
        'hyperparameterGrid', struct( ...
             'varianceSmoothing', [1e-10; 1e-8; 1e-6; 1e-4] ...
         ) ...
    );

    % -- Add PCA -- 
    numPCAScenarios = 3;
    pcaSpecs = repmat(buildTemplatePCASpecStruct(), numPCAScenarios, 1);

    pcaSpecs(1) = struct( ...
        'enabled', true, ...
        'selectionMode', 'varianceThreshold', ...
        'varianceThreshold', 0.95, ...
        'fixedNumComponents', 0 ...
    );

    pcaSpecs(2) = struct( ...
        'enabled', true, ...
        'selectionMode', 'fixedNumComponents', ...
        'varianceThreshold', 0, ...
        'fixedNumComponents', 4 ...
    );

    pcaSpecs(3) = struct( ...
        'enabled', false, ...
        'selectionMode', 'varianceThreshold', ...
        'varianceThreshold', 0.95, ...
        'fixedNumComponents', 0 ...
    );

    % -- Add warning horizons --
    warningHorizons = {1, 4, 6, 8, 10, 15, 20};

    % -- Choose CMAPSS subsets -- 
    cmapssSubsets = {'FD001', 'FD003'};

    % -- Choose window sizes --
    windowSizes = 1:1:5;

    % -- Set cross-validation fold policy --
    numFolds = 5;

    % -- Populate output struct --
    experimentSpec = struct();
    experimentSpec.modelSpecs = modelSpecs;
    experimentSpec.pcaSpecs = pcaSpecs;
    experimentSpec.warningHorizons = warningHorizons;
    experimentSpec.cmapssSubsets = cmapssSubsets;
    experimentSpec.windowSizes = windowSizes;
    experimentSpec.numFolds = numFolds;

    % -- Validate experimentSpec --
    validateExperimentSpec(experimentSpec);
end