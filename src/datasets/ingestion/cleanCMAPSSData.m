function cleanedCMAPSSData = cleanCMAPSSData(rawCMAPSSData)
    % CLEANCMAPSSDATA Strips extraneous information from raw CMAPSS dataset.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  cmapssData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %
    % OUTPUT
    %  cleanedCMAPSSData struct with fields
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
    CMAPSS_SUBSETS = getCMAPSSSubsets();

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
    fprintf('CMAPSS data cleaned successfully.\n');
end