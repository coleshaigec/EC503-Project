function validateHyperparameterSearchGrid(searchGrid, modelName)
    % VALIDATEHYPERPARAMETERSEARCHGRID Validates hyperparameter tuning search grid.
    %
    % INPUTS
    %  searchGrid (struct) - set of candidate hyperparameter values
    %  modelName (string)  - name of model to be tuned

    % -- Validate modelName type --
    if ~(ischar(modelName) || (isstring(modelName) && isscalar(modelName)))
        error('validateHyperparameterSearchGrid:InvalidModelNameType', ...
            'modelName must be a character vector or string scalar.');
    end
    modelName = char(modelName);

    % -- Validate searchGrid type --
    if ~isstruct(searchGrid)
        error('validateHyperparameterSearchGrid:InvalidType', ...
            'searchGrid must be a struct.');
    end

    % -- Validate searchGrid is nonempty --
    searchGridFieldNames = fieldnames(searchGrid);
    if isempty(searchGridFieldNames)
        error('validateHyperparameterSearchGrid:EmptyGrid', ...
            'searchGrid must contain at least one hyperparameter field.');
    end

    % -- Validate model-specific hyperparameter field names --
    switch modelName
        case 'kNN'
            expectedFieldNames = {'k'};
        case 'ridgeRegression'
            expectedFieldNames = {'lambda'};
        case 'naiveBayes'
            expectedFieldNames = {'varianceSmoothing'};
        otherwise
            error('validateHyperparameterSearchGrid:UnsupportedModel', ...
                'Unsupported model name: %s', modelName);
    end

    if numel(searchGridFieldNames) ~= numel(expectedFieldNames)
        error('validateHyperparameterSearchGrid:UnexpectedNumberOfFields', ...
            'searchGrid has incorrect number of fields for model %s.', modelName);
    end

    hasExpectedFields = all(ismember(expectedFieldNames, searchGridFieldNames));
    if ~hasExpectedFields
        error('validateHyperparameterSearchGrid:UnexpectedFieldNames', ...
            'searchGrid contains incorrect field names for model %s.', modelName);
    end

    % -- Validate candidate values in each field --
    for i = 1:numel(searchGridFieldNames)
        currentFieldName = searchGridFieldNames{i};
        currentValues = searchGrid.(currentFieldName);

        % Field must be nonempty and iterable
        if isempty(currentValues)
            error('validateHyperparameterSearchGrid:EmptyCandidateSet', ...
                'searchGrid.%s must contain at least one candidate value.', currentFieldName);
        end

        isValidIterable = isnumeric(currentValues) || islogical(currentValues) || ...
            iscell(currentValues) || isstring(currentValues) || ischar(currentValues);

        if ~isValidIterable
            error('validateHyperparameterSearchGrid:InvalidCandidateType', ...
                'searchGrid.%s must be numeric, logical, cell, character vector, or string array.', ...
                currentFieldName);
        end

        % Character vectors are ambiguous; require string scalar or cell array instead
        if ischar(currentValues)
            error('validateHyperparameterSearchGrid:InvalidCharacterVector', ...
                ['searchGrid.%s is a character vector. For string-valued hyperparameters, ', ...
                 'use a string array or cell array instead.'], currentFieldName);
        end

        % Model-specific validation of candidate values
        switch currentFieldName
            case 'k'
                validateattributes(currentValues, {'numeric'}, ...
                    {'vector', 'real', 'finite', 'positive', 'integer', 'nonempty'}, ...
                    mfilename, ['searchGrid.' currentFieldName]);

            case 'lambda'
                validateattributes(currentValues, {'numeric'}, ...
                    {'vector', 'real', 'finite', 'nonnegative', 'nonempty'}, ...
                    mfilename, ['searchGrid.' currentFieldName]);

            case 'maxIter'
                validateattributes(currentValues, {'numeric'}, ...
                    {'vector', 'real', 'finite', 'positive', 'integer', 'nonempty'}, ...
                    mfilename, ['searchGrid.' currentFieldName]);

            case 'solver'
                if isstring(currentValues)
                    assert(all(strlength(currentValues) > 0), ...
                        'searchGrid.solver must not contain empty strings.');
                    solverValues = cellstr(currentValues);
                elseif iscell(currentValues)
                    assert(all(cellfun(@(x) ischar(x) || (isstring(x) && isscalar(x)), currentValues)), ...
                        'searchGrid.solver must contain only character vectors or string scalars.');
                    solverValues = cellfun(@char, currentValues, 'UniformOutput', false);
                else
                    error('validateHyperparameterSearchGrid:InvalidSolverType', ...
                        'searchGrid.solver must be a string array or cell array of strings.');
                end

                validSolvers = {'sgd', 'asgd', 'dual', 'lbfgs', 'sparsa'};
                if ~all(ismember(solverValues, validSolvers))
                    error('validateHyperparameterSearchGrid:InvalidSolverValue', ...
                        'searchGrid.solver contains one or more invalid solver names.');
                end
        end
    end
end