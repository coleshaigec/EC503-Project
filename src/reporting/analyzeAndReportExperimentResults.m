function analyzeAndReportExperimentResults()
    %
    %

    % Tasks of this utility
    % 1. Build summary table of all run results
    % 2. Choose best runs according to some criterion
    % 3. Compute more elaborate suite of metrics and visualize results for
    % best models/runs
    % 4. Run policy analysis

    % NOTE TO SELF: Preliminary reading suggests that MATLAB tables support
    % SQL-like query logic, which is probably the key to choosing the best
    % models

    % -- Build summary table --
    summaryTable = buildExperimentSummaryTable();
    
end