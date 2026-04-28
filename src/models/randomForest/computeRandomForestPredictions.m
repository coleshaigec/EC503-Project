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

    X = dataset.X;
    ensemble = randomForestModel.ensemble;

    yHat = predict(ensemble, X);
    yHat = double(yHat(:));

    assert(all(ismember(yHat, [-1; 1])), ...
        'computeRandomForestPredictions:InvalidPredictedLabels', ...
        'Random forest predictions must contain only -1 and +1 labels.');

    randomForestResult = struct();
    randomForestResult.yHat = yHat;

    randomForestResult.metadata = struct();
    randomForestResult.metadata.numTrees = randomForestModel.numTrees;
    randomForestResult.metadata.minLeafSize = randomForestModel.minLeafSize;
    randomForestResult.metadata.numPredictorsToSample = randomForestModel.numPredictorsToSample;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateRandomForestResult(randomForestResult, dataset, randomForestModel);

end