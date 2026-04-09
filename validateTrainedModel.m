function validateTrainedModel(trainedModel)
    % VALIDATETRAINEDMODEL Validates standardized trained model wrapper.
    %
    % INPUTS
    %  trainedModel struct with fields
    %      .model (struct)             - trained model
    %      .modelName (string)         - model type to be trained
    %      .taskType (string)          - 'classification' or 'regression'
    %      .hyperparameters (struct)   - hyperparameters used in training

    % -- Validate structure of trainedModel --
    if ~isstruct(trainedModel)
        error('validateTrainedModel:InvalidType', ...
            'trainedModel must be a struct.');
    end

    if ~isfield(trainedModel, 'model')
        error('validateTrainedModel:MissingField', ...
            'trainedModel must have a ''model'' field.');
    end

    if ~isfield(trainedModel, 'modelName')
        error('validateTrainedModel:MissingField', ...
            'trainedModel must have a ''modelName'' field.');
    end

    if ~isfield(trainedModel, 'taskType')
        error('validateTrainedModel:MissingField', ...
            'trainedModel must have a ''taskType'' field.');
    end

    if ~isfield(trainedModel, 'hyperparameters')
        error('validateTrainedModel:MissingField', ...
            'trainedModel must have a ''hyperparameters'' field.');
    end

    % -- Validate modelName --
    if ~(ischar(trainedModel.modelName) || ...
            (isstring(trainedModel.modelName) && isscalar(trainedModel.modelName)))
        error('validateTrainedModel:InvalidModelNameType', ...
            'trainedModel.modelName must be a character vector or string scalar.');
    end
    modelName = char(trainedModel.modelName);

    % -- Validate taskType --
    if ~(ischar(trainedModel.taskType) || ...
            (isstring(trainedModel.taskType) && isscalar(trainedModel.taskType)))
        error('validateTrainedModel:InvalidTaskTypeType', ...
            'trainedModel.taskType must be a character vector or string scalar.');
    end
    taskType = char(trainedModel.taskType);

    if ~ismember(taskType, {'classification', 'regression'})
        error('validateTrainedModel:InvalidTaskType', ...
            'trainedModel.taskType must be ''classification'' or ''regression''.');
    end

    % -- Validate hyperparameters --
    if ~isstruct(trainedModel.hyperparameters)
        error('validateTrainedModel:InvalidHyperparameterType', ...
            'trainedModel.hyperparameters must be a struct.');
    end

    % -- Validate inner model container --
    if ~isstruct(trainedModel.model)
        error('validateTrainedModel:InvalidInnerModelType', ...
            'trainedModel.model must be a struct.');
    end

    % -- Validate consistency between modelName and taskType --
    switch modelName
        case {'logisticRegression', 'kernelSVM', 'randomForest', ...
              'gradientBoostingClassifier', 'naiveBayes', 'kNN'}
            expectedTaskType = 'classification';

        case {'gradientBoostingRegression', 'ridgeRegression'}
            expectedTaskType = 'regression';

        otherwise
            error('validateTrainedModel:UnsupportedModelName', ...
                'Unsupported model name: %s', modelName);
    end

    assert(strcmp(taskType, expectedTaskType), ...
        'validateTrainedModel:TaskTypeMismatch', ...
        'trainedModel.taskType is inconsistent with trainedModel.modelName.');

    % -- Validate inner model fields according to model family --
    switch modelName
        case 'logisticRegression'
            requiredInnerFields = {'modelObject', 'classLabels', 'numClasses'};

        case 'kernelSVM'
            requiredInnerFields = {};

        case 'randomForest'
            requiredInnerFields = {};

        case 'gradientBoostingClassifier'
            requiredInnerFields = {};

        case 'gradientBoostingRegression'
            requiredInnerFields = {};

        case 'naiveBayes'
            requiredInnerFields = {};

        case 'ridgeRegression'
            requiredInnerFields = {'coeff', 'bias', 'lambda'};

        case 'kNN'
            requiredInnerFields = {'Xtrain', 'ytrain', 'k'};

        otherwise
            requiredInnerFields = {};
    end

    for i = 1:numel(requiredInnerFields)
        currentField = requiredInnerFields{i};
        if ~isfield(trainedModel.model, currentField)
            error('validateTrainedModel:MissingInnerModelField', ...
                'trainedModel.model must have a ''%s'' field for model %s.', ...
                currentField, modelName);
        end
    end

    % -- Validate selected model-specific semantics --
    switch modelName
        case 'logisticRegression'
            validateattributes(trainedModel.model.classLabels, {'double'}, ...
                {'vector', 'real', 'nonempty', 'finite'}, ...
                mfilename, 'trainedModel.model.classLabels');

            validateattributes(trainedModel.model.numClasses, {'numeric'}, ...
                {'scalar', 'real', 'finite', 'positive', 'integer'}, ...
                mfilename, 'trainedModel.model.numClasses');

            assert(numel(trainedModel.model.classLabels) == trainedModel.model.numClasses, ...
                'validateTrainedModel:InvalidNumClasses', ...
                'trainedModel.model.numClasses must equal numel(trainedModel.model.classLabels).');

        case 'ridgeRegression'
            validateattributes(trainedModel.model.coeff, {'double'}, ...
                {'vector', 'real', 'nonempty', 'finite'}, ...
                mfilename, 'trainedModel.model.coeff');

            validateattributes(trainedModel.model.bias, {'double'}, ...
                {'scalar', 'real', 'finite'}, ...
                mfilename, 'trainedModel.model.bias');

            validateattributes(trainedModel.model.lambda, {'double'}, ...
                {'scalar', 'real', 'finite', 'nonnegative'}, ...
                mfilename, 'trainedModel.model.lambda');

            if isfield(trainedModel.hyperparameters, 'lambda')
                assert(trainedModel.model.lambda == trainedModel.hyperparameters.lambda, ...
                    'validateTrainedModel:LambdaMismatch', ...
                    'trainedModel.model.lambda must equal trainedModel.hyperparameters.lambda.');
            end

        case 'kNN'
            validateattributes(trainedModel.model.Xtrain, {'double'}, ...
                {'2d', 'real', 'nonempty', 'finite'}, ...
                mfilename, 'trainedModel.model.Xtrain');

            validateattributes(trainedModel.model.ytrain, {'double'}, ...
                {'vector', 'real', 'nonempty', 'finite'}, ...
                mfilename, 'trainedModel.model.ytrain');

            validateattributes(trainedModel.model.k, {'numeric'}, ...
                {'scalar', 'real', 'finite', 'positive', 'integer'}, ...
                mfilename, 'trainedModel.model.k');

            assert(size(trainedModel.model.Xtrain, 1) == numel(trainedModel.model.ytrain), ...
                'validateTrainedModel:DimensionMismatch', ...
                'trainedModel.model.Xtrain and trainedModel.model.ytrain must have compatible dimensions.');

            if isfield(trainedModel.hyperparameters, 'k')
                assert(trainedModel.model.k == trainedModel.hyperparameters.k, ...
                    'validateTrainedModel:KMismatch', ...
                    'trainedModel.model.k must equal trainedModel.hyperparameters.k.');
            end
    end
end