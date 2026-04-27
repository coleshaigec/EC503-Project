function randomForestResult = computeRandomForestPredictions(dataset, randomForestModel)
    % COMPUTERANDOMFORESTPREDICTIONS Computes predictions of trained random forest model on dataset.
    %
    % AUTHORS: Kelly Falcon, Cole H. Shaigec
    %
    % INPUTS
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - true label vector
    %
    %  randomForestModel struct with fields
    %      .ensemble (CompactClassificationEnsemble) - trained random forest ensemble
    %      .numTrees (positive integer)
    %      .minLeafSize (positive integer)
    %      .numPredictorsToSample (positive integer)
    %
    % OUTPUT
    %  randomForestResult struct with fields
    %      .yHat (n x 1 double) - predicted labels
    %      .metadata struct with fields
    %          .numTrees (positive integer)
    %          .minLeafSize (positive integer)
    %          .numPredictorsToSample (positive integer)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Please do not delete the docstring above.
    % 2. This function must compute predictions for a CLASSIFICATION random forest.
    %    Do not treat this as a regression model.
    % 3. Do not retrain, modify, or augment the model inside this function.
    %    This function is prediction-only.
    % 4. Do not normalize features inside this function. Any normalization and/or PCA
    %    has already been handled upstream by the pipeline when required.
    % 5. Use the trained ensemble stored in randomForestModel.ensemble and MATLAB's
    %    standard predict interface for inference.
    % 6. Prediction must be computationally efficient. This function will be called
    %    many times throughout tuning and evaluation.
    % 7. Ensure that yHat is returned as an n x 1 double column vector whose entries
    %    are class labels compatible with the rest of the pipeline (i.e., +1 and -1).
    % 8. Be careful with MATLAB built-ins that may return predicted class labels as
    %    categorical arrays, cell arrays of character vectors, strings, or other
    %    non-double formats. Convert the final predicted labels to double before
    %    storing them in randomForestResult.yHat.
    % 9. Always store the model hyperparameters in metadata:
    %     - .numTrees
    %     - .minLeafSize
    %     - .numPredictorsToSample
    % 10. Do not store the full model again inside metadata.
    % 11. Do not store redundant copies of X, y, tree objects, or any large intermediate
    %   arrays in the result struct.
    % 12. Do not compute optional diagnostics such as out-of-bag predictions, predictor
    %   importance, per-tree predictions, or any other extra outputs not required for
    %   standard downstream evaluation in this project.
    % 13. The implementation should fail loudly if prediction cannot be computed using
    %   randomForestModel.ensemble. Do not silently continue with malformed outputs.
    % 14. The final output struct must satisfy validateRandomForestResult exactly.

    X = dataset.X;
    ensemble = randomForestModel.ensemble;
    yHat_raw = predict(ensemble, X);
    yHat = double(yHat_raw(:));
    
    randomForestResult = struct();
    randomForestResult.yHat = yHat;
    randomForestResult.metadata = struct();
    randomForestResult.metadata.numTrees = randomForestModel.numTrees;
    randomForestResult.metadata.minLeafSize = randomForestModel.minLeafSize;
    randomForestResult.metadata.numPredictorsToSample = randomForestModel.numPredictorsToSample;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateRandomForestResult(randomForestResult, dataset, randomForestModel);

end