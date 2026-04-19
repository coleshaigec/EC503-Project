function windowedEngines = windowTrainingDataset(engines, windowSize)
    % WINDOWTRAININGDATASET Applies rectangular history windowing to the training data in a CMAPSS subset.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %
    %
    % OUTPUTS

    % NOTE TO SELF: THIS NEEDS A REFACTOR TO HANDLE CLEANED CMAPSS SET!
    
    % -- Preallocate cell arrays for vertcat --
    numEngines = numel(engines);
    Xcells = cell(numEngines, 1);
    Ycells = cell(numEngines, 1);

    % -- Window sensor readings at engine level --
    for i = 1:numEngines
        currentEngine = engines(i);
        sensorReadingsCurrentEngine = currentEngine.sensorReadings;
        RULCurrentEngine = currentEngine.RUL;

        [numReadings, numSensors] = size(sensorReadingsCurrentEngine);

        numWindowedSamples = numReadings - windowSize + 1;
        assert(numWindowedSamples > 0, 'Window size exceeds engine trajectory length.');

        idxWindows = (1:windowSize) + (0:(numWindowedSamples - 1)).';

        % Build windowed sensor block: N x (W*S)
        Xengine = zeros(numWindowedSamples, windowSize * numSensors);
        for s = 1:numSensors
            currentSensor = sensorReadingsCurrentEngine(:, s);
            sensorWindows = currentSensor(idxWindows); % N x W
        
            colStart = (s - 1) * windowSize + 1;
            colEnd = s * windowSize;
            Xengine(:, colStart:colEnd) = sensorWindows;
        end

        yengine = RULCurrentEngine(windowSize:end);

        assert(size(Xengine, 1) == numWindowedSamples);
        assert(size(yengine, 1) == numWindowedSamples);

        Xcells{i} = Xengine;
        Ycells{i} = yengine;
    end

    % -- Stack results into single X and Y --
    X = vertcat(Xcells{:});
    y = vertcat(Ycells{:});
    windowedEngines = struct();
    windowedEngines.X = X;
    windowedEngines.y = y;

    fprintf('Training dataset windowed successfully.\n');
end