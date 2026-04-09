function tuningResult = tuneHyperparameters(trainData, validationData, modelName, searchGrid, taskType)
    % TUNEHYPERPARAMETERS Runs grid search to tune hyperparameters for specified model
    %
    % INPUTS
    %  trainData struct with fields
    %      .X (nTrain x d double)           - training features
    %      .y (nTrain x 1 double)           - training labels
    %  
    %  validationData struct with fields  
    %      .X (nValidation x d double)      - validation features
    %      .y (nValidation x 1 double)      - validation labels
    %    
    %  modelName (string)  
    %   
    %  taskType (string)                    - 'classification' or 'regression'
    %  
    %  searchGrid (struct)                  - candidate hyperparameter values, to be unpacked for grid search
    %
    % OUTPUTS
    %  tuningResult struct with fields
    %      .modelName
    %      .taskType
    %      .bestModel (struct)              - trained model with best performance in tuning
    %      .bestRunScore (double)           - RMSE for regression, weighted average of F1 and accuracy for classification
    %      .allRunRecords (struct array)    - full record of all candidate runs, including candidate hyperparameters and scalar run score
    %          runRecord struct with fields
    %              .hyperparameterValues (struct)
    %              .runScore
    %      .searchGrid (struct)
    

end