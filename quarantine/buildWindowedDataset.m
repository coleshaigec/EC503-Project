function windowedDataset = buildWindowedDataset(cmapssData, windowSize)
    %BUILDWINDOWEDDATASET Applies windowing to construct train and test
    %samples from CMAPSS data for use by downstream operations.
    %
    % INPUTS
    %  cmapssData struct with fields 
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .RUL (maxTimestamp x 3 double)
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %
    % OUTPUTS
    %  windowedDataset struct with fields
    %      .FD001 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD002 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD003 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension
    %      .FD004 struct with fields
    %          .Xtrain (ntrain x d double)  - training feature matrix
    %          .ytrain (ntrain x 1 double)  - training label vector
    %          .Xtest  (ntest x d double)   - test feature matrix
    %          .ytest  (ntest x 1 double)   - test label vector
    %          .ntrain (double)             - training set cardinality
    %          .ntest  (double)             - test set cardinality
    %          .d      (double)             - dataset dimension

    % Input validation
    WINDOW_SIZE_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer', '>=', 1};
    validateattributes(windowSize, {'numeric'}, WINDOW_SIZE_ATTRIBUTES, mfilename, 'windowSize');

    cmapssSubsets = fieldnames(cmapssData);
    windowedDataset = struct();
    
    % Window each CMAPSS subset individually
    for i = 1 : numel(cmapssSubsets)
        currentSubsetName = cmapssSubsets{i};
        windowedDataset.(currentSubsetName) = struct();
        currentSubset = cmapssData.(currentSubsetName);

        [Xtrain, ytrain] = windowTrainingDataset(currentSubset.train, windowSize);
        [Xtest, ytest] = windowTestDataset(currentSubset.test, windowSize);

        [ntrain, d1] = size(Xtrain);
        [ntest, d2] = size(Xtest);
        assert(d1 == d2, 'Windowed train and test sets have different dimensions.');

        windowedDataset.(currentSubsetName).Xtrain = Xtrain;
        windowedDataset.(currentSubsetName).ytrain = ytrain;
        windowedDataset.(currentSubsetName).Xtest = Xtest;
        windowedDataset.(currentSubsetName).ytest = ytest;
        windowedDataset.(currentSubsetName).ntrain = ntrain;
        windowedDataset.(currentSubsetName).ntest = ntest;
        windowedDataset.(currentSubsetName).d = d1;
    end
end