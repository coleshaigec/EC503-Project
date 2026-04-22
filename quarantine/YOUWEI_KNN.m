function YOUWEI_KNN()
    % Run this script with all relevant .m files and the CMAPSS data in your directory to test
    % your code.

    % You may need to change the cmapssDataFolderPath variable in
    % readCMAPSSData.m to get your code to work.

    % ChatGPT or other AI tools can help debug folder path issues, or
    % contact Cole

    % FILES NEEDED TO RUN THIS CODE
    % fitPCATransform.m
    % readCMAPSSData.m
    % trimSensorReadings.m

    tic;
    % Make a simple dataset from a subset of CMAPSS
    cmapssData = readCMAPSSData();

    trimmedCMAPSSData = trimSensorReadings(cmapssData);

    windowedCMAPSSData = buildWindowedDataset(trimmedCMAPSSData, 3);

    datasetTrain = struct();
    datasetTrain.X = windowedCMAPSSData.FD001.Xtrain;
    datasetTrain.y = windowedCMAPSSData.FD001.ytrain;

    datasetTest = struct();
    datasetTest.X = windowedCMAPSSData.FD001.Xtest;
    datasetTest.y = windowedCMAPSSData.FD001.ytest;

    knnHyperparameters = struct('k', 3);

    knnModel = trainKNNModel(datasetTrain, knnHyperparameters);

    knnResult = computeKNNPredictions(datasetTest, knnModel);

    toc;
end
