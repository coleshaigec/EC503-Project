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
        t = t ./ max(t);

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
    meanAbsoluteSlopes = mean(abs(slopes), 1, 'omitnan');

    % Consistency: fraction of engines with same sign
    slopeSigns = sign(slopes);
    slopeConsistency = max( ...
        mean(slopeSigns > 0, 1, 'omitnan'), ...
        mean(slopeSigns < 0, 1, 'omitnan') ...
    );

    validFraction = sum(~isnan(slopes), 1) / numEngines;

    slopeResult = struct();
    slopeResult.meanAbsoluteSlopes = meanAbsoluteSlopes;
    slopeResult.slopeConsistency = slopeConsistency;
    slopeResult.validFraction = validFraction;

    if shouldPlot
        % Plot sensor slopes
        figure; grid on;
        scatter(1:numSensors,meanAbsoluteSlopes);
        title(sprintf('Mean absolute sensor slope for CMAPSS subset %s', subsetName));
        xlabel('Sensor');
        ylabel('Mean absolute slope');
        xticks(1:numSensors);

        % Plot slope consistency
        figure; grid on;
        scatter(1:numSensors, slopeConsistency);
        title(sprintf('Sensor slope consistency across engines for CMAPSS subset %s', subsetName));
        xlabel('Sensor');
        ylabel('Slope consistency score');
        xticks(1:numSensors);
    end
end