function policyMetrics = computePolicyMetrics(policyOutcomes)
    % COMPUTEPOLICYMETRICS Computes KPIs from policy outcomes.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  policyOutcomes struct with fields
    %      .timelyMaintenance (n x 1 logical)
    %      .prematureMaintenance (n x 1 logical)
    %      .missedFailure (n x 1 logical)
    %      .correctDeferment (n x 1 logical)
    %
    % OUTPUTS
    %  policyMetrics struct with fields
    %      .totalNumEngines (nonnegative integer)
    %      .totalMaintenanceJobs (nonnegative integer)
    %      .numPrematureMaintenanceJobs (nonnegative integer)
    %      .numTimelyMaintenanceJobs (nonnegative integer)
    %      .numMissedFailures (nonnegative integer)
    %      .numCorrectDeferments (nonnegative integer)

    % -- Compute metrics --
    numTimelyMaintenanceJobs = sum(policyOutcomes.timelyMaintenance);
    numPrematureMaintenanceJobs = sum(policyOutcomes.prematureMaintenance);
    totalMaintenanceJobs = numTimelyMaintenanceJobs + numPrematureMaintenanceJobs;
    numMissedFailures = sum(policyOutcomes.missedFailure);
    numCorrectDeferments = sum(policyOutcomes.correctDeferment);

    % -- Populate output struct --
    policyMetrics = struct();
    policyMetrics.totalNumEngines = numel(policyOutcomes.timelyMaintenance);
    policyMetrics.totalMaintenanceJobs = totalMaintenanceJobs;
    policyMetrics.numPrematureMaintenanceJobs = numPrematureMaintenanceJobs;
    policyMetrics.numTimelyMaintenanceJobs = numTimelyMaintenanceJobs;
    policyMetrics.numMissedFailures = numMissedFailures;
    policyMetrics.numCorrectDeferments = numCorrectDeferments;
end