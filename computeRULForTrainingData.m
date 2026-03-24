function RUL = computeRULForTrainingData(Xtrain)
    n = size(Xtrain, 1);
    RUL = zeros(n, 1);

    numEngines = max(Xtrain(:,1));

    for engine = 1:numEngines
        idxSelectedEngine = (Xtrain(:,1) == engine);
        timestampsSelectedEngine = Xtrain(idxSelectedEngine, 2);
        nRecordsSelectedEngine = nnz(idxSelectedEngine);
        RUL(idxSelectedEngine) = nRecordsSelectedEngine - timestampsSelectedEngine;
    end
end