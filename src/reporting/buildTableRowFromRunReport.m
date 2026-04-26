function tableRow = buildTableRowFromRunReport(runReport, templateRow)
    % BUILDTABLEROWFROMRUNREPORT Constructs row of experiment summary table from run report.

    % -- Build row as copy of template --
    tableRow = templateRow;

    % -- Fill in run-level metadata --
    tableRow.runNumber = runReport.runPlan.runNumber;
    tableRow.cmapssSubset = string(runReport.runPlan.cmapssSubset);
    tableRow.taskType = string(runReport.trainedModel.taskType);
    tableRow.windowSize = runReport.runPlan.windowSize;
    tableRow.warningHorizon = runReport.runPlan.warningHorizon;
    tableRow.modelName = string(runReport.trainedModel.modelName);

    % -- Fill in PCA metadata --
    if isfield(runReport.runPlan, 'pcaSpec') && ~isempty(runReport.runPlan.pcaSpec)
        if isfield(runReport.runPlan.pcaSpec, 'enabled')
            tableRow.pcaEnabled = runReport.runPlan.pcaSpec.enabled;
        end

        if isfield(runReport.runPlan.pcaSpec, 'selectionMode') ...
                && ~isempty(runReport.runPlan.pcaSpec.selectionMode)
            tableRow.pcaSelectionMode = string(runReport.runPlan.pcaSpec.selectionMode);
        end

        if isfield(runReport.runPlan.pcaSpec, 'varianceThreshold') ...
                && ~isempty(runReport.runPlan.pcaSpec.varianceThreshold)
            tableRow.pcaVarianceThreshold = runReport.runPlan.pcaSpec.varianceThreshold;
        end
    end

    % -- Fill in model-specific hyperparameters --
    if isfield(runReport, 'trainedModel') ...
            && isfield(runReport.trainedModel, 'hyperparameters') ...
            && ~isempty(runReport.trainedModel.hyperparameters)

        hyperparameters = runReport.trainedModel.hyperparameters;
        modelNameLower = lower(string(runReport.trainedModel.modelName));

        switch modelNameLower
            case "knn"
                if isfield(hyperparameters, 'k') && ~isempty(hyperparameters.k)
                    tableRow.hyperparameters_knnK = hyperparameters.k;
                end

            case "ridgeregression"
                if isfield(hyperparameters, 'lambda') && ~isempty(hyperparameters.lambda)
                    tableRow.hyperparameters_ridgeRegressionLambda = hyperparameters.lambda;
                end

            case "weightedridgeregression"
                if isfield(hyperparameters, 'lambda') && ~isempty(hyperparameters.lambda)
                    tableRow.hyperparameters_weightedRidgeRegressionLambda = hyperparameters.lambda;
                end
                if isfield(hyperparameters, 'eta') && ~isempty(hyperparameters.eta)
                    tableRow.hyperparameters_weightedRidgeRegressionEta = hyperparameters.eta;
                end
                if isfield(hyperparameters, 'tau') && ~isempty(hyperparameters.tau)
                    tableRow.hyperparameters_weightedRidgeRegressionTau = hyperparameters.tau;
                end

            case "naivebayes"
                if isfield(hyperparameters, 'varianceSmoothing') ...
                        && ~isempty(hyperparameters.varianceSmoothing)
                    tableRow.hyperparameters_naiveBayesVarianceSmoothing = ...
                        hyperparameters.varianceSmoothing;
                end

            case "qda"
                if isfield(hyperparameters, 'regularizationStrength') ...
                        && ~isempty(hyperparameters.regularizationStrength)
                    tableRow.hyperparameters_qdaRegularizationStrength = ...
                        hyperparameters.regularizationStrength;
                end

            case "randomforest"
                if isfield(hyperparameters, 'numTrees') && ~isempty(hyperparameters.numTrees)
                    tableRow.hyperparameters_randomForestNumTrees = hyperparameters.numTrees;
                end
                if isfield(hyperparameters, 'minLeafSize') && ~isempty(hyperparameters.minLeafSize)
                    tableRow.hyperparameters_randomForestMinLeafSize = hyperparameters.minLeafSize;
                end
                if isfield(hyperparameters, 'numPredictorsToSample') ...
                        && ~isempty(hyperparameters.numPredictorsToSample)
                    tableRow.hyperparameters_randomForestNumPredictorsToSample = ...
                        hyperparameters.numPredictorsToSample;
                end

            otherwise
                error('buildTableRowFromRunReport:InvalidFieldValue', ...
                    'Hyperparameters have not been specified for model %s.', modelNameLower);
        end
    end

    % -- Fill in training metrics --
    if isfield(runReport, 'train') ...
            && isfield(runReport.train, 'performanceMetrics') ...
            && ~isempty(runReport.train.performanceMetrics)

        trainMetrics = runReport.train.performanceMetrics;

        if isfield(trainMetrics, 'accuracy') && ~isempty(trainMetrics.accuracy)
            tableRow.mlMetrics_trainAccuracy = trainMetrics.accuracy;
        end
        if isfield(trainMetrics, 'F1') && ~isempty(trainMetrics.F1)
            tableRow.mlMetrics_trainF1 = trainMetrics.F1;
        end
        if isfield(trainMetrics, 'precision') && ~isempty(trainMetrics.precision)
            tableRow.mlMetrics_trainPrecision = trainMetrics.precision;
        end
        if isfield(trainMetrics, 'recall') && ~isempty(trainMetrics.recall)
            tableRow.mlMetrics_trainRecall = trainMetrics.recall;
        end
        if isfield(trainMetrics, 'specificity') && ~isempty(trainMetrics.specificity)
            tableRow.mlMetrics_trainSpecificity = trainMetrics.specificity;
        end
        if isfield(trainMetrics, 'balancedAccuracy') ...
                && ~isempty(trainMetrics.balancedAccuracy)
            tableRow.mlMetrics_trainBalancedAccuracy = trainMetrics.balancedAccuracy;
        end
        if isfield(trainMetrics, 'RMSE') && ~isempty(trainMetrics.RMSE)
            tableRow.mlMetrics_trainRMSE = trainMetrics.RMSE;
        end
        if isfield(trainMetrics, 'MAE') && ~isempty(trainMetrics.MAE)
            tableRow.mlMetrics_trainMAE = trainMetrics.MAE;
        end
        if isfield(trainMetrics, 'MedAE') && ~isempty(trainMetrics.MedAE)
            tableRow.mlMetrics_trainMedAE = trainMetrics.MedAE;
        end
        if isfield(trainMetrics, 'R2') && ~isempty(trainMetrics.R2)
            tableRow.mlMetrics_trainR2 = trainMetrics.R2;
        end
        if isfield(trainMetrics, 'bias') && ~isempty(trainMetrics.bias)
            tableRow.mlMetrics_trainBias = trainMetrics.bias;
        end
    end

    % -- Fill in test metrics --
    if isfield(runReport, 'test') ...
            && isfield(runReport.test, 'performanceMetrics') ...
            && ~isempty(runReport.test.performanceMetrics)

        testMetrics = runReport.test.performanceMetrics;

        if isfield(testMetrics, 'accuracy') && ~isempty(testMetrics.accuracy)
            tableRow.mlMetrics_testAccuracy = testMetrics.accuracy;
        end
        if isfield(testMetrics, 'F1') && ~isempty(testMetrics.F1)
            tableRow.mlMetrics_testF1 = testMetrics.F1;
        end
        if isfield(testMetrics, 'precision') && ~isempty(testMetrics.precision)
            tableRow.mlMetrics_testPrecision = testMetrics.precision;
        end
        if isfield(testMetrics, 'recall') && ~isempty(testMetrics.recall)
            tableRow.mlMetrics_testRecall = testMetrics.recall;
        end
        if isfield(testMetrics, 'specificity') && ~isempty(testMetrics.specificity)
            tableRow.mlMetrics_testSpecificity = testMetrics.specificity;
        end
        if isfield(testMetrics, 'balancedAccuracy') ...
                && ~isempty(testMetrics.balancedAccuracy)
            tableRow.mlMetrics_testBalancedAccuracy = testMetrics.balancedAccuracy;
        end
        if isfield(testMetrics, 'RMSE') && ~isempty(testMetrics.RMSE)
            tableRow.mlMetrics_testRMSE = testMetrics.RMSE;
        end
        if isfield(testMetrics, 'MAE') && ~isempty(testMetrics.MAE)
            tableRow.mlMetrics_testMAE = testMetrics.MAE;
        end
        if isfield(testMetrics, 'MedAE') && ~isempty(testMetrics.MedAE)
            tableRow.mlMetrics_testMedAE = testMetrics.MedAE;
        end
        if isfield(testMetrics, 'R2') && ~isempty(testMetrics.R2)
            tableRow.mlMetrics_testR2 = testMetrics.R2;
        end
        if isfield(testMetrics, 'bias') && ~isempty(testMetrics.bias)
            tableRow.mlMetrics_testBias = testMetrics.bias;
        end
    end

    % -- Fill in error diagnostics --
    if isfield(runReport, 'errorDiagnosticsResult') ...
            && ~isempty(runReport.errorDiagnosticsResult)

        errorDiagnostics = runReport.errorDiagnosticsResult;
        taskType = lower(string(runReport.trainedModel.taskType));

        switch taskType
            case "classification"
                if isfield(errorDiagnostics, 'falsePositives') ...
                        && ~isempty(errorDiagnostics.falsePositives)

                    falsePositives = errorDiagnostics.falsePositives;

                    tableRow.errorDiagnostics_classificationNumFalsePositives = ...
                        falsePositives.numFalsePositives;
                    tableRow.errorDiagnostics_classificationMeanFalsePositiveRUL = ...
                        falsePositives.meanFalsePositiveRUL;
                    tableRow.errorDiagnostics_classificationMinFalsePositiveRUL = ...
                        falsePositives.minFalsePositiveRUL;
                    tableRow.errorDiagnostics_classificationMaxFalsePositiveRUL = ...
                        falsePositives.maxFalsePositiveRUL;
                end

                if isfield(errorDiagnostics, 'truePositives') ...
                        && ~isempty(errorDiagnostics.truePositives)

                    truePositives = errorDiagnostics.truePositives;

                    tableRow.errorDiagnostics_classificationNumTruePositives = ...
                        truePositives.numTruePositives;
                    tableRow.errorDiagnostics_classificationMeanTruePositiveRUL = ...
                        truePositives.meanTruePositiveRUL;
                    tableRow.errorDiagnostics_classificationMinTruePositiveRUL = ...
                        truePositives.minTruePositiveRUL;
                    tableRow.errorDiagnostics_classificationMaxTruePositiveRUL = ...
                        truePositives.maxTruePositiveRUL;
                end

                if isfield(errorDiagnostics, 'falseNegatives') ...
                        && ~isempty(errorDiagnostics.falseNegatives)

                    falseNegatives = errorDiagnostics.falseNegatives;

                    tableRow.errorDiagnostics_classificationNumFalseNegatives = ...
                        falseNegatives.numFalseNegatives;
                    tableRow.errorDiagnostics_classificationMeanFalseNegativeRUL = ...
                        falseNegatives.meanFalseNegativeRUL;
                    tableRow.errorDiagnostics_classificationMinFalseNegativeRUL = ...
                        falseNegatives.minFalseNegativeRUL;
                    tableRow.errorDiagnostics_classificationMaxFalseNegativeRUL = ...
                        falseNegatives.maxFalseNegativeRUL;
                end

            case "regression"
                tableRow.errorDiagnostics_regressionNumDangerousMisses = ...
                    errorDiagnostics.numDangerousMisses;
                tableRow.errorDiagnostics_regressionMeanDangerousMissRUL = ...
                    errorDiagnostics.meanDangerousMissRUL;
                tableRow.errorDiagnostics_regressionMinDangerousMissRUL = ...
                    errorDiagnostics.minDangerousMissRUL;
                tableRow.errorDiagnostics_regressionMaxDangerousMissRUL = ...
                    errorDiagnostics.maxDangerousMissRUL;
                tableRow.errorDiagnostics_regressionSumDangerousMissRULs = ...
                    errorDiagnostics.sumDangerousMissRULs;

                tableRow.errorDiagnostics_regressionNumPrematureWarnings = ...
                    errorDiagnostics.numPrematureWarnings;
                tableRow.errorDiagnostics_regressionMeanPrematureWarningRUL = ...
                    errorDiagnostics.meanPrematureWarningRUL;
                tableRow.errorDiagnostics_regressionMinPrematureWarningRUL = ...
                    errorDiagnostics.minPrematureWarningRUL;
                tableRow.errorDiagnostics_regressionMaxPrematureWarningRUL = ...
                    errorDiagnostics.maxPrematureWarningRUL;
                tableRow.errorDiagnostics_regressionSumPrematureWarningRULs = ...
                    errorDiagnostics.sumPrematureWarningRULs;

            otherwise
                error('buildTableRowFromRunReport:InvalidTaskType', ...
                    'Unsupported task type: %s.', taskType);
        end
    end

    % -- Fill in policy analysis result --
    if isfield(runReport, 'policyAnalysisResult') ...
            && ~isempty(runReport.policyAnalysisResult)

        policyAnalysisResult = runReport.policyAnalysisResult;

        if isfield(policyAnalysisResult, 'costModel') ...
                && ~isempty(policyAnalysisResult.costModel)

            costModel = policyAnalysisResult.costModel;

            if isfield(costModel, 'name') && ~isempty(costModel.name)
                tableRow.costModel_name = string(costModel.name);
            end
            if isfield(costModel, 'directMaintenanceCost') ...
                    && ~isempty(costModel.directMaintenanceCost)
                tableRow.costModel_directMaintenanceCost = costModel.directMaintenanceCost;
            end
            if isfield(costModel, 'failureCost') && ~isempty(costModel.failureCost)
                tableRow.costModel_failureCost = costModel.failureCost;
            end
            if isfield(costModel, 'alphaRUL') && ~isempty(costModel.alphaRUL)
                tableRow.costModel_alphaRUL = costModel.alphaRUL;
            end
        end

        if isfield(policyAnalysisResult, 'policyMetrics') ...
                && ~isempty(policyAnalysisResult.policyMetrics)

            policyMetrics = policyAnalysisResult.policyMetrics;

            if isfield(policyMetrics, 'totalNumEngines') ...
                    && ~isempty(policyMetrics.totalNumEngines)
                tableRow.policyMetrics_totalNumEngines = policyMetrics.totalNumEngines;
            end
            if isfield(policyMetrics, 'totalMaintenanceJobs') ...
                    && ~isempty(policyMetrics.totalMaintenanceJobs)
                tableRow.policyMetrics_totalMaintenanceJobs = ...
                    policyMetrics.totalMaintenanceJobs;
            end
            if isfield(policyMetrics, 'numPrematureMaintenanceJobs') ...
                    && ~isempty(policyMetrics.numPrematureMaintenanceJobs)
                tableRow.policyMetrics_numPrematureMaintenanceJobs = ...
                    policyMetrics.numPrematureMaintenanceJobs;
            end
            if isfield(policyMetrics, 'numTimelyMaintenanceJobs') ...
                    && ~isempty(policyMetrics.numTimelyMaintenanceJobs)
                tableRow.policyMetrics_numTimelyMaintenanceJobs = ...
                    policyMetrics.numTimelyMaintenanceJobs;
            end
            if isfield(policyMetrics, 'numMissedFailures') ...
                    && ~isempty(policyMetrics.numMissedFailures)
                tableRow.policyMetrics_numMissedFailures = policyMetrics.numMissedFailures;
            end
            if isfield(policyMetrics, 'numCorrectDeferments') ...
                    && ~isempty(policyMetrics.numCorrectDeferments)
                tableRow.policyMetrics_numCorrectDeferments = ...
                    policyMetrics.numCorrectDeferments;
            end
            if isfield(policyMetrics, 'lostRULFromPrematureMaintenance') ...
                    && ~isempty(policyMetrics.lostRULFromPrematureMaintenance)
                tableRow.policyMetrics_lostRULFromPrematureMaintenance = ...
                    policyMetrics.lostRULFromPrematureMaintenance;
            end
        end

        if isfield(policyAnalysisResult, 'policyCosts') ...
                && ~isempty(policyAnalysisResult.policyCosts)

            policyCosts = policyAnalysisResult.policyCosts;

            if isfield(policyCosts, 'totalDirectMaintenanceCost') ...
                    && ~isempty(policyCosts.totalDirectMaintenanceCost)
                tableRow.policyCosts_totalDirectMaintenanceCost = ...
                    policyCosts.totalDirectMaintenanceCost;
            end
            if isfield(policyCosts, 'totalFailureCost') ...
                    && ~isempty(policyCosts.totalFailureCost)
                tableRow.policyCosts_totalFailureCost = policyCosts.totalFailureCost;
            end
            if isfield(policyCosts, 'totalPrematureMaintenanceCost') ...
                    && ~isempty(policyCosts.totalPrematureMaintenanceCost)
                tableRow.policyCosts_totalPrematureMaintenanceCost = ...
                    policyCosts.totalPrematureMaintenanceCost;
            end
            if isfield(policyCosts, 'totalPolicyCost') ...
                    && ~isempty(policyCosts.totalPolicyCost)
                tableRow.policyCosts_totalPolicyCost = policyCosts.totalPolicyCost;
            end
        end
    end
end