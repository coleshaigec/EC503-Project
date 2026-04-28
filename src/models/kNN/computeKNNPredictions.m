function knnResult = computeKNNPredictions(dataset, knnModel)
    % COMPUTERKNNPREDICTIONS Computes predictions of k-Nearest Neighbors classification model on dataset.
    %
    % AUTHORS: Youwei Chen, Cole H. Shaigec
    %
    % INPUT 
    %  dataset struct with fields
    %      .X (n x d double) - feature matrix
    %      .y (n x 1 double) - label vector
    %
    %  knnModel struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .k (int > 0)                - number of NNs used
    %
    % OUTPUT
    %  knnResult struct with fields
    %      .yHat (n x 1 double)           - predicted labels
    %      .metadata struct with fields
    %          .knnDistances (n x k double)   - distances of k-nearest neighbors of each training sample
    %          .knnIndices (n x k int)        - indices of k-nearest neighbors of each training point
    %          .knnModel struct with fields
    %              .Xtrain (nTrain x d double)          - training feature matrix
    %              .ytrain (nTrain x 1 double)          - training label vector
    %              .k (int > 0)                         - number of NNs used

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. Euclidean distance will be used as the distance metric for kNN.
    % 2. Weighted kNN is not considered in this project. We will use kNN
    % with uniform weighting.
    % 3. kNN ties should be broken probabilistically (i.e., pick the most likely class label as in the kNN
    % homework assignment we completed)
    % 4. Training-set predictions must exclude the sample itself from its own
    % neighbor set when computing yHatTrain.

    X = dataset.X;
    Xtrain = knnModel.Xtrain;
    ytrain = knnModel.ytrain(:);
    k = knnModel.k;

    n = size(X, 1);
    nTrain = size(Xtrain, 1);

    assert(k <= nTrain, ...
        'computeKNNPredictions:KTooLarge', ...
        'k must not exceed the number of training samples.');

    isTrainingPrediction = isequal(X, Xtrain);

    if isTrainingPrediction
        assert(k <= nTrain - 1, ...
            'computeKNNPredictions:KTooLargeForTrainingPrediction', ...
            'For training-set predictions with self-exclusion, k must be <= nTrain - 1.');
    end

    classLabels = unique(ytrain);

    assert(isequal(classLabels, [-1; 1]), ...
        'computeKNNPredictions:InvalidClassLabels', ...
        'kNN training labels must be exactly -1 and +1.');

    distanceMatrix = pdist2(X, Xtrain, 'euclidean');

    if isTrainingPrediction
        selfIndices = 1:nTrain;
        linearSelfIndices = sub2ind([nTrain, nTrain], selfIndices, selfIndices);
        distanceMatrix(linearSelfIndices) = inf;
    end

    [knnDistances, knnIndices] = mink(distanceMatrix, k, 2);

    neighborLabels = ytrain(knnIndices);

    numPositiveNeighbors = sum(neighborLabels == 1, 2);
    numNegativeNeighbors = sum(neighborLabels == -1, 2);

    yHat = zeros(n, 1);
    yHat(numPositiveNeighbors > numNegativeNeighbors) = 1;
    yHat(numNegativeNeighbors > numPositiveNeighbors) = -1;

    tieMask = numPositiveNeighbors == numNegativeNeighbors;
    numTies = sum(tieMask);

    if numTies > 0
        randomTieLabels = 2 * randi([0, 1], numTies, 1) - 1;
        yHat(tieMask) = randomTieLabels;
    end

    knnResult = struct();
    knnResult.yHat = yHat;

    knnResult.metadata = struct();
    knnResult.metadata.knnDistances = knnDistances;
    knnResult.metadata.knnIndices = knnIndices;
    knnResult.metadata.k = k;

    % -- Output validation - PLEASE DO NOT REMOVE --
    validateKNNResult(knnResult, dataset, knnModel);

end