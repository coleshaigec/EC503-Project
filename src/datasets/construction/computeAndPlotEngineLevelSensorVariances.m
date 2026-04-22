function computeAndPlotEngineLevelSensorVariances(cmapssData)
    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};
    
    for i = 1:numel(cmapssSubsets)
        
        currentSubset = cmapssData.(cmapssSubsets{i});

        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);
        
        numTrainEngines = currentSubset.train.numEngines;
        numTestEngines  = currentSubset.test.numEngines;
        
        trainVariances = zeros(numTrainEngines, numSensors);
        testVariances  = zeros(numTestEngines, numSensors);

        for j = 1 : numTrainEngines
            trainVariances(j, :) = var(currentSubset.train.engines(j).sensorReadings, 1);
        end

        for j = 1 : numTestEngines
            testVariances(j, :) = var(currentSubset.test.engines(j).sensorReadings, 1);
        end

        figure(); hold on; grid on;
        scatter(1:numSensors, trainVariances, 's', 'MarkerFaceColor','b', 'MarkerEdgeColor','none');
        scatter(1:numSensors, testVariances, '^', 'MarkerFaceColor','r', 'MarkerEdgeColor','none');

        title(sprintf('Plot of engine-level sensor variances for CMAPSS subset %s', cmapssSubsets{i}));
        xlabel('Sensor number');
        ylabel('Variance');
        xticks(1:21);

    end
end