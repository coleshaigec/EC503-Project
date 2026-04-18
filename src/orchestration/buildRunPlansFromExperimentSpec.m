function runPlans = buildRunPlansFromExperimentSpec(experimentSpec)
    % BUILDRUNPLANSFROMEXPERIMENTSPEC Decomposes an experiment spec into a pipeline run plan
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  experimentSpec struct with fields
    %      .modelSpecs (array of modelSpec structs - see OUTPUTS)
    %      .pcaSpecs   (array of pcaSpec structs - see OUTPUTS)
    %      .warningHorizons (nonempty cell array; each cell contains a positive numeric vector)
    %      .cmapssSubsets (nonempty cell array of subset names: 'FD001', 'FD002', 'FD003', or 'FD004')
    %      .windowSizes (array of positive integers)
    %      .numFolds (positive integer)
    %
    % OUTPUTS
    %  runPlans array of runPlan structs, each with fields
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
    %      .warningHorizon (positive scalar array)   - TTF threshold for classification
    %      .windowSize (positive integer)            - for dataset windowing

    % -- Validate experimentSpec --
    validateExperimentSpec(experimentSpec);

    % -- Unpack experimentSpec to determine number of runs --
    numWindowSizes = numel(experimentSpec.windowSizes);
    numWarningHorizons = numel(experimentSpec.warningHorizons);
    numPCASpecs = numel(experimentSpec.pcaSpecs);
    numModels = numel(experimentSpec.modelSpecs);
    numCMAPSSSubsets = numel(experimentSpec.cmapssSubsets);
    
    numRuns = numWindowSizes * numPCASpecs * numModels * numCMAPSSSubsets * numWarningHorizons;

    % -- Build template runPlan and preallocate output --
    templateRunPlan = buildTemplateRunPlanStruct();
    runPlans = repmat(templateRunPlan, numRuns, 1);

    % -- Enumerate Cartesian product of run specifications --
    unpackedExperimentSpec = combinations( ...
        experimentSpec.windowSizes, ...
        experimentSpec.pcaSpecs, ...
        experimentSpec.modelSpecs, ...
        experimentSpec.cmapssSubsets, ...
        experimentSpec.warningHorizons ...
    );

    assert(height(unpackedExperimentSpec) == numRuns, ...
    'Run count mismatch: expected %d runs, but combinations returned %d.', ...
    numRuns, height(unpackedExperimentSpec));

    % -- Populate output struct array --
    for i = 1 : numRuns
        % Extract parameters from unpackedExperimentSpec
        currentRunPlan = templateRunPlan;
        currentWindowSize = unpackedExperimentSpec{i, 1};
        currentPCASpec = unpackedExperimentSpec{i, 2};
        currentModelSpec = unpackedExperimentSpec{i, 3};
        currentCMAPSSSubset = string(unpackedExperimentSpec{i, 4});
        currentWarningHorizon = unpackedExperimentSpec{i, 5};

        % Populate run plan
        currentRunPlan.runNumber = i;
        currentRunPlan.windowSize = currentWindowSize;
        currentRunPlan.pcaSpec = currentPCASpec;
        currentRunPlan.modelSpec = currentModelSpec;
        currentRunPlan.cmapssSubset = currentCMAPSSSubset;
        currentRunPlan.warningHorizon = currentWarningHorizon;
        currentRunPlan.numFolds = experimentSpec.numFolds;

        % Add run plan to output struct array
        runPlans(i) = currentRunPlan;
    end
end