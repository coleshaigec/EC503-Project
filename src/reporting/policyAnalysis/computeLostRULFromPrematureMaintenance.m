function lostRUL = computeLostRULFromPrematureMaintenance(trueRUL, policyOutcomes, warningHorizon)
    % COMPUTELOSTRULFROMPREMATUREMAINTENANCE Aggregates lost RUL due to premature maintenance.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  trueRUL (n x 1 double) - true RUL for each engine
    %
    %  policyOutcomes struct with fields
    %      .timelyMaintenance (n x 1 logical)
    %      .prematureMaintenance (n x 1 logical)
    %      .missedFailure (n x 1 logical)
    %      .correctDeferment (n x 1 logical)
    %
    %  warningHorizon (positive integer) - TTF decision threshold
    %
    % OUTPUT
    %  lostRUL (nonnegative double)

    prematureRUL = trueRUL(policyOutcomes.prematureMaintenance);
    lostRUL = sum(max(prematureRUL - warningHorizon, 0));
end
