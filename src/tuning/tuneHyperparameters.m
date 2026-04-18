function tuningResult = tuneHyperparameters(trainData, validationData, modelName, searchGrid, taskType)
    % TUNEHYPERPARAMETERS Runs grid search to tune hyperparameters for specified model
    %
    % INPUTS
    %  trainData struct with fields
    %      .X (nTrain x d double)           - training features
    %      .y (nTrain x 1 double)           - training labels
    %  
    %  validationData struct with fields  
    %      .X (nValidation x d double)      - validation features
    %      .y (nValidation x 1 double)      - validation labels
    %    
    %  modelName (string)  
    %   
    %  taskType (string)                    - 'classification' or 'regression'
    %  
    %  searchGrid (struct)                  - candidate hyperparameter values, to be unpacked for grid search
    %
    % OUTPUTS
    %  tuningResult struct with fields
    %      .modelName
    %      .taskType
    %      .bestModel (struct)              - trained model with best performance in tuning
    %      .bestHyperparameters (struct)    - best hyperparameter values
    %      .bestRunScore (double)           - RMSE for regression, weighted average of F1 and accuracy for classification
    %      .allRunRecords (struct array)    - full record of all candidate runs, including candidate hyperparameters and scalar run score
    %          runRecord struct with fields
    %              .hyperparameterValues (struct)
    %              .runScore
    %      .searchGrid (struct)
    %      .numRuns (double)
    %
    % NOTES
    %  - runScore is a 75/25 weighted average of macro F1 and accuracy for
    %  classification, so the best classifier is the one with the highest
    %  runScore. 
    %  - runScore is RMSE for regression, so the best regressor is the one
    %  with the lowest runScore.


    % Validate inputs
    % TBD - may be taken care of upstream

    % Unpack hyperparameter grid
    hyperparameterIterable = unpackHyperparameterSearchGrid(searchGrid, modelName);
    numTuningRuns = hyperparameterIterable.numCombinations;

    % Initialize and preallocate record tracker
    if strcmp(taskType, "classification")
            bestRunScore = -Inf; % aim to maximize score      
        elseif strcmp(taskType, "regression")
            bestRunScore = Inf;  % aim to minimize score
        else
            error('tuneHyperparameters:InvalidFieldValue', ...
            'taskType must be either ''classification'' or ''regression''.');
    end

    bestHyperparameters = hyperparameterIterable.candidateHyperparameterSets(1);
    bestModel = struct();

    templateRunRecord = struct( ...
        'hyperparameterValues', [], ...
        'runScore', [] ...
    );

    allRunRecords = repmat(templateRunRecord, numTuningRuns, 1);

    % Loop over hyperparameter grids, train model, and evaluate performance
    for i = 1 : numTuningRuns
        isCurrentRunBest = false;

        % Extract current hyperparameters
        currentHyperparameters = hyperparameterIterable.candidateHyperparameterSets(i);
        modelSpec = struct( ...
            'modelName', modelName, ...
            'hyperparameters', currentHyperparameters ...
        );

        % Train model with current hyperparameters
        trainedModel = trainModel(trainData, modelSpec);

        % Compute run scores and check against current best score
        if strcmp(taskType, "classification")
            runScore = computeClassificationTuningScore(validationData, trainedModel);
            isCurrentRunBest = runScore > bestRunScore; % runScore to be maximized for classification
        elseif strcmp(taskType, "regression")
            runScore = computeRegressionTuningScore(validationData, trainedModel);
            isCurrentRunBest = runScore < bestRunScore; % runScore to be minimized for regression
        end

        % If current run is best, update accordingly
        if isCurrentRunBest
            bestRunScore = runScore;
            bestHyperparameters = currentHyperparameters;
            bestModel = trainedModel;
        end

        % Log run performance
        allRunRecords(i) = templateRunRecord;
        allRunRecords(i).hyperparameterValues = currentHyperparameters;
        allRunRecords(i).runScore = runScore;
    end

    % Populate output struct
    tuningResult = struct();
    tuningResult.modelName = modelName;
    tuningResult.taskType = taskType;
    tuningResult.bestModel = bestModel;
    tuningResult.bestHyperparameters = bestHyperparameters;
    tuningResult.bestRunScore = bestRunScore;
    tuningResult.allRunRecords = allRunRecords;
    tuningResult.searchGrid = searchGrid;
    tuningResult.numRuns = numTuningRuns;
end