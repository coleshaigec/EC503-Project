function templateModelSpec = buildTemplateModelSpecStruct()
    % BUILDTEMPLATEMODELSPECSTRUCT Builds template modelSpec struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateModelSpec struct with fields
    %      .modelName (string)         - model type to be trained
    %      .hyperparameters (struct)   - hyperparameters for use in training

    templateModelSpec = struct( ...
        'modelName', "", ...
        'hyperparameters', [] ...
    );
end