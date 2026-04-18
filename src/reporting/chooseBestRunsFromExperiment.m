function bestRuns = chooseBestRunsFromExperiment(summaryTable, numRunsToSelect)
    % CHOOSEBESTRUNSFROMEXPERIMENT Selects top-performing classification and
    % regression runs from experiment summary table.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  summaryTable table
    %      Experiment summary table. Expected to contain taskType plus the
    %      task-appropriate test metrics used for ranking.
    %
    %  numRunsToSelect (positive integer)
    %      Number of top runs to return for each task type.
    %
    % OUTPUTS
    %  bestRuns struct with fields
    %      .classification table
    %          Top classification runs ranked by
    %          0.75 * testF1 + 0.25 * testAccuracy, descending.
    %          Empty table if no valid classification runs exist.
    %
    %      .regression table
    %          Top regression runs ranked by testRMSE, ascending.
    %          Empty table if no valid regression runs exist.

    % -- Validate scalar input --
    if ~isscalar(numRunsToSelect) || ~isnumeric(numRunsToSelect) || ...
            isnan(numRunsToSelect) || isinf(numRunsToSelect) || ...
            numRunsToSelect <= 0 || mod(numRunsToSelect, 1) ~= 0
        error('chooseBestRunsFromExperiment:InvalidNumRunsToSelect', ...
            'numRunsToSelect must be a positive integer scalar.');
    end

    % -- Split summary table by task type --
    classificationRuns = summaryTable(summaryTable.taskType == "classification", :);
    regressionRuns = summaryTable(summaryTable.taskType == "regression", :);

    % -- Initialize output struct --
    bestRuns = struct();
    bestRuns.classification = classificationRuns([],:);
    bestRuns.regression = regressionRuns([],:);

    % -- Classification: select runs with highest 0.75 * testF1 + 0.25 * testAccuracy --
    if height(classificationRuns) > 0
        validClassificationRows = ~isnan(classificationRuns.testF1) & ...
                                  ~isnan(classificationRuns.testAccuracy);

        classificationRuns = classificationRuns(validClassificationRows, :);

        if height(classificationRuns) > 0
            classificationRuns.classificationSelectionScore = ...
                0.75 .* classificationRuns.testF1 + ...
                0.25 .* classificationRuns.testAccuracy;

            classificationRuns = sortrows( ...
                classificationRuns, ...
                'classificationSelectionScore', ...
                'descend');

            numClassificationRuns = min(numRunsToSelect, height(classificationRuns));
            bestRuns.classification = classificationRuns(1:numClassificationRuns, :);
        end
    end

    % -- Regression: select runs with best test RMSE -- 
    if height(regressionRuns) > 0
        validRegressionRows = ~isnan(regressionRuns.testRMSE);
        regressionRuns = regressionRuns(validRegressionRows, :);

        if height(regressionRuns) > 0
            regressionRuns = sortrows(regressionRuns, 'testRMSE', 'ascend');

            numRegressionRuns = min(numRunsToSelect, height(regressionRuns));
            bestRuns.regression = regressionRuns(1:numRegressionRuns, :);
        end
    end
end