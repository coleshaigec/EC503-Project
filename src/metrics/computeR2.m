function R2 = computeR2(yHat, yTrue)
    % COMPUTER2 Computes coefficient of determination (R^2) for regression.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)   - predicted RUL values
    %  yTrue (n x 1 double)  - true RUL values
    %
    % OUTPUT
    %  R2 (double)           - coefficient of determination

    % -- Residual sum of squares --
    SS_res = sum((yTrue - yHat).^2);

    % -- Total sum of squares --
    yMean = mean(yTrue);
    SS_tot = sum((yTrue - yMean).^2);

    % -- Handle degenerate case --
    if SS_tot == 0
        R2 = 0;
        return;
    end

    % -- Compute R^2 --
    R2 = 1 - (SS_res / SS_tot);
end