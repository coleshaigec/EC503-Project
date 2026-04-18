function cmapssData = prepareCMAPSSDataForPipeline(cmapssProcessingConfig)
    %PREPARECMAPSSDATAFORPIPELINE Reads in CMAPSS data, windows it, and
    %returns data in tabular form usable by preprocessing transforms and
    %models

    % NOTE TO SELF: CONFIG MUST CONTAIN K and windowSize

    % Read raw data from file
    cmapssDataRaw = readCMAPSSData();
    
    % Trim off unhelpful sensors
    % NOTE TO SELF: REFACTOR THIS WHEN WE SWITCH TO TUNABLE K
    % HYPERPARAMETER FOR NUM SENSORS TO KEEP
    cmapssDataTrimmed = trimSensorReadings(cmapssDataRaw);

    % Apply windowing
    cmapssData = buildWindowedDataset(cmapssDataTrimmed, cmapssProcessingConfig.windowSize);
end