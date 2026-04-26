function errorDiagnosticsResult = runErrorDiagnostics(yHat, trueRULs, warningHorizon, taskType)
    % RUNERRORDIAGNOSTICS Analyzes the number and nature of errors made by the model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)      - model predictions
    %  trueRULs (n x 1 double)  - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold used for warning analysis
    %  taskType (string)        - 'classification' or 'regression'
    %
    % OUTPUT
    %  errorDiagnosticsResult struct with task-specific fields
    
    if strcmp(taskType, 'classification')
        errorDiagnosticsResult = performClassificationErrorDiagnostics(yHat, trueRULs, warningHorizon);
    elseif strcmp(taskType, 'regression')
        errorDiagnosticsResult = performRegressionErrorDiagnostics(yHat, trueRULs, warningHorizon);
    else
        error('runErrorDiagnostics:InvalidFieldValue', ...
            'Expected taskType in ''classification'' or ''regression'' but got %s', ...
            taskType ...
        );
    end
end