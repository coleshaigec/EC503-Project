function windowedDataset = buildWindowedDataset(cmapssData, windowSize)
    %BUILDWINDOWEDDATASET Applies windowing to construct train and test
    %samples from CMAPSS data for use by downstream operations.

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