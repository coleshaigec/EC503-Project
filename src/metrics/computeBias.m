function bias = computeBias(yHat, yTrue)
    % COMPUTEBIAS Computes bias for regression.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yHat (n x 1 double)   - predicted RUL values
    %  yTrue (n x 1 double)  - true RUL values
    %
    % OUTPUT
    %  bias (double)          

    bias = mean(yHat - yTrue);
end