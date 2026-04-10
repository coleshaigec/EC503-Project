function runPipeline(rawCMAPSSData, runPlan)
    %RUNPIPELINE Executes a single run of the preprocessing + training + reporting pipeline on a single windowed CMAPSS subset. 
    %
    % DOCSTRING TO BE POPULATED

    % -- Step 1: Build dataset --
    dataset = buildDatasetForPipelineRun(rawCMAPSSData, runPlan);

    % -- Step 2: Apply feature transformations -- 
    transformationSpec = struct();
    transformationSpec.pcaSpec = runPlan.pcaSpec;

    transformedData = applyFeatureTransformationsToData(dataWithPathologies, transformationSpec);

    % -- Step 3: Split off validation set(s) and run hyperparameter tuning --
    
    



    
end