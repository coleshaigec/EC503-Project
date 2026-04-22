function trimmedCMAPSSData = trimSensorReadings(cmapssData)
    % TRIMSENSORREADINGS Removes readings from unhelpful sensors in each CMAPSS subset.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
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
    %  trimmedCMAPSSData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RUL (maxTimestamp x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %          .retainedSensorIndices (1 x numRetainedSensors double)
    %          .droppedSensorIndices (1 x numDroppedSensors double)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RUL (maxTimestamp x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %          .retainedSensorIndices (1 x numRetainedSensors double)
    %          .droppedSensorIndices (1 x numDroppedSensors double)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RUL (maxTimestamp x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %          .retainedSensorIndices (1 x numRetainedSensors double)
    %          .droppedSensorIndices (1 x numDroppedSensors double)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RUL (maxTimestamp x 1 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x numRetainedSensors double)
    %                  .RULFinal (double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %          .retainedSensorIndices (1 x numRetainedSensors double)
    %          .droppedSensorIndices (1 x numDroppedSensors double)

    rankingResult = rankSensors(cmapssData);
    trimmedCMAPSSData = cmapssData;

    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    for i = 1:numel(cmapssSubsets)
        currentSubsetName = cmapssSubsets{i};
        currentSubset = cmapssData.(currentSubsetName);

        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);
        sensorIndices = 1:numSensors;

        sensorsToDrop = rankingResult.(currentSubsetName).sensorsToDrop;
        survivingSensors = setdiff(sensorIndices, sensorsToDrop);

        numTrainEngines = numel(currentSubset.train.engines);
        numTestEngines = numel(currentSubset.test.engines);

        for j = 1:numTrainEngines
            trimmedCMAPSSData.(currentSubsetName).train.engines(j).sensorReadings = ...
                currentSubset.train.engines(j).sensorReadings(:, survivingSensors);
        end

        for j = 1:numTestEngines
            trimmedCMAPSSData.(currentSubsetName).test.engines(j).sensorReadings = ...
                currentSubset.test.engines(j).sensorReadings(:, survivingSensors);
        end

        trimmedCMAPSSData.(currentSubsetName).retainedSensorIndices = survivingSensors;
        trimmedCMAPSSData.(currentSubsetName).droppedSensorIndices = sensorsToDrop;
    end
end