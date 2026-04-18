function folds = buildCrossValidationFolds(cmapssSubset, windowSize, numFolds)
    % BUILDCROSSVALIDATIONFOLDS Constructs train/validation splits for each k-fold cross-validation combination.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  cleanedCMAPSSSubset struct with fields
    %      .train struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (ntrain x d double)
    %              .RUL (ntrain x 1 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .test struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (n x d double)
    %              .RULFinal (double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .name (string)
    %  
    %  windowSize (positive integer)  - size of window to be applied to dataset
    %
    %  numFolds (positive integer)
    % 
    % OUTPUTS
    %
    %

    % -- Extract indices of engines in each fold --
    foldIndices = buildEngineIndicesForCrossValidationFolds(cmapssSubset, numFolds);

    % -- Build windowed X-y matrices for each fold --
    templateRawFold = struct( ...
        'X', [], ...
        'y', [] ...
    );

    rawFolds = repmat(templateRawFold, numFolds, 1);

    for i = 1 : numFolds
        currentFoldEngineIndices = foldIndices{i};
        currentFoldEngines = cmapssSubset.train.engines(currentFoldEngineIndices);
        rawFolds(i) = windowTrainingDataset(currentFoldEngines, windowSize);
    end

    % -- Construct train-validation splits using raw folds --
    templateFinalFold = struct( ...
        'train', [], ...
        'validation', [] ...
    );
    
    folds = repmat(templateFinalFold, numFolds, 1);

    for i = 1 : numFolds
        % Split one set at a time off as validation
        validationSet = rawFolds(i);

        % Amalgamate the remainder into a single training set
        trainFoldMask = true(1, numFolds);
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