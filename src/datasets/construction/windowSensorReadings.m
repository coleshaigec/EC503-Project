function Xwindows = windowSensorReadings(sensorReadings, windowSize)
    % WINDOWSENSORREADINGS Builds all contiguous rectangular windows for one engine.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  sensorReadings (nReadings x nSensors double)
    %  windowSize     (positive integer)
    %
    % OUTPUTS
    %  Xwindows       (nWindows x (windowSize * nSensors) double)

    [numReadings, numSensors] = size(sensorReadings);

    numWindows = numReadings - windowSize + 1;
    assert(numWindows > 0, ...
        'windowSensorReadings:InvalidWindowSize', ...
        'windowSize exceeds number of readings.');

    idxWindows = (1:windowSize) + (0:(numWindows - 1)).';

    Xwindows = zeros(numWindows, windowSize * numSensors);

    for s = 1:numSensors
        currentSensor = sensorReadings(:, s);
        sensorWindows = currentSensor(idxWindows);

        colStart = (s - 1) * windowSize + 1;
        colEnd = s * windowSize;
        Xwindows(:, colStart:colEnd) = sensorWindows;
    end
end