function slopeResult = analyzeSensorSlopes(cmapssSubsetTrainingData, shouldPlot, subsetName)
   %ANALYZESENSORSLOPES Fits a linear regression model on each engine in
   %the training set to identify sensors that drift over an engine's
   %operating life
    numEngines = numel(cmapssSubsetTrainingData.engines);
    numSensors = size(cmapssSubsetTrainingData.engines(1).sensorReadings, 2);

    slopes = zeros(numEngines, numSensors);

    for i = 1:numEngines
        engine = cmapssSubsetTrainingData.engines(i);
        t = engine.timestamps;

        for k = 1:numSensors
            x = engine.sensorReadings(:, k);

            % Handle constant sensors safely
            if std(x) < 1e-12
                slopes(i, k) = NaN;
                continue;
            end

            p = polyfit(t, x, 1);
            slopes(i, k) = p(1);
        end
    end

    % Aggregate
    meanAbsSlope = mean(abs(slopes), 1, 'omitnan');

    % Consistency: fraction of engines with same sign
    slopeSigns = sign(slopes);
    slopeConsistency = max( ...
        mean(slopeSigns > 0, 1, 'omitnan'), ...
        mean(slopeSigns < 0, 1, 'omitnan') ...
    );

    validFraction = 1/numEngines * sum(~isnan(slopes));

    slopeResult = struct();
    slopeResult.meanAbsSlope = meanAbsSlope;
    slopeResult.slopeConsistency = slopeConsistency;
    slopeResult.validFraction = validFraction;
end