function cleanedCMAPSSData = cleanCMAPSSData(rawCMAPSSData)
    % CLEANCMAPSSDATA Strips extraneous information from raw CMAPSS dataset.
    %
    % AUTHOR: Cole H. Shaigec

    % Define subset names locally to avoid global dependencies
    CMAPSS_SUBSETS = {'FD001', 'FD002', 'FD003', 'FD004'};

    % Trim unwanted sensors first
    trimmedCMAPSSData = trimSensorReadings(rawCMAPSSData);

    % Initialize output struct
    cleanedCMAPSSData = struct();

    % Template structs for preallocation
    templateTrainEngine = struct('sensorReadings', [], 'RUL', []);
    templateTestEngine  = struct('sensorReadings', [], 'RULFinal', []);

    for i = 1:numel(CMAPSS_SUBSETS)
        subsetName = CMAPSS_SUBSETS{i};
        rawSubset = trimmedCMAPSSData.(subsetName);

        % Preallocate engine arrays
        cleanedTrainEngines = repmat(templateTrainEngine, rawSubset.train.numEngines, 1);
        cleanedTestEngines  = repmat(templateTestEngine,  rawSubset.test.numEngines, 1);

        % --- Clean training engines ---
        for j = 1:rawSubset.train.numEngines
            cleanedTrainEngines(j).sensorReadings = rawSubset.train.engines(j).sensorReadings;
            cleanedTrainEngines(j).RUL = rawSubset.train.engines(j).RUL;
        end

        % --- Clean test engines ---
        for j = 1:rawSubset.test.numEngines
            cleanedTestEngines(j).sensorReadings = rawSubset.test.engines(j).sensorReadings;
            cleanedTestEngines(j).RULFinal = rawSubset.test.engines(j).RULFinal;
        end

        % --- Populate subset ---
        cleanedCMAPSSData.(subsetName) = struct();
        cleanedCMAPSSData.(subsetName).train.engines = cleanedTrainEngines;
        cleanedCMAPSSData.(subsetName).train.numEngines = rawSubset.train.numEngines;
        cleanedCMAPSSData.(subsetName).train.numRecords = rawSubset.train.numRecords;

        cleanedCMAPSSData.(subsetName).test.engines = cleanedTestEngines;
        cleanedCMAPSSData.(subsetName).test.numEngines = rawSubset.test.numEngines;
        cleanedCMAPSSData.(subsetName).test.numRecords = rawSubset.test.numRecords;

        cleanedCMAPSSData.(subsetName).name = rawSubset.name;
    end
end