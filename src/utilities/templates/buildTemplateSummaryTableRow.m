function templateRow = buildTemplateSummaryTableRow()
    % BUILDTEMPLATESUMMARYTABLEROW Builds scalar struct containing template row for experiment summary table.
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % OUTPUTS
    %  templateRow struct with fields
    %      .runNumber (double)     
    %      .cmapssSubset (string)
    %      .taskType  (string)   
    %      .windowSize (double)
    %      .warningHorizon (double)
    %      .pcaEnabled (boolean)
    %      .pcaSelectionMode (string)
    %      .pcaVarianceThreshold (double)
    %      .modelName (string)
    %      .hyperparameters_knnK (double)
    %      .hyperparameters_qdaRegularizationStrength (double)
    %      .hyperparameters_naiveBayesVarianceSmoothing (double)
    %      .hyperparameters_randomForestNumTrees (double)
    %      .hyperparameters_randomForestMinLeafSize (double)
    %      .hyperparameters_randomForestNumPredictorsToSample (double)
    %      .hyperparameters_ridgeRegressionLambda (double)
    %      .hyperparameters_weightedRidgeRegressionLambda (double)
    %      .hyperparameters_weightedRidgeRegressionEta (double)
    %      .hyperparameters_weightedRidgeRegressionTau (double)
    %      .mlMetrics_trainAccuracy (double)
    %      .mlMetrics_trainF1 (double)
    %      .mlMetrics_trainPrecision (double)
    %      .mlMetrics_trainRecall (double)
    %      .mlMetrics_trainSpecificity (double)
    %      .mlMetrics_trainBalancedAccuracy (double)
    %      .mlMetrics_trainRMSE (double)
    %      .mlMetrics_trainMAE (double)
    %      .mlMetrics_trainMedAE (double)
    %      .mlMetrics_trainR2 (double)
    %      .mlMetrics_trainBias (double)
    %      .mlMetrics_testAccuracy (double)
    %      .mlMetrics_testF1 (double)
    %      .mlMetrics_testPrecision (double)
    %      .mlMetrics_testRecall (double)
    %      .mlMetrics_testSpecificity (double)
    %      .mlMetrics_testBalancedAccuracy (double)
    %      .mlMetrics_testRMSE (double)
    %      .mlMetrics_testMAE (double)
    %      .mlMetrics_testMedAE (double)
    %      .mlMetrics_testR2 (double)
    %      .mlMetrics_testBias (double)
    %      .errorDiagnostics_classificationNumFalsePositives (nonnegative integer)
    %      .errorDiagnostics_classificationMeanFalsePositiveRUL (double)
    %      .errorDiagnostics_classificationMinFalsePositiveRUL (double)
    %      .errorDiagnostics_classificationMaxFalsePositiveRUL (double)
    %      .errorDiagnostics_classificationNumTruePositives (nonnegative integer)
    %      .errorDiagnostics_classificationMeanTruePositiveRUL (double)
    %      .errorDiagnostics_classificationMinTruePositiveRUL (double)
    %      .errorDiagnostics_classificationMaxTruePositiveRUL (double)
    %      .errorDiagnostics_classificationNumFalseNegatives (nonnegative integer)
    %      .errorDiagnostics_classificationMeanFalseNegativeRUL (double)
    %      .errorDiagnostics_classificationMinFalseNegativeRUL (double)
    %      .errorDiagnostics_classificationMaxFalseNegativeRUL (double)
    %      .errorDiagnostics_regressionNumDangerousMisses (double)

    % NEED TO FIX THIS! 
    % regressionErrorDiagnostics struct with fields
    %      .residuals (n x 1 double)                  - prediction residuals yHat - yTrue
    %      .lateErrors (numLateErrors x 1 double)     - residuals corresponding to late predictions
    %      .earlyErrors (numEarlyErrors x 1 double)   - residuals corresponding to early predictions
    %      .dangerousMissMask (n x 1 logical)         - true where yTrue <= warningHorizon and yHat > warningHorizon
    %      .prematureWarningMask (n x 1 logical)      - true where yTrue > warningHorizon and yHat <= warningHorizon
    %      .rulsForDangerousMisses (numDangerousMisses x 1 double)
    %      .rulsForPrematureWarnings (numPrematureWarnings x 1 double)
    %      .numDangerousMisses (double)
    %      .numPrematureWarnings (double)
    %      
    %      .costModel_name (positive double)
    %      .costModel_directMaintenanceCost (positive double)
    %      .costModel_failureCost (positive double)
    %      .costModel_alphaRUL (positive double)
    %      .policyMetrics_totalNumEngines (nonnegative integer)
    %      .policyMetrics_totalMaintenanceJobs (nonnegative integer)
    %      .policyMetrics_numPrematureMaintenanceJobs (nonnegative integer)
    %      .policyMetrics_numTimelyMaintenanceJobs (nonnegative integer)
    %      .policyMetrics_numMissedFailures (nonnegative integer)
    %      .policyMetrics_numCorrectDeferments (nonnegative integer)
    %      .policyMetrics_lostRULFromPrematureMaintenance (nonnegative integer)
    %      .policyCosts_totalDirectMaintenanceCost (double)
    %      .policyCosts_totalFailureCost (double)
    %      .policyCosts_totalPrematureMaintenanceCost (double)
    %      .policyCosts_totalPolicyCost (double)


    % ---------------------------------------------------------------------
    % Type-appropriate placeholders
    % ---------------------------------------------------------------------
    numericPlaceholder  = "";                % For numeric/double fields
    stringPlaceholder   = "";    % For string fields
    logicalPlaceholder  = false;              % For logical/boolean fields

    % ---------------------------------------------------------------------
    % Build template row with fixed schema
    % ---------------------------------------------------------------------
    templateRow = struct( ...
        'runNumber', numericPlaceholder, ...
        'cmapssSubset', stringPlaceholder, ...
        'taskType', stringPlaceholder, ...
        'windowSize', numericPlaceholder, ...
        'warningHorizon', numericPlaceholder, ...
        'pcaEnabled', logicalPlaceholder, ...
        'pcaSelectionMode', stringPlaceholder, ...
        'pcaVarianceThreshold', numericPlaceholder, ...
        'modelName', stringPlaceholder, ...
        'knnK', numericPlaceholder, ...
        'qdaRegularizationStrength', numericPlaceholder, ...
        'naiveBayesVarianceSmoothing', numericPlaceholder, ...
        'randomForestNumTrees', numericPlaceholder, ...
        'randomForestMinLeafSize', numericPlaceholder, ...
        'randomForestNumPredictorsToSample', numericPlaceholder, ...
        'ridgeRegressionLambda', numericPlaceholder, ...
        'weightedRidgeRegressionLambda', numericPlaceholder, ...
        'weightedRidgeRegressionEta', numericPlaceholder, ...
        'weightedRidgeRegressionTau', numericPlaceholder, ...
        'trainAccuracy', numericPlaceholder, ...
        'trainF1', numericPlaceholder, ...
        'trainPrecision', numericPlaceholder, ...
        'trainRecall', numericPlaceholder, ...
        'trainSpecificity', numericPlaceholder, ...
        'trainBalancedAccuracy', numericPlaceholder, ...
        'trainRMSE', numericPlaceholder, ...
        'trainMAE', numericPlaceholder, ...
        'trainMedAE', numericPlaceholder, ...
        'trainR2', numericPlaceholder, ...
        'trainBias', numericPlaceholder, ...
        'testAccuracy', numericPlaceholder, ...
        'testF1', numericPlaceholder, ...
        'testPrecision', numericPlaceholder, ...
        'testRecall', numericPlaceholder, ...
        'testSpecificity', numericPlaceholder, ...
        'testBalancedAccuracy', numericPlaceholder, ...
        'testRMSE', numericPlaceholder, ...
        'testMAE', numericPlaceholder, ...
        'testMedAE', numericPlaceholder, ...
        'testR2', numericPlaceholder, ...
        'testBias', numericPlaceholder ...
    );
end