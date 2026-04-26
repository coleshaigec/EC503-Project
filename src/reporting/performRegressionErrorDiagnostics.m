function regressionErrorDiagnostics = performRegressionErrorDiagnostics(yHat, trueRULs, warningHorizon)
    % PERFORMREGRESSIONERRORDIAGNOSTICS Extracts decision-relevant regression error diagnostics.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)               - predicted RUL values
    %  trueRULs (n x 1 double)           - true RUL values
    %  warningHorizon (positive integer) - TTF threshold used for warning analysis
    %
    % OUTPUTS
    %  regressionErrorDiagnostics struct with fields
    %      .numPrematureWarnings (nonnegative integer)
    %      .meanPrematureWarningRUL (double)
    %      .minPrematureWarningRUL (double)
    %      .maxPrematureWarningRUL (double)
    %      .sumPrematureWarningRULs (double)
    %      .numDangerousMisses (nonnegative integer)
    %      .meanDangerousMissRUL (double)
    %      .minDangerousMissRUL (double)
    %      .maxDangerousMissRUL (double)
    %      .sumDangerousMissRULs (double)
    %
    % NOTES
    %  - A premature warning occurs when true RUL is outside the warning
    %    horizon, but predicted RUL is inside the warning horizon.
    %  - A dangerous miss occurs when true RUL is inside the warning
    %    horizon, but predicted RUL is outside the warning horizon.

    % -- Validate inputs --
    assert(iscolumn(yHat), 'yHat must be a column vector.');
    assert(iscolumn(trueRULs), 'trueRULs must be a column vector.');
    assert(numel(yHat) == numel(trueRULs), ...
        'yHat and trueRULs must have the same number of elements.');
    assert(isnumeric(yHat) && all(isfinite(yHat)), ...
        'yHat must contain finite numeric values.');
    assert(isnumeric(trueRULs) && all(isfinite(trueRULs)) && all(trueRULs >= 0), ...
        'trueRULs must contain finite nonnegative numeric values.');
    assert(isscalar(warningHorizon) && isnumeric(warningHorizon) && ...
        isfinite(warningHorizon) && warningHorizon > 0 && ...
        warningHorizon == floor(warningHorizon), ...
        'warningHorizon must be a positive integer scalar.');

    % -- Compute decision-error masks --
    dangerousMissMask = (trueRULs <= warningHorizon) & (yHat > warningHorizon);
    prematureWarningMask = (trueRULs > warningHorizon) & (yHat <= warningHorizon);

    % -- Extract true RULs associated with each decision-error type --
    dangerousMissRULs = trueRULs(dangerousMissMask);
    prematureWarningRULs = trueRULs(prematureWarningMask);

    % -- Summarize premature warnings --
    prematureWarningSummary = summarizeRULDiagnostics(prematureWarningRULs);

    % -- Summarize dangerous misses --
    dangerousMissSummary = summarizeRULDiagnostics(dangerousMissRULs);

    % -- Populate output struct --
    regressionErrorDiagnostics = struct();

    regressionErrorDiagnostics.numPrematureWarnings = prematureWarningSummary.numSamples;
    regressionErrorDiagnostics.meanPrematureWarningRUL = prematureWarningSummary.meanRUL;
    regressionErrorDiagnostics.minPrematureWarningRUL = prematureWarningSummary.minRUL;
    regressionErrorDiagnostics.maxPrematureWarningRUL = prematureWarningSummary.maxRUL;
    regressionErrorDiagnostics.sumPrematureWarningRULs = prematureWarningSummary.sumRULs;

    regressionErrorDiagnostics.numDangerousMisses = dangerousMissSummary.numSamples;
    regressionErrorDiagnostics.meanDangerousMissRUL = dangerousMissSummary.meanRUL;
    regressionErrorDiagnostics.minDangerousMissRUL = dangerousMissSummary.minRUL;
    regressionErrorDiagnostics.maxDangerousMissRUL = dangerousMissSummary.maxRUL;
    regressionErrorDiagnostics.sumDangerousMissRULs = dangerousMissSummary.sumRULs;
end

function rulDiagnostics = summarizeRULDiagnostics(ruls)
    % SUMMARIZERULDIAGNOSTICS Computes scalar summary statistics for RUL vector.

    assert(iscolumn(ruls), 'ruls must be a column vector.');

    rulDiagnostics = struct();
    rulDiagnostics.numSamples = numel(ruls);

    if isempty(ruls)
        rulDiagnostics.meanRUL = NaN;
        rulDiagnostics.minRUL = NaN;
        rulDiagnostics.maxRUL = NaN;
        rulDiagnostics.sumRULs = 0;
        return;
    end

    rulDiagnostics.meanRUL = mean(ruls);
    rulDiagnostics.minRUL = min(ruls);
    rulDiagnostics.maxRUL = max(ruls);
    rulDiagnostics.sumRULs = sum(ruls);
end