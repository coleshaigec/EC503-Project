function validateRegressionPerformanceMetricsForReporting(performanceMetrics, model, dataset)
    % VALIDATEREGRESSIONPERFORMANCEMETRICSFORREPORTING Validates regression performance metrics
    % computed for trained model against full train and test datasets.
    %
    % INPUTS
    %  performanceMetrics struct with fields
    %     .modelName (string)
    %     .train struct with fields
    %         .RMSE (double)
    %         .MAE (double)
    %         .R2 (double)
    %     .test struct with fields
    %         .RMSE (double)
    %         .MAE (double)
    %         .R2 (double)
    %
    %  model struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be analyzed
    %      .taskType  (string)         - 'classification' or 'regression'
    %      .hyperparameters (struct)   - hyperparameters used in training
    %
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension

    % -- Validate structure of performanceMetrics --
    if ~isstruct(performanceMetrics)
        error('validateRegressionPerformanceMetricsForReporting:InvalidType', ...
            'performanceMetrics must be a struct.');
    end

    if ~isfield(performanceMetrics, 'modelName')
        error('validateRegressionPerformanceMetricsForReporting:MissingField', ...
            'performanceMetrics must have a ''modelName'' field.');
    end

    if ~isfield(performanceMetrics, 'train')
        error('validateRegressionPerformanceMetricsForReporting:MissingField', ...
            'performanceMetrics must have a ''train'' field.');
    end

    if ~isfield(performanceMetrics, 'test')
        error('validateRegressionPerformanceMetricsForReporting:MissingField', ...
            'performanceMetrics must have a ''test'' field.');
    end

    % -- Validate modelName --
    if ~(ischar(performanceMetrics.modelName) || ...
            (isstring(performanceMetrics.modelName) && isscalar(performanceMetrics.modelName)))
        error('validateRegressionPerformanceMetricsForReporting:InvalidModelNameType', ...
            'performanceMetrics.modelName must be a character vector or string scalar.');
    end

    assert(strcmpi(char(performanceMetrics.modelName), char(model.modelName)), ...
        'validateRegressionPerformanceMetricsForReporting:ModelNameMismatch', ...
        'performanceMetrics.modelName must equal model.modelName.');

    % -- Validate task type context --
    assert(strcmpi(char(model.taskType), 'regression'), ...
        'validateRegressionPerformanceMetricsForReporting:InvalidTaskType', ...
        'model.taskType must be ''regression''.');

    % -- Validate train/test metric structs --
    if ~isstruct(performanceMetrics.train)
        error('validateRegressionPerformanceMetricsForReporting:InvalidTrainMetricsType', ...
            'performanceMetrics.train must be a struct.');
    end

    if ~isstruct(performanceMetrics.test)
        error('validateRegressionPerformanceMetricsForReporting:InvalidTestMetricsType', ...
            'performanceMetrics.test must be a struct.');
    end

    REQUIRED_METRIC_FIELDS = {'RMSE', 'MAE', 'R2'};

    for i = 1:numel(REQUIRED_METRIC_FIELDS)
        fieldName = REQUIRED_METRIC_FIELDS{i};

        if ~isfield(performanceMetrics.train, fieldName)
            error('validateRegressionPerformanceMetricsForReporting:MissingField', ...
                'performanceMetrics.train must have a ''%s'' field.', fieldName);
        end

        if ~isfield(performanceMetrics.test, fieldName)
            error('validateRegressionPerformanceMetricsForReporting:MissingField', ...
                'performanceMetrics.test must have a ''%s'' field.', fieldName);
        end
    end

    % -- Validate metric values --
    NONNEGATIVE_SCALAR_DOUBLE_ATTRIBUTES = {'scalar', 'real', 'finite', 'nonnegative', 'double'};
    SCALAR_DOUBLE_ATTRIBUTES = {'scalar', 'real', 'finite', 'double'};

    validateattributes(performanceMetrics.train.RMSE, {'double'}, ...
        NONNEGATIVE_SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.train.RMSE');
    validateattributes(performanceMetrics.train.MAE, {'double'}, ...
        NONNEGATIVE_SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.train.MAE');
    validateattributes(performanceMetrics.train.R2, {'double'}, ...
        SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.train.R2');

    validateattributes(performanceMetrics.test.RMSE, {'double'}, ...
        NONNEGATIVE_SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.test.RMSE');
    validateattributes(performanceMetrics.test.MAE, {'double'}, ...
        NONNEGATIVE_SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.test.MAE');
    validateattributes(performanceMetrics.test.R2, {'double'}, ...
        SCALAR_DOUBLE_ATTRIBUTES, mfilename, 'performanceMetrics.test.R2');

    % -- Validate metric semantics against direct recomputation --
    predictionResult = computePredictions(model, dataset);

    expectedTrainRMSE = computeRMSE(predictionResult.yHatTrain, dataset.ytrain);
    expectedTrainMAE = computeMAE(predictionResult.yHatTrain, dataset.ytrain);
    expectedTrainR2 = computeR2(predictionResult.yHatTrain, dataset.ytrain);

    expectedTestRMSE = computeRMSE(predictionResult.yHatTest, dataset.ytest);
    expectedTestMAE = computeMAE(predictionResult.yHatTest, dataset.ytest);
    expectedTestR2 = computeR2(predictionResult.yHatTest, dataset.ytest);

    METRIC_TOLERANCE = 1e-10;

    assert(abs(performanceMetrics.train.RMSE - expectedTrainRMSE) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TrainRMSEMismatch', ...
        'performanceMetrics.train.RMSE does not match recomputed value.');
    assert(abs(performanceMetrics.train.MAE - expectedTrainMAE) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TrainMAEMismatch', ...
        'performanceMetrics.train.MAE does not match recomputed value.');
    assert(abs(performanceMetrics.train.R2 - expectedTrainR2) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TrainR2Mismatch', ...
        'performanceMetrics.train.R2 does not match recomputed value.');

    assert(abs(performanceMetrics.test.RMSE - expectedTestRMSE) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TestRMSEMismatch', ...
        'performanceMetrics.test.RMSE does not match recomputed value.');
    assert(abs(performanceMetrics.test.MAE - expectedTestMAE) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TestMAEMismatch', ...
        'performanceMetrics.test.MAE does not match recomputed value.');
    assert(abs(performanceMetrics.test.R2 - expectedTestR2) <= METRIC_TOLERANCE, ...
        'validateRegressionPerformanceMetricsForReporting:TestR2Mismatch', ...
        'performanceMetrics.test.R2 does not match recomputed value.');
end