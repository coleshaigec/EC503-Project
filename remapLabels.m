function classificationDataset = remapLabels(rawData, warningHorizons)
    % REMAPLABELS Maps RUL labels in raw dataset to specified failure hazard bins to facilitate classification learning
    %
    % INPUTS
    %  rawData struct with fields
    %       .Xtrain (nTrain x d double) - training feature matrix
    %       .ytrain (nTrain x 1 double) - training label vector
    %       .Xtest  (nTest x d double)  - test feature matrix
    %       .ytest  (nTest x 1 double)  - test label vector
    %       .ntrain (int)               - training dataset size
    %       .ntest  (int)               - test dataset size
    %       .d      (int)               - dataset dimension
    %
    %  warningHorizons (m x 1 double)   - upper limits for warning horizon bins
    %
    % OUTPUTS
    %  classificationDataset struct with fields
    %      .Xtrain (nTrain x d double)       - training feature matrix
    %      .ytrain (nTrain x 1 double)       - remapped training label vector
    %      .Xtest  (nTest x d double)        - test feature matrix
    %      .ytest  (nTest x 1 double)        - remapped test label vector
    %      .ntrain (int)                     - training dataset size
    %      .ntest  (int)                     - test dataset size
    %      .d      (int)                     - dataset dimension
    %      .warningHorizons (m x 1 double)   - metadata field preserving bin edges
    %      .numWarningHorizons (int)         - number of warning horizons considered
    %      .numClasses (int)                 - number of classification bins

    % -- Validate warning horizons --
    WARNING_HORIZON_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double', 'positive'};
    warningHorizons = sort(unique(warningHorizons), 'ascend');
    validateattributes(warningHorizons, {'numeric'}, WARNING_HORIZON_ATTRIBUTES, ...
        mfilename, 'warningHorizons');

    m = numel(warningHorizons);
    numClasses = m + 1;

    % -- Remap labels in ytrain and ytest to appropriate bins --
    ytrain = rawData.ytrain;
    ytest = rawData.ytest;

    ytrainNew = ones(rawData.ntrain, 1);
    ytestNew = ones(rawData.ntest, 1);

    for i = 1:m
        ytrainNew(ytrain > warningHorizons(i)) = i + 1;
        ytestNew(ytest > warningHorizons(i)) = i + 1;
    end

    % -- Populate output struct --
    classificationDataset = rawData;
    classificationDataset.ytrain = ytrainNew;
    classificationDataset.ytest = ytestNew;
    classificationDataset.warningHorizons = warningHorizons;
    classificationDataset.numWarningHorizons = m;
    classificationDataset.numClasses = numClasses;

    % -- Validate results --
    validateClassificationDataset(classificationDataset, rawData, warningHorizons);
end