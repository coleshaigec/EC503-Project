function tableRow = buildTableRowFromRunReport(runReport, templateRow)
    % BUILDTABLEROWFROMRUNREPORT Constructs row of experiment summary table from run report.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  runReport struct with fields
    %      .train struct with fields
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .test
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .trainedModel struct with fields
    %          .model (struct)             - trained model
    %          .modelName (string)         - model type to be trained
    %          .taskType  (string)         - 'classification' or 'regression'
    %          .hyperparameters            - hyperparameters used in training
    %      .runPlan struct with fields
    %          .runNumber (positive integer)
    %          .pcaSpec struct with fields
    %              .enabled (boolean)
    %              .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %              .varianceThreshold (double in [0,1]) -
    %              .fixedNumComponents (int > 0) - number of principal components to compute
    %
    %          .modelSpec struct with fields
    %              .modelName (string)
    %              .hyperparameterGrid (struct with model-specific fields)
    %
    %          .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %          .warningHorizon (positive integer)        - TTF threshold for classification
    %          .windowSize (positive integer)            - for dataset windowing
    %          .numFolds (positive integer)              - number of CV folds
    %
    %  templateRow struct with fields
    %      See buildTemplateSummaryTableRow for the full template-row schema.
    %      This input is a scalar struct whose fields define the fixed schema
    %      and placeholder values for a single row of the experiment summary table.
    %
    % OUTPUTS
    %  tableRow struct with fields
    %      .runNumber (double)
    %      .cmapssSubset (string)
    %      .taskType (string)
    %      .windowSize (double)
    %      .warningHorizon (double)
    %      .pcaEnabled (boolean)
    %      .pcaSelectionMode (string)
    %      .pcaVarianceThreshold (double)
    %      .modelName (string)
    %      .boostingRegressionT (double)
    %      .knnK (double)
    %      .logisticRegressionLambda (double)
    %      .logisticRegressionMaxIter (double)
    %      .logisticRegressionSolver (string)
    %      .NAIVEBAYESHYPERPARAMETERS____ - NAIVE BAYES NOT YET ARCHITECTED!
    %      .RANDOMFORESTHYPERPARAMETERS___ - RANDOM FOREST NOT YET ARCHITECTED!
    %      .ridgeRegressionLambda (double)
    %      .trainAccuracy (double)
    %      .trainF1 (double)
    %      .trainPrecision (double)
    %      .trainRecall (double)
    %      .trainAUC_ROC (double)
    %      .trainRMSE (double)
    %      .trainMAE (double)
    %      .trainR2 (double)
    %      .testAccuracy (double)
    %      .testF1 (double)
    %      .testPrecision (double)
    %      .testRecall (double)
    %      .testAUC_ROC (double)
    %      .testRMSE (double)
    %      .testMAE (double)
    %      .testR2 (double)

    % -- Build row as copy of template --
    tableRow = templateRow;

    % -- Fill in run-level metadata --
    tableRow.runNumber = runReport.runPlan.runNumber;
    tableRow.cmapssSubset = string(runReport.runPlan.cmapssSubset);
    tableRow.taskType = string(runReport.trainedModel.taskType);
    tableRow.windowSize = runReport.runPlan.windowSize;
    tableRow.modelName = string(runReport.trainedModel.modelName);
    tableRow.warningHorizon = runReport.runPlan.warningHorizon;

    % -- Fill in PCA metadata --
    if isfield(runReport.runPlan, 'pcaSpec') && ~isempty(runReport.runPlan.pcaSpec)
        if isfield(runReport.runPlan.pcaSpec, 'enabled')
            tableRow.pcaEnabled = runReport.runPlan.pcaSpec.enabled;
        end

        if isfield(runReport.runPlan.pcaSpec, 'selectionMode') && ~isempty(runReport.runPlan.pcaSpec.selectionMode)
            tableRow.pcaSelectionMode = string(runReport.runPlan.pcaSpec.selectionMode);
        end

        if isfield(runReport.runPlan.pcaSpec, 'varianceThreshold') && ~isempty(runReport.runPlan.pcaSpec.varianceThreshold)
            tableRow.pcaVarianceThreshold = runReport.runPlan.pcaSpec.varianceThreshold;
        end
    end

    % -- Fill in model-specific hyperparameters --
    if isfield(runReport, 'trainedModel') && isfield(runReport.trainedModel, 'hyperparameters') ...
            && ~isempty(runReport.trainedModel.hyperparameters)

        hyperparameters = runReport.trainedModel.hyperparameters;
        modelNameLower = lower(string(runReport.trainedModel.modelName));

        switch modelNameLower
            case "boostingregression"
                if isfield(hyperparameters, 'T') && ~isempty(hyperparameters.T)
                    tableRow.boostingRegressionT = hyperparameters.T;
                end

            case "knn"
                if isfield(hyperparameters, 'k') && ~isempty(hyperparameters.k)
                    tableRow.knnK = hyperparameters.k;
                end

            case "ridgeregression"
                if isfield(hyperparameters, 'lambda') && ~isempty(hyperparameters.lambda)
                    tableRow.ridgeRegressionLambda = hyperparameters.lambda;
                end
            case "naivebayes"
                if isfield(hyperparameters, 'varianceSmoothing') && ~isempty(hyperparameters.varianceSmoothing)
                    tableRow.naiveBayesVarianceSmoothing = hyperparameters.varianceSmoothing;
                end
            case "qda"
                if isfield(hyperparameters, 'regularizationStrength') && ~isempty(hyperparameters.regularizationStrength)
                    tableRow.qdaRegularizationStrength = hyperparameters.regularizationStrength;
                end

            otherwise
                error('buildTableRowFromRunReport:InvalidFieldValue', ...
                    'Hyperparameters have not been specified for model %s.', modelNameLower)
        end
    end

    % -- Fill in training metrics --
    if isfield(runReport, 'train') && isfield(runReport.train, 'performanceMetrics') ...
            && ~isempty(runReport.train.performanceMetrics)

        trainMetrics = runReport.train.performanceMetrics;

        if isfield(trainMetrics, 'accuracy') && ~isempty(trainMetrics.accuracy)
            tableRow.trainAccuracy = trainMetrics.accuracy;
        end
        if isfield(trainMetrics, 'F1') && ~isempty(trainMetrics.F1)
            tableRow.trainF1 = trainMetrics.F1;
        end
        if isfield(trainMetrics, 'precision') && ~isempty(trainMetrics.precision)
            tableRow.trainPrecision = trainMetrics.precision;
        end
        if isfield(trainMetrics, 'recall') && ~isempty(trainMetrics.recall)
            tableRow.trainRecall = trainMetrics.recall;
        end
        if isfield(trainMetrics, 'AUC_ROC') && ~isempty(trainMetrics.AUC_ROC)
            tableRow.trainAUC_ROC = trainMetrics.AUC_ROC;
        end
        if isfield(trainMetrics, 'RMSE') && ~isempty(trainMetrics.RMSE)
            tableRow.trainRMSE = trainMetrics.RMSE;
        end
        if isfield(trainMetrics, 'MAE') && ~isempty(trainMetrics.MAE)
            tableRow.trainMAE = trainMetrics.MAE;
        end
        if isfield(trainMetrics, 'R2') && ~isempty(trainMetrics.R2)
            tableRow.trainR2 = trainMetrics.R2;
        end
    end

    % -- Fill in test metrics --
    if isfield(runReport, 'test') && isfield(runReport.test, 'performanceMetrics') ...
            && ~isempty(runReport.test.performanceMetrics)

        testMetrics = runReport.test.performanceMetrics;

        if isfield(testMetrics, 'accuracy') && ~isempty(testMetrics.accuracy)
            tableRow.testAccuracy = testMetrics.accuracy;
        end
        if isfield(testMetrics, 'F1') && ~isempty(testMetrics.F1)
            tableRow.testF1 = testMetrics.F1;
        end
        if isfield(testMetrics, 'precision') && ~isempty(testMetrics.precision)
            tableRow.testPrecision = testMetrics.precision;
        end
        if isfield(testMetrics, 'recall') && ~isempty(testMetrics.recall)
            tableRow.testRecall = testMetrics.recall;
        end
        if isfield(testMetrics, 'AUC_ROC') && ~isempty(testMetrics.AUC_ROC)
            tableRow.testAUC_ROC = testMetrics.AUC_ROC;
        end
        if isfield(testMetrics, 'RMSE') && ~isempty(testMetrics.RMSE)
            tableRow.testRMSE = testMetrics.RMSE;
        end
        if isfield(testMetrics, 'MAE') && ~isempty(testMetrics.MAE)
            tableRow.testMAE = testMetrics.MAE;
        end
        if isfield(testMetrics, 'R2') && ~isempty(testMetrics.R2)
            tableRow.testR2 = testMetrics.R2;
        end
    end

    % NOTE TO SELF: THIS ONE IS GOING TO NEED A BIG VALIDATOR
    % WITHOUT A GOOD VALIDATOR, YOU WILL ALLOW GARBAGE INTO YOUR TABLES
end