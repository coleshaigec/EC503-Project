function errorDiagnosticsResult = runErrorDiagnostics(yHat, trueRULs, warningHorizon, taskType)
    % RUNERRORDIAGNOSTICS Analyzes the number and nature of errors made by the model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %
    % OUTPUT
    %  errorDiagnosticsResult struct with task-specific fields
    
    errorDiagnosticsResult = struct();
    errorDiagnosticsResult.classification = struct();
    errorDiagnosticsResult.regression = struct();

    if strcmp(taskType, 'classification')
        
    elseif strcmp(taskType, 'regression')
        errorDiagnosticsResult = performRegressionErrorDiagnostics(yHat, trueRULs, warningHorizon);
    else
        error('runErrorDiagnostics:InvalidFieldValue', ...
            'Expected taskType in ''classification'' or ''regression'' but got %s', ...
            taskType ...
        );
end