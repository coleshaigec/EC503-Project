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

    X = trainingData.X;
    y = trainingData.y(:);

    [~, numFeatures] = size(X);

    numTrees = randomForestHyperparameters.numTrees;
    minLeafSize = randomForestHyperparameters.minLeafSize;
    numPredictorsToSample = randomForestHyperparameters.numPredictorsToSample;

    assert(numPredictorsToSample <= numFeatures, ...
        'trainRandomForestModel:NumPredictorsToSampleTooLarge', ...
        ['numPredictorsToSample must not exceed the number of feature columns. ' ...
        'Got %d predictors to sample for %d features.'], ...
        numPredictorsToSample, numFeatures);

    treeTemplate = templateTree( ...
        'MinLeafSize', minLeafSize, ...
        'NumVariablesToSample', numPredictorsToSample);

    ensemble = fitcensemble( ...
        X, y, ...
        'Method', 'Bag', ...
        'NumLearningCycles', numTrees, ...
        'Learners', treeTemplate);

    if ~isa(ensemble, 'CompactClassificationEnsemble')
        ensemble = compact(ensemble);
    end

    randomForestModel = struct();
    randomForestModel.ensemble = ensemble;
    randomForestModel.numTrees = numTrees;
    randomForestModel.minLeafSize = minLeafSize;
    randomForestModel.numPredictorsToSample = numPredictorsToSample;

    % Output validation - please do not remove
    validateRandomForestModel(randomForestModel, trainingData, randomForestHyperparameters);

end