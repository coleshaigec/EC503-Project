function templateTuningResultStruct = buildTemplateTuningResultStruct()
    % BUILDTEMPLATETUNINGRESULTSTRUCT Builds template tuningResult struct for preallocation.
    % 
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateTuningResultstruct struct with fields
    %      .modelName
    %      .taskType
    %      .bestModel
    %      .bestHyperparameters
    %      .bestRunScore 
    %      .allRunRecords
    %      .searchGrid 
    %      .numRuns 

    templateTuningResultStruct = struct();
    templateTuningResultStruct.modelName = [];
    templateTuningResultStruct.taskType = [];
    templateTuningResultStruct.bestModel = [];
    templateTuningResultStruct.bestHyperparameters = [];
    templateTuningResultStruct.bestRunScore = [];
    templateTuningResultStruct.allRunRecords = [];
    templateTuningResultStruct.searchGrid = [];
    templateTuningResultStruct.numRuns = [];
end