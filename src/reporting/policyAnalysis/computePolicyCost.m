function policyCostResult = computePolicyCost(policyMetrics, costModel)
    % COMPUTEPOLICYCOST Determine the cost of the policy induced by model predictions.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  policyMetrics struct with fields
    %      .totalNumEngines (nonnegative integer)
    %      .totalMaintenanceJobs (nonnegative integer)
    %      .numPrematureMaintenanceJobs (nonnegative integer)
    %      .numTimelyMaintenanceJobs (nonnegative integer)
    %      .numMissedFailures (nonnegative integer)
    %      .numCorrectDeferments (nonnegative integer)
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

    totalDirectMaintenanceCost = costModel.directMaintenanceCost * policyMetrics.totalMaintenanceJobs;
    totalFailureCost = costModel.failureCost * policyMetrics.numMissedFailures;

    


end