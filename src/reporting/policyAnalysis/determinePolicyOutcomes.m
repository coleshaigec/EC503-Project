function policyOutcomes = determinePolicyOutcomes(policy, yTrue, warningHorizon)
    % DETERMINEPOLICYOUTCOMES Determines outcomes of an induced maintenance policy.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  policy (n x 1 logical)              - 1 if maintenance is triggered, 0 otherwise
    %  yTrue (n x 1 double)                - true RUL values
    %  warningHorizon (positive integer)   - TTF threshold defining the danger zone
    %
    % OUTPUTS
    %  policyOutcomes struct with fields
    %      .timelyMaintenance (n x 1 logical)
    %      .prematureMaintenance (n x 1 logical)
    %      .missedFailure (n x 1 logical)
    %      .correctDeferment (n x 1 logical)
    %
    % NOTES
    % - There are four possible outcomes at the engine level:
    %   1. timelyMaintenance: True RUL <= warningHorizon AND policy = 1
    %   2. prematureMaintenance: True RUL > warningHorizon AND policy = 1
    %   3. missedFailure: True RUL <= warningHorizon AND policy = 0
    %   4. correctDeferment: True RUL > warningHorizon AND policy = 0

    actualPositives = yTrue <= warningHorizon;
    actualNegatives = yTrue > warningHorizon;

    maintenanceTriggered = policy == 1;
    maintenanceDeferred = policy == 0;

    policyOutcomes = struct();
    policyOutcomes.timelyMaintenance = maintenanceTriggered & actualPositives;
    policyOutcomes.prematureMaintenance = maintenanceTriggered & actualNegatives;
    policyOutcomes.missedFailure = maintenanceDeferred & actualPositives;
    policyOutcomes.correctDeferment = maintenanceDeferred & actualNegatives;
end