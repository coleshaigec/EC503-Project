function folds = buildCrossValidationFolds(foldIndices, cleanedCMAPSSSubset, windowSize)
    % BUILDCROSSVALIDATIONFOLDS Constructs train/validation splits for each k-fold cross-validation combination.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  foldIndices (1 x CROSS_VALIDATION_FOLDS cell) - each cell contains a
    %  row vector of engine indices assigned to one validation fold
    %
    %  cleanedCMAPSSSubset struct with fields
    %      .train struct with fields
    %          .engines (array of structs with fields)
    %              .unitNumber (double)
    %              .timestamps (maxTimestamp x 1 double)
    %              .sensorReadings FIX THIS - MISSING FROM MANY DOCSTRINGS
    %              .maxTimestamp (double)
    %              .operatingConditions (maxTimestamp x 3 double)
    %              .RUL (maxTimestamp x 3 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .test struct with fields
    %          .engines (array of structs with fields)
    %              .unitNumber (double)
    %              .timestamps (maxTimestamp x 1 double)
    %              .maxTimestamp (double)
    %              .operatingConditions (maxTimestamp x 3 double)
    %              .RUL (maxTimestamp x 3 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .name (string)
    %
    %  windowSize (scalar)  - size of window to be applied to dataset
    % 
    % OUTPUTS
    %
    %

    % -- Build windowed X-y matrices for each fold --
    templateRawFold = struct( ...
        'X', [], ...
        'y', [] ...
    );

    rawFolds = repmat(templateRawFold, CROSS_VALIDATION_FOLDS, 1);

    for i = 1 : CROSS_VALIDATION_FOLDS
        currentFoldEngineIndices = foldIndices{i};
        currentFoldEngines = cleanedCMAPSSSubset.train.engines(currentFoldEngineIndices);
        rawFolds(i) = windowTrainingDataset(currentFoldEngines, windowSize);
    end

    % -- Construct train-validation splits using raw folds --
    
    templateFinalFold = struct( ...
        'train', [], ...
        'validation', [] ...
    );
    
    folds = repmat(templateFinalFold, CROSS_VALIDATION_FOLDS, 1);

    for i = 1 : CROSS_VALIDATION_FOLDS
        % Split one set at a time off as validation
        validationSet = rawFolds(i);

        % Amalgamate the remainder into a single training set
        trainFoldMask = true(1, CROSS_VALIDATION_FOLDS);
        trainFoldMask(i) = false;
        rawTrainSet = rawFolds(trainFoldMask);
        trainSetX = vertcat(rawTrainSet.X);
        trainSety = vertcat(rawTrainSet.y);
        trainSet = struct( ...
            'X', trainSetX, ...
            'y', trainSety...
        );

        % Build fold struct and add to output
        folds(i) = struct( ...
            'train', trainSet, ...
            'validation', validationSet ...
        );
    end
end