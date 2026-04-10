function experimentResult = runExperiment(experimentSpec)
    % RUNEXPERIMENT Runs entire experiment pipeline end-to-end in accordance with provided spec
    %
    % INPUTS
    %  experimentSpec struct with fields
    %      .id         (positive integer)
    %      .modelSpecs (array of modelSpec structs - see OUTPUTS)
    %      .pcaSpecs   (array of pcaSpec structs - see OUTPUTS)
    %      .missingnessSpecs (array of missingnessSpec structs -- see OUTPUTS)
    %      .warningHorizons (nonempty cell array; each cell contains a positive numeric vector)
    %      .cmapssSubsets (nonempty cell array of subset names: 'FD001', 'FD002', 'FD003', or 'FD004')
    %      .windowSizes (array of positive integers)
    %
    % OUTPUTS
    %  experimentResult struct with fields


    % -- Input validation --
    validateExperimentSpec(experimentSpec);

    % -- Unpack experimentSpec and generate runPlans --
    runPlans = buildRunPlansFromExperimentSpec(experimentSpec);

    % -- Ingest CMAPSS data and build cross-validation folds for each chosen subset --
    rawCMAPSSData = readCMAPSSData();
    numChosenSubsets = numel(experimentSpec.cmapssSubsets);

    templateCVFold = struct( ...
        'X', [], ...
        'y', []...
    );

    cvFolds = repmat(templateCVFold, CROSS_VALIDATION_FOLDS, numChosenSubsets);

    for i = 1 : numChosenSubsets
        currentSubsetName = experimentSpec.cmapssSubsets{i};
        currentSubset = rawCMAPSSData.(currentSubsetName);
        currentSubsetFolds = buildCrossValidationFolds(currentSubset);
    end

    % -- 
end