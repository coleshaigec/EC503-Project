function accuracy = computeAccuracy(yHat, yTrue)
    % COMPUTEACCURACY Computes accuracy for a trained classification model.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS 
    %  yHat (n x 1 double)   - predicted labels
    %  yTrue (n x 1 double)  - true labels
    %
    % OUTPUTS
    %  accuracy (double)     - total correct / total predicted

    accuracy = mean(yHat == yTrue);
end