function MAE = computeMAE(yHat, yTrue)
    % COMPUTEMAE Computes mean absolute error of regression predictions.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS 
    %  yHat (n x 1 double)   - predicted RUL values
    %  yTrue (n x 1 double)  - true RUL values
    %
    % OUTPUT
    %  MAE (double)          - mean absolute error
    
    yHat  = yHat(:);
    yTrue = yTrue(:);
    
    MAE = mean(abs(yHat - yTrue));
end