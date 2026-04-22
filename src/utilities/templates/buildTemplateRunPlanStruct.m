function templateRunPlanStruct = buildTemplateRunPlanStruct()
    % BUILDTEMPLATERUNPLANSTRUCT Builds template runPlan struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateRunPlan struct with fields
    %      .runNumber
    %      .windowSize
    %      .pcaSpec
    %      .cmapssSubset
    %      .warningHorizon
    %      .numFolds

    templateRunPlanStruct = struct();
    templateRunPlanStruct.runNumber = [];
    templateRunPlanStruct.windowSize = [];
    templateRunPlanStruct.pcaSpec = [];
    templateRunPlanStruct.modelSpec = [];
    templateRunPlanStruct.cmapssSubset = [];
    templateRunPlanStruct.warningHorizon = [];
    templateRunPlanStruct.numFolds = [];
end

   