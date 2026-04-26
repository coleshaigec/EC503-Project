function knnResult = computeKNNPredictions(dataset, knnModel)
    % COMPUTEKNNPREDICTIONS Computes predictions of k-Nearest Neighbors classification model on dataset.
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = dataset.X;
    y = dataset.y;

    Xtrain = knnModel.Xtrain;
    ytrain = knnModel.ytrain;
    k = knnModel.k;

    n = size(X, 1);

    knnDistances = zeros(n, k);
    knnIndices = zeros(n, k);
    yHat = zeros(n, 1);

    isTrainingPrediction = isequal(X, Xtrain) && isequal(y, ytrain);

    for i = 1:n
        xCurrent = X(i, :);

       
        diffMatrix = Xtrain - xCurrent;
        distances = sqrt(sum(diffMatrix.^2, 2));

       
        if isTrainingPrediction
            distances(i) = inf;
        end

        
        [sortedDistances, sortedIndices] = sort(distances, 'ascend');

     
        neighborDistances = sortedDistances(1:k);
        neighborIndices = sortedIndices(1:k);

     
        neighborLabels = ytrain(neighborIndices);

     
        uniqueLabels = unique(ytrain);
        labelCounts = zeros(numel(uniqueLabels), 1);

        for j = 1:numel(uniqueLabels)
            labelCounts(j) = sum(neighborLabels == uniqueLabels(j));
        end

        
        maxCount = max(labelCounts);
        tiedLabels = uniqueLabels(labelCounts == maxCount);

    
        if numel(tiedLabels) == 1
            predictedLabel = tiedLabels;
        else
            idxRandom = randi(numel(tiedLabels));
            predictedLabel = tiedLabels(idxRandom);
        end

      
        yHat(i) = predictedLabel;
        knnDistances(i, :) = neighborDistances.';
        knnIndices(i, :) = neighborIndices.';
    end
    knnResult = struct();
    knnResult.yHat = yHat;

    knnResult.metadata = struct();
    knnResult.metadata.knnDistances = knnDistances;
    knnResult.metadata.knnIndices = knnIndices;
    knnResult.metadata.knnModel = knnModel;
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateKNNResult(knnResult, dataset, knnModel);

end