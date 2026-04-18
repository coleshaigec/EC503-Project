function validateExperimentSpec(experimentSpec)
    % VALIDATEEXPERIMENTSPEC Validates experiment specification for run-plan construction.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  experimentSpec struct with fields
    %      .modelSpecs
    %      .pcaSpecs
    %      .warningHorizons
    %      .windowSizes
    %      .cmapssSubsets
    %      .numFolds
    %
    % OUTPUT
    %  None. Throws an error if validation fails.

    % -- Top-level type check --
    assert(isstruct(experimentSpec) && isscalar(experimentSpec), ...
        'experimentSpec must be a scalar struct.');

    % -- Required field check --
    requiredFields = { ...
        'modelSpecs', ...
        'pcaSpecs', ...
        'warningHorizons', ...
        'windowSizes', ...
        'cmapssSubsets' ...
    };

    missingFields = requiredFields(~isfield(experimentSpec, requiredFields));
    assert(isempty(missingFields), ...
        'experimentSpec is missing required field(s): %s.', ...
        strjoin(missingFields, ', '));

    % -- Validate windowSizes --
    assert(isnumeric(experimentSpec.windowSizes) && isvector(experimentSpec.windowSizes) ...
        && ~isempty(experimentSpec.windowSizes), ...
        'experimentSpec.windowSizes must be a nonempty numeric vector.');

    assert(all(isfinite(experimentSpec.windowSizes)) ...
        && all(experimentSpec.windowSizes > 0) ...
        && all(mod(experimentSpec.windowSizes, 1) == 0), ...
        'experimentSpec.windowSizes must contain only positive integers.');

    % -- Validate warningHorizons --
    assert(iscell(experimentSpec.warningHorizons) && isvector(experimentSpec.warningHorizons) ...
        && ~isempty(experimentSpec.warningHorizons), ...
        ['experimentSpec.warningHorizons must be a nonempty cell array, ' ...
         'where each cell contains a positive numeric vector.']);

    for i = 1:numel(experimentSpec.warningHorizons)
        currentWarningHorizons = experimentSpec.warningHorizons{i};

        assert(isnumeric(currentWarningHorizons) && isvector(currentWarningHorizons) ...
            && ~isempty(currentWarningHorizons), ...
            ['Each entry of experimentSpec.warningHorizons must be a nonempty ' ...
             'numeric vector. Failed at cell index %d.'], i);

        assert(all(isfinite(currentWarningHorizons)) && all(currentWarningHorizons > 0), ...
            ['Each warning horizon vector must contain only positive finite values. ' ...
             'Failed at cell index %d.'], i);
    end

    % -- Validate cmapssSubsets --
    assert(iscell(experimentSpec.cmapssSubsets) && isvector(experimentSpec.cmapssSubsets) ...
        && ~isempty(experimentSpec.cmapssSubsets), ...
        'experimentSpec.cmapssSubsets must be a nonempty cell array.');

    validSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    for i = 1:numel(experimentSpec.cmapssSubsets)
        currentSubset = experimentSpec.cmapssSubsets{i};

        isValidCharSubset = ischar(currentSubset) && isrow(currentSubset);
        isValidStringSubset = isstring(currentSubset) && isscalar(currentSubset);

        assert(isValidCharSubset || isValidStringSubset, ...
            ['Each entry of experimentSpec.cmapssSubsets must be a char row vector ' ...
             'or string scalar. Failed at cell index %d.'], i);

        currentSubset = char(string(currentSubset));

        assert(any(strcmp(currentSubset, validSubsets)), ...
            ['Invalid CMAPSS subset "%s" at cell index %d. Valid options are: ' ...
             'FD001, FD002, FD003, FD004.'], currentSubset, i);
    end

    % -- Validate pcaSpecs --
    assert(isstruct(experimentSpec.pcaSpecs) && ~isempty(experimentSpec.pcaSpecs), ...
        'experimentSpec.pcaSpecs must be a nonempty struct array.');

    for i = 1:numel(experimentSpec.pcaSpecs)
        validatePCASpec(experimentSpec.pcaSpecs(i), i);
    end

    % -- Validate modelSpecs --
    assert(isstruct(experimentSpec.modelSpecs) && ~isempty(experimentSpec.modelSpecs), ...
        'experimentSpec.modelSpecs must be a nonempty struct array.');

    for i = 1:numel(experimentSpec.modelSpecs)
        validateModelSpec(experimentSpec.modelSpecs(i), i);
    end
end
