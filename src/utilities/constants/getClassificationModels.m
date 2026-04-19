function classificationModels = getClassificationModels()
    % GETCLASSIFICATIONMODELS Returns names of classification models available for use.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  classificationModels (string array)

    classificationModels = ["naiveBayes", "QDA", "randomForest", "kNN"];
end