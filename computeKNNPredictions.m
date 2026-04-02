function knnResult = computeKNNPredictions(dataset, knnModel)
    % COMPUTEKNNPREDICTIONS Computes predictions of k-Nearest Neighbors classification model on dataset.
    %
    % INPUT 
    %  dataset struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  knnModel struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .k (int > 0)                - number of NNs used
    %
    % OUTPUT
    %  knnResult struct with fields
    %      .yHatTrain (ntrain x 1 double)           - predicted training labels
    %      .yHatTest  (ntest x 1 double)            - predicted test labels
    %      .knnDistancesTrain (ntrain x k double)   - distances of k-nearest neighbors of each training sample
    %      .knnDistancesTest  (ntest x k double)    - distances of k-nearest neighbors of each test sample
    %      .knnIndicesTrain   (ntrain x k int)      - indices of k-nearest neighbors of each training point
    %      .knnIndicesTest   (ntest x k int)        - indices of k-nearest neighbors of each test point
    %      .knnModel struct with fields
    %          .Xtrain (nTrain x d double)          - training feature matrix
    %          .ytrain (nTrain x 1 double)          - training label vector
    %          .k (int > 0)                         - number of NNs used
    %  

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