function cmapssData = readCMAPSSData()
    
    cmapssDataFolderPath = './dataCMAPSS/CMAPSSData/';
    cmapssData = struct();

    cmapssData.FD001 = struct();
    cmapssData.FD002 = struct();
    cmapssData.FD003 = struct();
    cmapssData.FD004 = struct();

    train001Path = strcat(cmapssDataFolderPath, 'train_FD001.txt');
    test001Path = strcat(cmapssDataFolderPath, 'test_FD001.txt');
    testRUL001Path = strcat(cmapssDataFolderPath, 'RUL_FD001.txt');
    train001 = readmatrix(train001Path, 'Delimiter', ' ');
    test001 = readmatrix(test001Path, 'Delimiter', ' ');
    rul001 = readmatrix(testRUL001Path, 'Delimiter', ' ');
    trainRUL001 = computeRULForTrainingData(train001);
    cmapssData.FD001.Xtrain = train001;
    cmapssData.FD001.ytrain = trainRUL001;
    cmapssData.FD001.Xtest = test001;
    cmapssData.FD001.ytest = rul001;

    train002Path = strcat(cmapssDataFolderPath, 'train_FD002.txt');
    test002Path = strcat(cmapssDataFolderPath, 'test_FD002.txt');
    testRUL002Path = strcat(cmapssDataFolderPath, 'RUL_FD002.txt');
    train002 = readmatrix(train002Path, 'Delimiter', ' ');
    test002 = readmatrix(test002Path, 'Delimiter', ' ');
    rul002 = readmatrix(testRUL002Path, 'Delimiter', ' ');
    trainRUL002 = computeRULForTrainingData(train002);
    cmapssData.FD002.Xtrain = train002;
    cmapssData.FD002.ytrain = trainRUL002;
    cmapssData.FD002.Xtest = test002;
    cmapssData.FD002.ytest = rul002;

    train003Path = strcat(cmapssDataFolderPath, 'train_FD003.txt');
    test003Path = strcat(cmapssDataFolderPath, 'test_FD003.txt');
    testRUL003Path = strcat(cmapssDataFolderPath, 'RUL_FD003.txt');
    train003 = readmatrix(train003Path, 'Delimiter', ' ');
    test003 = readmatrix(test003Path, 'Delimiter', ' ');
    rul003 = readmatrix(testRUL003Path, 'Delimiter', ' ');
    trainRUL003 = computeRULForTrainingData(train003);
    cmapssData.FD003.Xtrain = train003;
    cmapssData.FD003.ytrain = trainRUL003;
    cmapssData.FD003.Xtest = test003;
    cmapssData.FD003.ytest = rul003;

    train004Path = strcat(cmapssDataFolderPath, 'train_FD004.txt');
    test004Path = strcat(cmapssDataFolderPath, 'test_FD004.txt');
    testRUL004Path = strcat(cmapssDataFolderPath, 'RUL_FD004.txt');
    train004 = readmatrix(train004Path, 'Delimiter', ' ');
    test004 = readmatrix(test004Path, 'Delimiter', ' ');
    rul004 = readmatrix(testRUL004Path, 'Delimiter', ' ');
    trainRUL004 = computeRULForTrainingData(train004);
    cmapssData.FD004.Xtrain = train004;
    cmapssData.FD001.ytrain = trainRUL004;
    cmapssData.FD001.Xtest = test004;
    cmapssData.FD001.ytest = rul004;
end