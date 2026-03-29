function [XTest, yTest] = windowTestDataset(testSubset, windowSize)
    % WINDOWTESTDATASET Applies rectangular history windowing to the
    % test data in a CMAPSS subset.

    % One sample from each engine -- end of life
    numEngines = numel(testSubset.engines);
    Xcells = cell(numEngines, 1);
    yTest = vertcat(testSubset.engines.RULFinal);

    for i = 1:numEngines
        currentEngine = testSubset.engines(i);
        sensorReadingsCurrentEngine = currentEngine.sensorReadings;
        operatingConditionsCurrentEngine = currentEngine.operatingConditions(end, :);
        
        numSensorReadings = size(sensorReadingsCurrentEngine, 1);
        assert(windowSize <= numSensorReadings, 'Window size exceeds engine trajectory length.');
        stackedWindowMatrix = sensorReadingsCurrentEngine(numSensorReadings - windowSize + 1 : end, :);
        windowedSensorReadings = stackedWindowMatrix(:).';
        Xcells{i} = [operatingConditionsCurrentEngine, windowedSensorReadings];
    end
    XTest = vertcat(Xcells{:});
end