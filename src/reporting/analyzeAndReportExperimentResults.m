function analyzeAndReportExperimentResults(runReports)
    %
    %
    % AUTHOR: Cole H. Shaigec

    % Tasks of this utility
    % GAME PLAN HAS CHANGED!
    % NO POLICY ANALYSIS HERE!
    % - Drop plotting
    % - Don't worry about best runs, let Excel handle it
    % - Don't worry about plotting, let Excel handle it
    % - Run policy analysis FOR ALL RUNS
    % - Policy analysis utility has been written at run level; make it so!
    % 1. Build summary table of all run results
    % 2. Choose best runs according to some criterion
    % 3. Compute more elaborate suite of metrics and visualize results for
    % best models/runs
    % 4. Run policy analysis

    % NOTE TO SELF: Preliminary reading suggests that MATLAB tables support
    % SQL-like query logic, which is probably the key to choosing the best
    % models

    % -- Build summary table --
    summaryTable = buildExperimentSummaryTable(runReports);
    writeSummaryTableToFile(summaryTable, getCSVOutFileName());    
end