function rankings = rankSensors(cmapssData)
    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    for i = 1:numel(cmapssSubsets)
        
        currentSubset = cmapssData.(cmapssSubsets{i});
        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);

        % Step 1: Obtain sensor variances
        sensorVariances = computeAndPlotGlobalSensorVariances(cmapssData, false);

        % Step 2: Compute sensor/RUL correlations on training rows
        correlationResult = computeRULSensorCorrelations(currentSubset.train, false, cmapssSubsets{i});

        % Step 3: 

        % NEED TO ENFORCE HARD DROP CONDITIONS (E.G. ZERO
        % VALIDFRACTION) AS WELL AS RECOMMENDING SOFT ONES

    end
end