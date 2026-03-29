function windowedDataset = buildWindowedDataset(cmapssData, windowSize)
    %BUILDWINDOWEDDATASET Applies windowing to construct train and test
    %samples from CMAPSS data for use by downstream operations.

    % Input validation
    WINDOW_SIZE_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer', '>=', 1};
    validateattributes(windowSize, {'numeric'}, WINDOW_SIZE_ATTRIBUTES, mfilename, 'windowSize');

    cmapssSubsets = fieldnames(cmapssData);
    windowedDataset = struct();
    

    % Window each CMAPSS subset individually
    for i = 1 : numel(cmapssSubsets)
        currentSubsetName = cmapssSubsets{i};
        windowedDataset.(currentSubsetName) = struct();
        currentSubset = cmapssData.(currentSubsetName);

        [Xtrain, ytrain] = windowTrainingDataset(currentSubset.train, windowSize);
        

        % Window training data for current subset
        % trainSensorReadings = vertcat(currentSubset.train.engines);

        

        % trainSensorReadings      = vertcat(currentSubset.train.engines.sensorReadings);
        % trainOperatingConditions = vertcat(currentSubset.train.engines.operatingConditions);
        % trainRUL                 = vertcat(currentSubset.train.engines.RUL);


        testSensorReadings = vertcat(currentSubset.test.engines.sensorReadings);


    end

end