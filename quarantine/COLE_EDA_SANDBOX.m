cmapssSubsets = {'FD001','FD002','FD003','FD004'};

for i = 1:numel(cmapssSubsets)

    subset = cmapssData.(cmapssSubsets{i});

    trainEngines = subset.train.engines;
    testEngines  = subset.test.engines;

    %% --- TRAIN ---
    trainLives = arrayfun(@(e) e.maxTimestamp, trainEngines);

    % mean RUL over ALL timesteps
    allTrainRUL = vertcat(trainEngines.RUL);
    meanTrainRUL = mean(allTrainRUL);

    %% --- TEST ---
    testObservedLife = arrayfun(@(e) e.maxTimestamp, testEngines);
    testRULFinal     = arrayfun(@(e) e.RULFinal, testEngines);

    % reconstruct true life
    testTrueLife = testObservedLife + testRULFinal;

    %% --- PRINT ---
    fprintf('\n========================================\n');
    fprintf('Subset %s\n', cmapssSubsets{i});
    fprintf('========================================\n');

    fprintf('\nTRAIN\n');
    fprintf('Mean engine life: %.2f\n', mean(trainLives));
    fprintf('Std engine life:  %.2f\n', std(trainLives));

    fprintf('Mean RUL (all timesteps): %.2f\n', meanTrainRUL);

    fprintf('\nTEST\n');
    fprintf('Mean observed life: %.2f\n', mean(testObservedLife));
    fprintf('Mean RUL at cutoff: %.2f\n', mean(testRULFinal));

    fprintf('Mean TRUE life (reconstructed): %.2f\n', mean(testTrueLife));
    fprintf('Std TRUE life: %.2f\n', std(testTrueLife));

    %% --- CRITICAL RATIO ---
    truncationRatio = mean(testObservedLife) / mean(testTrueLife);

    fprintf('\nTruncation ratio (observed / true): %.3f\n', truncationRatio);

end