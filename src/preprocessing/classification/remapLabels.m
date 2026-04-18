function yRemapped = remapLabels(yOriginal, warningHorizons)
    % REMAPLABELS Maps RUL labels in raw dataset to specified failure hazard bins to facilitate classification learning
    %
    % INPUTS
    %  yOriginal (n x 1 double)         - vector of original labels
    %  warningHorizons (m x 1 double)   - upper limits for warning horizon bins
    %
    % OUTPUTS
    %  yRemapped (n x 1 double)         - vector of remapped labels

    % -- Validate warning horizons --
    WARNING_HORIZON_ATTRIBUTES = {'vector', 'real', 'nonempty', 'finite', 'double', 'positive'};
    warningHorizons = sort(unique(warningHorizons), 'ascend');
    validateattributes(warningHorizons, {'numeric'}, WARNING_HORIZON_ATTRIBUTES, ...
        mfilename, 'warningHorizons');

    m = numel(warningHorizons);
    n = numel(yOriginal);

    % -- Remap labels to appropriate bins --
    yRemapped = ones(n, 1);

    for i = 1:m
        yRemapped(yOriginal > warningHorizons(i)) = i + 1;
    end
end