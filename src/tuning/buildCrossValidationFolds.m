function folds = buildCrossValidationFolds(cmapssSubset, windowSize, numFolds, taskType, warningHorizon)
    % BUILDCROSSVALIDATIONFOLDS Constructs windowed train/validation splits for k-fold cross-validation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  cmapssSubset struct with fields
    %      .train struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (nTrain_i x d double)
    %              .RUL (nTrain_i x 1 double)
    %          .numEngines (positive integer)
    %          .numRecords (positive integer)
    %      .test struct with fields
    %          .engines (array of structs with fields)
    %              .sensorReadings (nTest_i x d double)
    %              .RULFinal (double)
    %          .numEngines (positive integer)
    %          .numRecords (positive integer)
    %      .name (string)
    %
    %  windowSize (positive integer) - sliding window length used to transform
    %                                  engine-level trajectories into sample-level
    %                                  feature vectors
    %
    %  numFolds (positive integer) - number of cross-validation folds
    %
    %  taskType (string)           - 'classification' or 'regression'
    %
    %  warningHorizon (positive integer) - TTF threshold for classification
    %
    % OUTPUTS
    %  folds (numFolds x 1 struct) with fields
    %      .train struct with fields
    %          .X (nTrainFold x p double) - windowed training feature matrix formed
    %                                      by vertically concatenating all non-validation folds
    %          .y (nTrainFold x 1 double) - training label vector corresponding to .X
    %      .validation struct with fields
    %          .X (nValidationFold x p double) - windowed validation feature matrix for
    %                                           the held-out fold
    %          .y (nValidationFold x 1 double) - validation label vector corresponding to .X

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
        

        % If task type is classification, remap labels
        if strcmp(taskType, 'classification')
            trainSety = remapLabels(trainSety, warningHorizon);
            validationSet.y = remapLabels(validationSet.y, warningHorizon);
        end

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