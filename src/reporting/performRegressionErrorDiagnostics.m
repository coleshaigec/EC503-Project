function regressionErrorDiagnostics = performRegressionErrorDiagnostics(yHat, yTrue, warningHorizon)
    % PERFORMREGRESSIONERRORDIAGNOSTICS Extracts decision-relevant regression error diagnostics.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)                - predicted RUL values
    %  yTrue (n x 1 double)               - true RUL values
    %  warningHorizon (positive integer)  - TTF threshold used for warning analysis
    %
    % OUTPUTS
    %  regressionErrorDiagnostics struct with fields
    %      .residuals (n x 1 double)                  - prediction residuals yHat - yTrue
    %      .lateErrors (numLateErrors x 1 double)     - residuals corresponding to late predictions
    %      .earlyErrors (numEarlyErrors x 1 double)   - residuals corresponding to early predictions
    %      .dangerousMissMask (n x 1 logical)         - true where yTrue <= warningHorizon and yHat > warningHorizon
    %      .prematureWarningMask (n x 1 logical)      - true where yTrue > warningHorizon and yHat <= warningHorizon
    %      .rulsForDangerousMisses (numDangerousMisses x 1 double)
    %      .rulsForPrematureWarnings (numPrematureWarnings x 1 double)
    %      .numDangerousMisses (double)
    %      .numPrematureWarnings (double)
    %
    % NOTES
    %  Positive residuals indicate late predictions: predicted RUL exceeds true RUL.
    %  Negative residuals indicate early predictions: predicted RUL is less than true RUL.

    residuals = yHat - yTrue;

    dangerousMissMask = (yTrue <= warningHorizon) & (yHat > warningHorizon);
    prematureWarningMask = (yTrue > warningHorizon) & (yHat <= warningHorizon);

    regressionErrorDiagnostics.residuals = residuals;
    regressionErrorDiagnostics.lateErrors = residuals(residuals > 0);
    regressionErrorDiagnostics.earlyErrors = residuals(residuals < 0);

    regressionErrorDiagnostics.dangerousMissMask = dangerousMissMask;
    regressionErrorDiagnostics.prematureWarningMask = prematureWarningMask;

    regressionErrorDiagnostics.rulsForDangerousMisses = yTrue(dangerousMissMask);
    regressionErrorDiagnostics.rulsForPrematureWarnings = yTrue(prematureWarningMask);

    regressionErrorDiagnostics.numDangerousMisses = sum(dangerousMissMask);
    regressionErrorDiagnostics.numPrematureWarnings = sum(prematureWarningMask);
end