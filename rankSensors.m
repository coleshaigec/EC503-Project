function rankings = rankSensors(cmapssData)
    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    % Compute global sensor variances
    varianceResult = computeAndPlotGlobalSensorVariances(cmapssData, false);

    for i = 1:numel(cmapssSubsets)
        % Extract current CMAPSS subset and relevant info on it
        currentSubsetName = cmapssSubsets{i};
        currentSubset = cmapssData.(currentSubsetName);
        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);

        % Step 1: Obtain training sensor variances for current subset
        sensorVariancesCurrentSubset = varianceResult.(currentSubsetName).train;

        % Step 2: Compute sensor/RUL correlations on training rows
        correlationResult = computeRULSensorCorrelations(currentSubset.train, false, currentSubsetName);

        % Step 3: Fit mean slope lines at engine level
        


        % NEED TO ENFORCE HARD DROP CONDITIONS (E.G. ZERO
        % VALIDFRACTION) AS WELL AS RECOMMENDING SOFT ONES

    end
end