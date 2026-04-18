function hyperparameterIterable = unpackHyperparameterSearchGrid(searchGrid, modelName)
    % UNPACKHYPERPARAMETERSEARCHGRID Converts hyperparameter tuning search grid into iterable struct array for tuning via Cartesian product.
    %
    % INPUTS
    %  searchGrid (struct)   - set of candidate hyperparameter values
    %  modelName (string)    - name of model to be tuned
    %
    % OUTPUTS
    %  hyperparameterIterable struct with fields
    %      .hyperparameterNames (cell array of strings)
    %      .numCombinations (integer scalar)            - number of hyperparameter combinations in Cartesian product on search grid
    %      .candidateHyperparameterSets (struct array)  - hyperparameters to be iterated over on tuning

    % -- Validate inputs --
    validateHyperparameterSearchGrid(searchGrid, modelName);

    % -- Extract field names --
    hyperparameterNames = fieldnames(searchGrid);

    % -- Build template struct -- 
    template = struct();
    for i = 1:numel(hyperparameterNames)
        template.(hyperparameterNames{i}) = [];
    end

    % -- Enumerate Cartesian product of hyperparameter grids --
    valueSets = cell(numel(hyperparameterNames), 1);

    for i = 1:numel(hyperparameterNames)
        valueSets{i} = searchGrid.(hyperparameterNames{i});
    end
    
    T = combinations(valueSets{:});
    numCombinations = height(T);

    % -- Preallocate and populate struct array -- 
    candidateHyperparameterSets = repmat(template, numCombinations, 1);

    for i = 1 : numCombinations
        currentGrid = template;
        for j = 1 : numel(hyperparameterNames)
            currentGrid.(hyperparameterNames{j}) = T{i,j};
        end
        candidateHyperparameterSets(i) = currentGrid;
    end

    % -- Build output iterable -- 
    hyperparameterIterable = struct();
    hyperparameterIterable.hyperparameterNames = hyperparameterNames;
    hyperparameterIterable.numCombinations = numCombinations;
    hyperparameterIterable.candidateHyperparameterSets = candidateHyperparameterSets;
    
end