function runScore = computeClassificationTuningScore(validationData, trainedModel)
    % COMPUTECLASSIFICATIONTUNINGSCORE Computes trained classification model performance score for a single tuning run.
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
    %  runScore (double)                    - 75/25 weighted average of recall and accuracy
    %
    % NOTES
    %  - 75/25 recall/accuracy weighting is used to reflect economic
    %  structure of learning problem
    %  - This balance is an approximate heuristic choice based on CMAPSS
    %  EDA rather than some unique optimization calculation

    % Compute predicted labels
    predictions = computePredictions(validationData, trainedModel);
    yHat = predictions.yHat;

    % Compute classifier accuracy
    recall = computeRecall(yHat, validationData.y);

    % Return score
    runScore = recall;
end