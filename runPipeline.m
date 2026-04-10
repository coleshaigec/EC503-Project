function runPipeline(windowedCMAPSSData, runPlan)
    %RUNPIPELINE Executes a single run of the preprocessing + training + reporting pipeline on a single windowed CMAPSS subset. 
    %
    % DOCSTRING TO BE POPULATED

    % -- Step 1: Build and validate dataset --
    dataset = buildDatasetForPipelineRun(windowedCMAPSSData, runPlan);
    validateDatasetForPipelineRun(dataset);

    % -- Step 2: Run k-fold cross-validation  --
    % This will produce a trained model

    % -- Step 3: Pass trained model through reporting suite --
    % To be implemented
    % Important architectural question: how does this get propagated upward
    % to report general experiment results? Presumably we don't want the
    % experimenter having to amalgamate a bunch of pipeline-level report
    % files, so perhaps the best choice is to build a reporting struct from
    % the pipeline run and propagate it upward to the experiment runner,
    % which will in turn call some suite like reportExperimentResults.m
    % that compiles whatever analytics we want and presents them cleanly
end