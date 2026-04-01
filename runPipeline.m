function runPipeline(rawData, runSpec)
    %RUNPIPELINE Executes a single run of the preprocessing + training +
    %reporting pipeline on a single windowed CMAPSS subset. 

    % Step 1: Inject pathologies to data
    pathologySpec = struct();
    pathologySpec.missingnessSpec = runSpec.missingnessSpec;
    pathologySpec.imbalanceSpec = runSpec.imbalanceSpec;

    dataWithPathologies = injectPathologiesToData(rawData, pathologySpec);

    % Step 2: Apply feature transformations
    transformationSpec = struct();
    transformationSpec.pcaSpec = runSpec.pcaSpec;
    transformationSpec.normalizationSpec = struct(...
        'enabled', true... % TECHNICAL DEBT -- THIS MUST BE CONFIGURED UPSTREAM
    );

    transformedData = applyFeatureTransformationsToData(dataWithPathologies, transformationSpec);

    % Step 3: Run hyperparameter tuning on training set




    
end