function policyAnalysisResult = runPolicyAnalysis(yHat, trueRUL, warningHorizon, taskType)
    % RUNPOLICYANALYSIS Runs end-to-end policy analysis workflow. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double) - predicted labels (classification) or RUL estimates (regression)
    %  
    %  trueRUL (n x 1 double) - true RUL for each engine
    %  
    %  warningHorizon (positive integer) - TTF decision threshold
    %  
    %  taskType (string) - 'classification' or 'regression'
    %
    % OUTPUTS
    %  policyAnalysisResult struct with fields
    %      .costModel struct with fields
    %          .name (string)
    %          .directMaintenanceCost (positive double) - cost of performing maintenance
    %          .failureCost (positive double) - cost of engine failure
    %          .alphaRUL (positive double) - scaling factor to price residual
    %          life wasted by premature maintenance
    %      .policyMetrics struct with fields
    %          .totalNumEngines (nonnegative integer)
    %          .totalMaintenanceJobs (nonnegative integer)
    %          .numPrematureMaintenanceJobs (nonnegative integer)
    %          .numTimelyMaintenanceJobs (nonnegative integer)
    %          .numMissedFailures (nonnegative integer)
    %          .numCorrectDeferments (nonnegative integer)
    %          .lostRULFromPrematureMaintenance (nonnegative integer)
    %      .policyCosts struct with fields
    %          .totalDirectMaintenanceCost (double)
    %          .totalFailureCost (double)
    %          .totalPrematureMaintenanceCost (double)
    %          .totalPolicyCost (double)   


    % -- Build policy from predictions and determine outcomes --    
    policy = getPolicyFromPredictions(yHat, warningHorizon, taskType);
    policyOutcomes = determinePolicyOutcomes(policy, trueRUL, warningHorizon);

    % -- Compute policy metrics --
    policyMetrics = computePolicyMetrics(policyOutcomes, warningHorizon, trueRUL);

    % -- Build cost model and compute overall policy cost --
    costModel = buildCostModelForPolicyAnalysis();
    policyCostResult = computePolicyCost(policyMetrics, costModel);
    
    % -- Populate output struct --
    policyAnalysisResult = struct();
    policyAnalysisResult.costModel = costModel;
    policyAnalysisResult.policyMetrics = policyMetrics;
    policyAnalysisResult.policyCosts = policyCostResult;


end