function templateModelSpec = buildTemplateModelSpecStruct()
    % BUILDTEMPLATEMODELSPECSTRUCT Builds template modelSpec struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateModelSpec struct with fields
    %      .modelName (string)            - model type to be trained
    %      .hyperparameterGrid (struct)   - hyperparameter search grid for training

    templateModelSpec = struct( ...
        'modelName', "", ...
        'hyperparameterGrid', [] ...
    );
end