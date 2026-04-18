function allModels = getAllModels()
    % GETALLMODELS Returns names of all models available for use.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  allModels (string array)

    allModels = ["naiveBayes", "kernelSVM", "randomForest", "kNN", "gradientBoostingRegression", "ridgeRegression"];
end