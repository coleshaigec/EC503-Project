function bestHyperparameters = chooseBestHyperparameters(tuningResults)
    % CHOOSEBESTHYPERPARAMETERS Chooses the best-performing hyperparameter
    % values (on average) from a k-fold cross-validation run.
    %
    % INPUTS
    %  tuningResults (1 x CROSS_VALIDATION_FOLDS struct array) with fields:
    %      .modelName
    %      .taskType
    %      .bestModel
    %      .bestHyperparameters
    %      .bestRunScore
    %      .allRunRecords (struct array) with fields:
    %          .hyperparameterValues
    %          .runScore
    %      .searchGrid
    %      .numRuns
    %
    % OUTPUTS
    %  bestHyperparameters (struct with model-specific fields)

    %  -- Number of folds and hyperparameter configurations -- 
    numFolds = numel(tuningResults);
    numRunsPerFold = tuningResults(1).numRuns;

    % -- Preallocate aggregate runScores matrix --
    runScores = zeros(numRunsPerFold, numFolds);

    % -- Populate runScores matrix --
    for foldIdx = 1:numFolds
        % Extract run scores for this fold
        runScores(:, foldIdx) = vertcat(tuningResults(foldIdx).allRunRecords.runScore);
    end

    % -- Compute mean performance across folds --
    meanScores = mean(runScores, 2);

    % -- Select best hyperparameter configuration -- 
    switch lower(tuningResults.taskType)
        case 'classification'
            % Higher score is better (weighted F1/accuracy)
            [~, bestIdx] = max(meanScores);

        case 'regression'
            % Lower score is better (RMSE)
            [~, bestIdx] = min(meanScores);

        otherwise
            error('chooseBestHyperparameters:InvalidTaskType', ...
                'taskType must be either "classification" or "regression".');
    end

    % -- Retrieve the best hyperparameters using specified index --
    bestHyperparameters = ...
        tuningResults(1).allRunRecords(bestIdx).hyperparameterValues;
end