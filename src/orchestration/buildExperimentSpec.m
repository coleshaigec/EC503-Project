function experimentSpec = buildExperimentSpec()
    % BUILDEXPERIMENTSPEC Defines plan of experimentation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  experimentSpec struct with fields
    %      .id         (positive integer)
    %      .modelSpecs (array of modelSpec structs)
    %      .pcaSpecs   (array of pcaSpec structs)
    %      .warningHorizons (nonempty cell array; each cell contains a positive numeric vector)
    %      .cmapssSubsets (nonempty cell array of subset names: 'FD001', 'FD002', 'FD003', or 'FD004')
    %      .windowSizes (array of positive integers)
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
        'hyperparameters', struct( ...
             'alpha', 0.1 : 0.1 : 1 ...
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
    warningHorizons = mat2cell(1 : 5 : 16);

    % -- Choose CMAPSS subsets -- 
    cmapssSubsets = {'FD001', 'FD003'};

    % -- Choose window sizes --
    windowSizes = 1:1:5;

    % -- Populate output struct --
    experimentSpec = struct();
    experimentSpec.id = 1;
    experimentSpec.modelSpecs = modelSpecs;
    experimentSpec.pcaSpecs = pcaSpecs;
    experimentSpec.warningHorizons = warningHorizons;
    experimentSpec.cmapssSubsets = cmapssSubsets;
    experimentSpec.windowSizes = windowSizes;

    % -- Validate experimentSpec --
    validateExperimentSpec(experimentSpec);
end