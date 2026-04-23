function costModel = buildCostModelForPolicyAnalysis()
    % BUILDCOSTMODELFORPOLICYANALYSIS Constructs cost model for policy analysis.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  costModel struct with fields
    %      .name (string)
    %      .directMaintenanceCost (positive double) - cost of performing maintenance
    %      .failureCost (positive double) - cost of engine failure
    %      .alphaRUL (positive double) - scaling factor to price residual
    %          life wasted by premature maintenance
    %
    % NOTES
    % - This utility is used by downstream cost computation operations.
    % Values hard-coded here may be changed to explore the sensitivity of
    % key policy results to changes in underlying economics. 
    % - By the construction of the cost model, it is expected that the cost
    % of an engine failure significantly exceeds the costs of maintenance
    % and wasted residual life. Failure to respect this construction may
    % meaningfully distort the outputs of policy analysis.
    % - This model defines costs in an "engineering economics" sense rather
    % than an accounting sense. The numbers coded here have no meaningful
    % pecuniary interpretation.

    costModel = struct();
    costModel.name = "baseline"; % change this if you want to create scenarios & track across runs
    costModel.directMaintenanceCost = 10;
    costModel.failureCost = 100;
    costModel.alphaRUL = 1.5; % cost per lost operating cycle
end