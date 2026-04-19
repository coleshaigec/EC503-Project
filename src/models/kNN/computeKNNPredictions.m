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

    knnResult = struct();
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validateKNNResult(knnResult, dataset, knnModel);

end