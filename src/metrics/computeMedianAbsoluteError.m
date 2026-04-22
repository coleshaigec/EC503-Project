function medAE = computeMedianAbsoluteError(yHat, yTrue)
    % COMPUTEMEDIANABSOLUTERROR Computes the median absolute error of a set of regression predictions. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)   - predicted RUL values
    %  yTrue (n x 1 double)  - true RUL values
    %
    % OUTPUT
    %  medAE (double)        - median absolute error

    medAE = median(abs(yHat - yTrue));
end