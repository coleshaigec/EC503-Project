function correlationResult = computeRULSensorCorrelations(cmapssSubsetTrainingData, shouldPlot, subsetName)
    %COMPUTERULSENSORCORRELATIONS Computes correlations between sensor
    %readings and RUL for rows of the training portion of a subset of the
    %CMAPSS dataset

    % Compute correlations at engine level first, then aggregate
    numEngines = numel(cmapssSubsetTrainingData.engines);
    numSensors = size(cmapssSubsetTrainingData.engines(1).sensorReadings, 2);

    correlationsEngineLevel = zeros(numEngines, numSensors);

    for i = 1 : numEngines
        currentEngine = cmapssSubsetTrainingData.engines(i);
        currentSensorReadings = currentEngine.sensorReadings;
        currentRULs = currentEngine.RUL;

        currentEngineCorrelations = corr(currentSensorReadings, currentRULs);
        correlationsEngineLevel(i, :) = currentEngineCorrelations.';
    end

    validFraction = 1/numEngines * sum(~isnan(correlationsEngineLevel));

    correlationResult = struct();
    correlationResult.meanAbsoluteCorrelations = mean(abs(correlationsEngineLevel), 1, 'omitnan');
    correlationResult.medianAbsoluteCorrelations = median(abs(correlationsEngineLevel), 1, 'omitnan');
    correlationResult.validFraction = validFraction;

    if shouldPlot
        figure; grid on; hold on;
        scatter(1:numSensors, correlationResult.meanAbsoluteCorrelations);
        scatter(1:numSensors, correlationResult.medianAbsoluteCorrelations);
        title(sprintf('Mean and median absolute sensor/RUL correlations for CMAPSS subset %s', subsetName));
        xlabel('Sensor');
        ylabel('Correlation');
        xticks(1:numSensors);
        legend({'Mean absolute correlation', 'Median absolute correlation'}, 'Location', 'Best');
    end
end