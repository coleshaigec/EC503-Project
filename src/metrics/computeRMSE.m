function RMSE = computeRMSE(yHat, yTrue)
    % COMPUTERMSE Computes RMSE for labels predicted by a trained regression model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)   - predicted labels
    %  yTrue (n x 1 double)  - true labels
    %
    % OUTPUTS
    %  RMSE (double)         - computed RMSE

    % Check for input size mismatch
    assert(numel(yHat) == numel(yTrue), 'predicted and true label vectors must have the same number of elements.')

    % Compute RMSE
    RMSE = rmse(yHat, yTrue, "omitnan");
end