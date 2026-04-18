function analyzeBestRuns(bestRuns)
    % ANALYZEBESTRUNS Executes full analysis of best runs of pipeline.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  bestRuns struct with fields
    %      .classification table
    %          Top classification runs ranked by
    %          0.75 * testF1 + 0.25 * testAccuracy, descending.
    %          Empty table if no valid classification runs exist.
    %
    %      .regression table
    %          Top regression runs ranked by testRMSE, ascending.
    %          Empty table if no valid regression runs exist.
    %
    % SIDE EFFECTS
    %  experimentReport
end