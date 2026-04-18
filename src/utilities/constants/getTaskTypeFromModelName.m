function taskType = getTaskTypeFromModelName(modelName)
    % GETTASKTYPEFROMMODELNAME Uses model name to determine whether task type is classification or regression.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT 
    %  taskType (string)

    classificationModels = getClassificationModels();
    regressionModels = getRegressionModels();

    if ismember(modelName, classificationModels)
        taskType = 'classification';
    elseif ismember(modelName, regressionModels)
        taskType = 'regression';
    else
        error('getTaskTypeFromModelName:InvalidFieldValue', ...
            'modelName %s is not valid.', modelName);
    end
end