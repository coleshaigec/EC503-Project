function runResult = runPipeline(cmapssData, runPlan)
    % RUNPIPELINE Executes a single run of the preprocessing + training + reporting pipeline on a single windowed CMAPSS subset. 
    %
    % INPUTS
    %  cmapssData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (ntrain x d double)
    %                  .RUL (ntrain x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .sensorReadings (n x d double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    % 
    %  runPlan struct with fields
    %      .runNumber (positive integer)
    %      .experimentId (matches experimentSpec.id)
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
    %
    % DOCSTRING TO BE POPULATED

    % STOP
    % PREPROCESSING NEEDS TO BE DONE ** WITHIN ** EACH KFCV FOLD
    % Unless... we call this function WITHIN KFCV TLM
    % That probably makes more sense... let's do it
    % 

    % -- Extract desired subset of CMAPSS data -- 
    rawDataset = cmapssData.(runPlan.cmapssSubset);

    % -- Run k-fold cross-validation to tune hyperparameters --

    % -- Step 1: Apply preprocessing transforms to dataset --
    dataset = applyPreprocessingTransformsForPipelineRun(dataset, runPlan);

    % -- Step 2: 


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