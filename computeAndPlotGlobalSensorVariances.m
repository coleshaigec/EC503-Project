function computeAndPlotGlobalSensorVariances(cmapssData)
    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    for i = 1:numel(cmapssSubsets)
        
        currentSubset = cmapssData.(cmapssSubsets{i});
        numTrainEngines = currentSubset.train.numEngines;
        numTestEngines  = currentSubset.test.numEngines;

        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);
        numRecordsPerTrainEngine = zeros(numTrainEngines, 1);
        numRecordsPerTestEngine = zeros(numTestEngines, 1);
        
        
        for j = 1 : numTrainEngines
            numRecordsPerTrainEngine(j) = size(currentSubset.train.engines(j).timestamps, 1);
        end

        for j = 1 : numTestEngines
            numRecordsPerTestEngine(j) = size(currentSubset.test.engines(j).timestamps, 1);
        end

        trainRecords = vertcat(currentSubset.train.engines.sensorReadings);
        testRecords  = vertcat(currentSubset.test.engines.sensorReadings);

        trainVariances = var(trainRecords, 1);
        testVariances = var(testRecords, 1);

        figure(); hold on; grid on;
        scatter(1:numSensors, trainVariances, 's', 'MarkerFaceColor','b', 'MarkerEdgeColor','none');
        scatter(1:numSensors, testVariances, '^', 'MarkerFaceColor','r', 'MarkerEdgeColor','none');

        title(sprintf('Plot of sensor variances for CMAPSS subset %s', cmapssSubsets{i}));
        xlabel('Sensor number');
        ylabel('Variance');
        xticks(1:21);

    end
end