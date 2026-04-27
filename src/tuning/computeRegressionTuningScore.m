function runScore = computeRegressionTuningScore(validationData, trainedModel, taskType, warningHorizon)
    % COMPUTEREGRESSIONTUNINGSCORE Computes trained classification model performance score for a single tuning run.
    % 
    % INPUTS
    %  validationData struct with fields  
    %      .X (nValidation x d double)      - validation features
    %      .y (nValidation x 1 double)      - validation labels
    %
    %  trainedModel (struct)
    %    Field names vary by model type
    %    Must contain a .modelName field for all models
    %
    %  modelName (string)
    %
    % OUTPUTS
    %  runScore (double)                    - RMSE
    
    % -- Compute predicted labels --
    predictions = computePredictions(validationData, trainedModel);
    yHat = predictions.yHat;

    % -- Run policy analysis --
    policyResult = runPolicyAnalysis(yHat, validationData.y, warningHorizon, taskType);

    % -- Compute run score as total policy cost --
    runScore = policyResult.policyCosts.totalPolicyCost;
end
