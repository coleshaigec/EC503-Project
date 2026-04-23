function policyCostResult = computePolicyCost(policyOutcomes, costModel)
    % COMPUTEPOLICYCOST Determine the cost of the policy induced by model predictions.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  policyOutcomes struct with fields
    %      .timelyMaintenance (n x 1 logical)
    %      .prematureMaintenance (n x 1 logical)
    %      .missedFailure (n x 1 logical)
    %      .correctDeferment (n x 1 logical)
    %
    %  costModel struct with fields
    %      .name (string)
    %      .directMaintenanceCost (positive double) - cost of performing maintenance
    %      .failureCost (positive double) - cost of engine failure
    %      .alphaRUL (positive double) - scaling factor to price residual
    %          life wasted by premature maintenance
    %
    % OUTPUTS
    %  policyCostResult struct with fields
    %      .totalDirectMaintenanceCost (double)
    %      .totalFailureCost (double)
    %      .totalPrematureMaintenanceCost (double)
    %      .totalPolicyCost (double)

    totalEnginesWithMaintenance = sum(policyOutcomes.timelyMaintenance) + sum(policyOutcomes.prematureMaintenance);
    totalDirectMaintenanceCost = 


end