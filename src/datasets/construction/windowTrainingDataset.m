function windowedEngines = windowTrainingDataset(engines, windowSize)
    % WINDOWTRAININGDATASET Applies rectangular history windowing to the
    % training data in a CMAPSS subset.
    %
    % INPUTS
    %
    %
    % OUTPUTS

    % NOTE TO SELF: THIS NEEDS A REFACTOR TO HANDLE CLEANED CMAPSS SET!
    
    numEngines = numel(engines);
    Xcells = cell(numEngines, 1);
    Ycells = cell(numEngines, 1);

    for i = 1:numEngines
        currentEngine = engines(i);
        sensorReadingsCurrentEngine = currentEngine.sensorReadings;
        operatingConditionsCurrentEngine = currentEngine.operatingConditions;
        RULCurrentEngine = currentEngine.RUL;

        [numReadings, numSensors] = size(sensorReadingsCurrentEngine);
        numOperatingConditions = size(operatingConditionsCurrentEngine, 2);

        numWindowedSamples = numReadings - windowSize + 1;
        assert(numWindowedSamples > 0, 'Window size exceeds engine trajectory length.');

        idxWindows = (1:windowSize) + (0:(numWindowedSamples - 1)).';

        % Build windowed sensor block: N x (W*S)
        XengineSensors = zeros(numWindowedSamples, windowSize * numSensors);
        for s = 1:numSensors
            currentSensor = sensorReadingsCurrentEngine(:, s);
            sensorWindows = currentSensor(idxWindows); % N x W
        
            colStart = (s - 1) * windowSize + 1;
            colEnd = s * windowSize;
            XengineSensors(:, colStart:colEnd) = sensorWindows;
        end

        % Append current operating conditions only
        XengineOperatingConditions = operatingConditionsCurrentEngine(windowSize:end, :);

        Xengine = [XengineOperatingConditions, XengineSensors];
        yengine = RULCurrentEngine(windowSize:end);

        assert(size(Xengine, 1) == numWindowedSamples);
        assert(size(yengine, 1) == numWindowedSamples);
        assert(size(XengineOperatingConditions, 2) == numOperatingConditions);

        Xcells{i} = Xengine;
        Ycells{i} = yengine;
    end

    X = vertcat(Xcells{:});
    y = vertcat(Ycells{:});
    windowedEngines = struct();
    windowedEngines.X = X;
    windowedEngines.y = y;
end