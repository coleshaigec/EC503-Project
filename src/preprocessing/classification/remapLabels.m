function yRemapped = remapLabels(yOriginal, warningHorizon)
    % REMAPLABELS Maps RUL labels in raw dataset to binary failure-within-horizon labels.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  yOriginal (n x 1 double)           - vector of original labels
    %  warningHorizon (positive integer)  - TTF threshold
    %
    % OUTPUTS
    %  yRemapped (n x 1 double)           - vector of remapped labels
    %
    % NOTES
    %  If the RUL in y is less than or equal to the warningHorizon, the
    %  sample is mapped to +1. Otherwise, it is mapped to -1.

    n = numel(yOriginal);

    % -- Remap labels to appropriate bins --
    yRemapped = ones(n, 1);
    yRemapped(yOriginal > warningHorizon) = -1;
end