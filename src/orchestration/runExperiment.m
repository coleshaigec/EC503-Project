function experimentReport = runExperiment(experimentSpec)
    % RUNEXPERIMENT Runs entire experiment pipeline end-to-end in accordance with provided spec
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
    %  experimentResult struct with fields
    %
    % SIDE EFFECTS ?
    % Maybe we write outputs to a file...


    % NOTE TO SELF
    % This function shouldn't return anything! Side effects only

    % -- Input validation --
    validateExperimentSpec(experimentSpec);

    % -- Unpack experimentSpec and generate runPlans --
    runPlans = buildRunPlansFromExperimentSpec(experimentSpec);
    numRuns = numel(runPlans);

    % -- Ingest and clean CMAPSS data --
    rawCMAPSSData = readCMAPSSData();
    cleanedCMAPSSData = cleanCMAPSSData(rawCMAPSSData);

    % -- Carry out pipeline runs --
    templateRunReport = buildTemplateRunReportStruct();
    runReports = repmat(templateRunReport, numRuns, 1);

    for i = 1 : numRuns
        runReports(i) = runPipeline(cleanedCMAPSSData, runPlans(i));
    end

    % -- Pass pipeline runs through reporting utility --
    experimentReport = struct();
    fprintf('Pipeline run complete.\n');
    










end