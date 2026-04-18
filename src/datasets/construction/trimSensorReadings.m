function trimmedCMAPSSData = trimSensorReadings(cmapssData)
    % TRIMSENSORREADINGS Removes readings from unhelpful sensors in each
    % CMAPSS subset.

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