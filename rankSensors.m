function rankingResult = rankSensors(cmapssData)
    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};
    shouldPlotSensorInfo = false;
    scoreWeights = [1; 3; 2; 1]; % NOT optimally tuned -- a heuristic guess
    epsilon = 1e-8;

    rankingResult = struct();

    % Compute global sensor variances
    varianceResult = computeAndPlotGlobalSensorVariances(cmapssData, false);

    for i = 1:numel(cmapssSubsets)
        % Extract current CMAPSS subset and relevant info on it
        currentSubsetName = cmapssSubsets{i};
        currentSubset = cmapssData.(currentSubsetName);

        % Step 1: Obtain training sensor variances for current subset
        sensorVariancesCurrentSubset = varianceResult.(currentSubsetName).train;

        % Step 2: Compute sensor/RUL correlations on training rows
        correlationResult = computeRULSensorCorrelations(currentSubset.train, shouldPlotSensorInfo, currentSubsetName);

        % Step 3: Fit mean slope lines at engine level
        slopeResult = analyzeSensorSlopes(currentSubset.train, shouldPlotSensorInfo, currentSubsetName);

        % Step 4: Check sensors violating explicit drop conditions
        sensorsWithZeroValidCorrelations = find(correlationResult.validFraction == 0);
        sensorsWithZeroGlobalVariance = find(sensorVariancesCurrentSubset == 0);
        sensorsWithZeroValidSlopes = find(slopeResult.validFraction == 0);

        badSensors1 = union(sensorsWithZeroGlobalVariance, sensorsWithZeroValidCorrelations);
        sensorsToDrop = union(badSensors1, sensorsWithZeroValidSlopes);

        % Step 5: Compute sensor scores
        sensorVariances = sensorVariancesCurrentSubset + epsilon;

        zScoresSensorVariances = zscore(log(sensorVariances));
        
        zScoresAbsoluteCorrelations = zscore(correlationResult.medianAbsoluteCorrelations);
        
        zScoresMeanAbsoluteSlopes = zscore(slopeResult.meanAbsoluteSlopes);

        zScoresSlopeConsistency = zscore(slopeResult.slopeConsistency);

        overallScores = scoreWeights(1) * zScoresSensorVariances + ...
                        scoreWeights(2) * zScoresAbsoluteCorrelations + ...
                        scoreWeights(3) * zScoresMeanAbsoluteSlopes + ...
                        scoreWeights(4) * zScoresSlopeConsistency;

        % Ensure sensors to drop are pushed to bottom of rankings
        overallScores(sensorsToDrop) = -Inf;
        [sortedScores, rankings] = sort(overallScores, 'descend');
        
        rankingResult.(currentSubsetName) = struct();
        rankingResult.(currentSubsetName).sortedScores = sortedScores;
        rankingResult.(currentSubsetName).rankings = rankings;
        rankingResult.(currentSubsetName).sensorsToDrop = sensorsToDrop;
    end
end