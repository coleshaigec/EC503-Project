function cmapssSubset = readSubsetFromCMAPSS(cmapssDataFolderPath, subsetName)
    trainPath = fullfile(cmapssDataFolderPath, sprintf('train_%s.txt', subsetName));
    testPath = fullfile(cmapssDataFolderPath, sprintf('test_%s.txt', subsetName));
    rulPath = fullfile(cmapssDataFolderPath, sprintf('RUL_%s.txt', subsetName));
    XtrainRaw = readmatrix(trainPath, 'Delimiter', ' ');
    XtestRaw = readmatrix(testPath, 'Delimiter', ' ');
    yTestRaw = readmatrix(rulPath, 'Delimiter', ' ');

    trainEngineIDs = unique(XtrainRaw(:,1));
    testEngineIDs = unique(XtestRaw(:,1));

    % Decompose at engine level
    numTrainEngines = numel(trainEngineIDs);
    numTestEngines = numel(testEngineIDs);
    cmapssSubset = struct();
    cmapssSubset.train = struct();
    cmapssSubset.test = struct();
    cmapssSubset.train.engines = struct();
    cmapssSubset.train.numEngines = numTrainEngines;
    cmapssSubset.test.engines = struct();
    cmapssSubset.test.numEngines = numTestEngines;
    cmapssSubset.name = subsetName;
    cmapssSubset.train.numRecords = size(XtrainRaw, 1);
    cmapssSubset.test.numRecords = size(XtestRaw, 1);

    % Build template structs to preallocate struct arrays
    templateTrainEngineStruct = buildTemplateTrainEngineStruct();
    templateTestEngineStruct = buildTemplateTestEngineStruct();

    cmapssSubset.train.engines = repmat(templateTrainEngineStruct, 1, numTrainEngines);
    cmapssSubset.test.engines = repmat(templateTestEngineStruct, 1, numTestEngines);

    % Extract training data at engine level
    for i = 1 : numTrainEngines
        % Obtain features and split off metadata
        unitNumber = trainEngineIDs(i);
        idxTrainSelectedEngine = (XtrainRaw(:,1) == unitNumber);
        trainingDataSelectedEngine = XtrainRaw(idxTrainSelectedEngine, :);

        % Trim off engine ID
        trainingDataSelectedEngine = trainingDataSelectedEngine(:, 2:end);

        % Separate operating conditions metadata from sensor readings
        timestampsSelectedEngine = trainingDataSelectedEngine(:, 1);
        operatingConditionsSelectedEngine = trainingDataSelectedEngine(:, 2:4);
        sensorReadingsSelectedEngine = trainingDataSelectedEngine(:, 5:end);

        % Compute training RUL at each timestamp
        finalTimestamp = max(timestampsSelectedEngine);
        trainRULSelectedEngine = finalTimestamp - timestampsSelectedEngine;

        % Populate engine info struct
        trainEngineInfo = templateTrainEngineStruct;
        trainEngineInfo.unitNumber = unitNumber;
        trainEngineInfo.timestamps = timestampsSelectedEngine;
        trainEngineInfo.maxTimestamp = max(timestampsSelectedEngine);
        trainEngineInfo.operatingConditions = operatingConditionsSelectedEngine;
        trainEngineInfo.sensorReadings = sensorReadingsSelectedEngine;
        trainEngineInfo.RUL = trainRULSelectedEngine;

        % Assign engine info struct to appropriate location in train struct
        cmapssSubset.train.engines(i) = trainEngineInfo;
    end

    % Extract test data at engine level
    for i = 1 : numTestEngines
        % Obtain features and split off metadata
        unitNumber = testEngineIDs(i);
        idxTestSelectedEngine = (XtestRaw(:,1) == unitNumber);
        testDataSelectedEngine = XtestRaw(idxTestSelectedEngine, :);

        % Trim off engine ID
        testDataSelectedEngine = testDataSelectedEngine(:, 2:end);

        % Separate operating conditions metadata from sensor readings
        timestampsSelectedEngine = testDataSelectedEngine(:, 1);
        operatingConditionsSelectedEngine = testDataSelectedEngine(:, 2:4);
        sensorReadingsSelectedEngine = testDataSelectedEngine(:, 5:end);

        % Populate engine info struct
        testEngineInfo = templateTestEngineStruct;
        testEngineInfo.unitNumber = unitNumber;
        testEngineInfo.timestamps = timestampsSelectedEngine;
        testEngineInfo.maxTimestamp = max(timestampsSelectedEngine);
        testEngineInfo.operatingConditions = operatingConditionsSelectedEngine;
        testEngineInfo.sensorReadings = sensorReadingsSelectedEngine;
        testEngineInfo.RULFinal = yTestRaw(i);
        
        % Assign engine info struct to appropriate location in test struct
        cmapssSubset.test.engines(i) = testEngineInfo;
    end
end