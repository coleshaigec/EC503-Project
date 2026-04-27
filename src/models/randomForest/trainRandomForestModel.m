function randomForestModel = trainRandomForestModel(trainingData, randomForestHyperparameters)
    % TRAINRANDOMFORESTMODEL Trains random forest model on training data using specified hyperparameters.
    %
    % AUTHORS: Kelly Falcon, Cole H. Shaigec
    %
    % INPUTS 
    %  trainingData struct with fields
    %      .X (n x d double) - training feature matrix
    %      .y (n x 1 double) - training label vector
    %
    %  randomForestHyperparameters struct with fields
    %      .numTrees (positive integer)      - number of trees in the forest
    %      .minLeafSize (positive integer)   - minimum number of observations per leaf
    %      .numPredictorsToSample (positive integer)  - number of predictors randomly sampled at each split
    %
    % OUTPUT
    %  randomForestModel struct with fields
    %      .ensemble (CompactClassificationEnsemble) - trained random forest ensemble
    %      .numTrees (positive integer)
    %      .minLeafSize (positive integer)
    %      .numPredictorsToSample (positive integer)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Please do not delete the docstring above.
    % 2. This function must train a CLASSIFICATION random forest, not a regression forest.
    % 3. Use a MATLAB built-in ensemble/tree method. Do not implement tree growth manually.
    % 4. Training labels are assumed to have already been prepared correctly by the pipeline.
    %    Do not remap labels inside this function.
    % 5. Do not normalize features inside this function. Any normalization and/or PCA has
    %    already been handled upstream by the pipeline when required.
    % 6. The implementation must be computationally efficient. This function will be called
    %    many times inside cross-validation and experiment runs.
    % 7. Use bagged decision trees to represent the random forest.
    % 8. Configure the ensemble using the three hyperparameters provided:
    %       - numTrees controls the number of trees in the forest
    %       - minLeafSize controls leaf size of the individual trees
    %       - numPredictorsToSample controls the number of predictors sampled at each split
    % 9. Do not introduce any additional exposed hyperparameters or hidden tuning logic.
    % 10. Ensure numPredictorsToSample is valid for the training matrix dimension. In
    %     particular, it must not exceed size(trainingData.X, 2).
    % 11. The fitted ensemble stored in randomForestModel.ensemble must support downstream
    %     prediction through MATLAB's standard predict interface.
    % 12. Store only the information needed for downstream prediction and reporting.
    %     Do not store redundant copies of X or y inside randomForestModel.
    % 13. If the built-in training routine returns a non-compact ensemble object, compact it
    %     before storing it in randomForestModel.ensemble.
    % 14. Preserve the hyperparameter values exactly in the output struct fields
    %     .numTrees, .minLeafSize, and .numPredictorsToSample.
    % 15. Avoid optional outputs or diagnostics that materially increase runtime or memory
    %     usage unless they are strictly required for prediction.
    % 16. Do not use out-of-bag prediction, predictor importance, surrogate splits,
    %     cross-validation inside the model fit, or any other extra computation not required
    %     for standard training and prediction in this project.
    % 17. The implementation should fail loudly if the training routine cannot produce a valid
    %     classification ensemble. Do not silently continue with a malformed model.
    % 18. The final output struct must satisfy validateRandomForestModel exactly.

    % -- YOUR IMPLEMENTATION HERE --
    X = trainingData.X;
    y = trainingData.y;
    [~,d] = size(X);
    numTrees = randomForestHyperparameters.numTrees;
    minLeafSize = randomForestHyperparameters.minLeafSize;
    numPredictorsToSample = randomForestHyperparameters.numPredictorsToSample;
    
    %making sure is not larger than columns
    assert(numPredictorsToSample <= d, ...
    'trainRandomForestModel:NumPredictorsToSampleTooLarge', ...
    ['numPredictorsToSample must not exceed the number of feature columns. ' ...
     'Got %d predictors to sample for %d features.'], ...
    numPredictorsToSample, d);
    
    t = templateTree('MinLeafSize', minLeafSize, 'NumVariablesToSample', numPredictorsToSample);
    ensemble = fitcensemble( X, y, 'Method', 'Bag', 'NumLearningCycles', numTrees, ...
        'Learners', t);
    ensemble = compact(ensemble);
    
    randomForestModel = struct();
    randomForestModel.ensemble = ensemble;
    randomForestModel.numTrees = numTrees;
    randomForestModel.minLeafSize = minLeafSize;
    randomForestModel.numPredictorsToSample = numPredictorsToSample;

    % Output validation - please do not remove
    validateRandomForestModel(randomForestModel, trainingData, randomForestHyperparameters);

end