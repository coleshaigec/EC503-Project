function KELLY_FITPCA()
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

    % Test case 1: variance threshold mode
    pcaSpec1 = struct( ...
        'enabled', true, ...
        'selectionMode', 'varianceThreshold',...
        'varianceThreshold', 0.95,...
        'fixedNumComponents', 10 ...
    );

    % Test case 2: fixed num components mode
    pcaSpec2 = struct( ...
        'enabled', true, ...
        'selectionMode', 'fixedNumComponents',...
        'varianceThreshold', 0.95,...
        'fixedNumComponents', 10 ...
    );

    X = windowedCMAPSSData.FD001.Xtrain;

    pcaTransform1 = fitPCATransform(X, pcaSpec1);
    pcaTransform2 = fitPCATransform(X, pcaSpec2);
    % dataset = struct();
    % dataset.X = windowedCMAPSSData.FD001.Xtrain;
    

    % Hyperparameters -- play with these at your pleasure
    % logisticRegressionHyperparameters = struct();
    % logisticRegressionHyperparameters.solver = 'lbfgs';
    % logisticRegressionHyperparameters.lambda = 3;
    % logisticRegressionHyperparameters.maxIter = 2;

    % Train model
    % trainedModel = trainLogisticRegressionModel(dataset, logisticRegressionHyperparameters);
    % yHat = computeLogisticRegressionPredictions(dataset, trainedModel);


    %  pcaSpec struct with fields:
    %      .enabled (boolean)
    %      .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %      .varianceThreshold (double in [0,1]) - 
    %      .fixedNumComponents (int > 0) - number of principal components to compute 
    

    
end