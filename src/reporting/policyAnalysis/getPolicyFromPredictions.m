function maintenancePolicy = getPolicyFromPredictions(yHat, warningHorizon, taskType)
    % GETPOLICYFROMPREDICTIONS Instantiates maintenance policy induced by predictions of model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double) - predicted labels (classification) or RUL estimates (regression)
    %  warningHorizon (positive integer) - TTF decision threshold
    %  taskType (string) - 'classification' or 'regression'
    %
    % OUTPUTS
    %  maintenancePolicy (n x 1 logical) - 1 if maintenance triggered, 0 otherwise
    %
    % NOTES
    % - This function applies different logic depending on whether the task
    % is classification or regression. 
    % - Classification labels are in {+1, -1} already with +1 corresponding
    % to a predicted failure within the warningHorizon, -1 otherwise. 
    % - Regression labels are RUL estimates and require a different remapping
    % than their classification counterparts.

    if strcmpi(taskType, 'regression')
        maintenancePolicy = yHat <= warningHorizon;
    elseif strcmpi(taskType, 'classification')
        maintenancePolicy = yHat == 1;
    else
        error('getPolicyFromPredictions:InvalidFieldValue', ...
            'taskType expected ''classification'' or ''regression'' but got %s', ...
            taskType ...
        );
    end
end