function validateRunPlans(runPlans, experimentSpec)
    % VALIDATERUNPLANS Validates run plans produced by buildRunPlansFromExperimentSpec.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % USAGE
    %  validateRunPlans(runPlans)
    %  validateRunPlans(runPlans, experimentSpec)
    %
    % INPUTS
    %  runPlans        struct array of run plans
    %  experimentSpec  (optional) scalar struct used to generate runPlans
    %
    % OUTPUT
    %  None. Throws an error if validation fails.
    %
    % NOTES
    %  If experimentSpec is provided, this function additionally validates:
    %   - expected number of runs
    %   - run-plan values belong to the originating experimentSpec
    %   - no duplicate Cartesian-product rows exist

    narginchk(1, 2);

    % -- Validate runPlans as a standalone artifact --
    validateRunPlansShape(runPlans);

    % -- Optional validation against source experimentSpec --
    if nargin == 2
        validateExperimentSpec(experimentSpec);
        validateRunPlansAgainstExperimentSpec(runPlans, experimentSpec);
    end
end


function validateRunPlansShape(runPlans)
    % VALIDATERUNPLANSSHAPE Validates internal structure and field-level invariants.

    assert(isstruct(runPlans), 'runPlans must be a struct array.');

    requiredFields = { ...
        'runNumber', ...
        'windowSize', ...
        'pcaSpec', ...
        'modelSpec', ...
        'cmapssSubset', ...
        'warningHorizons' ...
    };

    assert(all(isfield(runPlans, requiredFields)), ...
        'runPlans must contain fields: %s.', strjoin(requiredFields, ', '));

    if isempty(runPlans)
        return;
    end

    % Check field schema consistency across struct array
    actualFields = fieldnames(runPlans);
    assert(numel(actualFields) == numel(requiredFields), ...
        'runPlans contains unexpected fields.');

    assert(all(ismember(requiredFields, actualFields)), ...
        'runPlans is missing one or more required fields.');

    numRuns = numel(runPlans);

    % -- Validate runNumber sequence --
    runNumbers = [runPlans.runNumber];
    assert(isnumeric(runNumbers) && isvector(runNumbers), ...
        'All runNumber values must be numeric scalars.');

    assert(all(isfinite(runNumbers)) && all(runNumbers > 0) ...
        && all(mod(runNumbers, 1) == 0), ...
        'All runNumber values must be positive integers.');

    expectedRunNumbers = 1:numRuns;
    assert(isequal(runNumbers, expectedRunNumbers), ...
        'runNumber values must equal 1:numel(runPlans) in order.');

    % -- Validate each run plan entry --
    for i = 1:numRuns
        currentRunPlan = runPlans(i);

        assert(isnumeric(currentRunPlan.windowSize) && isscalar(currentRunPlan.windowSize) ...
            && isfinite(currentRunPlan.windowSize) && currentRunPlan.windowSize > 0 ...
            && mod(currentRunPlan.windowSize, 1) == 0, ...
            'runPlans(%d).windowSize must be a positive integer scalar.', i);

        validateSinglePCASpec(currentRunPlan.pcaSpec, i);
        validateSingleModelSpec(currentRunPlan.modelSpec, i);
        validateSingleCMAPSSSubset(currentRunPlan.cmapssSubset, i);
        validateSingleWarningHorizons(currentRunPlan.warningHorizons, i);
    end
end


function validateRunPlansAgainstExperimentSpec(runPlans, experimentSpec)
    % VALIDATERUNPLANSAGAINSTEXPERIMENTSPEC Validates runPlans against source spec.

    numExpectedRuns = numel(experimentSpec.windowSizes) ...
        * numel(experimentSpec.warningHorizons) ...
        * numel(experimentSpec.pcaSpecs) ...
        * numel(experimentSpec.modelSpecs) ...
        * numel(experimentSpec.cmapssSubsets);

    assert(numel(runPlans) == numExpectedRuns, ...
        'runPlans length mismatch: expected %d runs, but got %d.', ...
        numExpectedRuns, numel(runPlans));


    % Validate each run entry belongs to the source experimentSpec
    numRuns = numel(runPlans);
    signatureKeys = cell(numRuns, 1);

    for i = 1:numRuns
        currentRunPlan = runPlans(i);

        assert(any(currentRunPlan.windowSize == experimentSpec.windowSizes), ...
            'runPlans(%d).windowSize does not belong to experimentSpec.windowSizes.', i);

        assert(any(cellfun(@(subset) isequal(string(currentRunPlan.cmapssSubset), string(subset)), ...
            experimentSpec.cmapssSubsets)), ...
            'runPlans(%d).cmapssSubset does not belong to experimentSpec.cmapssSubsets.', i);

        assert(any(cellfun(@(h) isequal(currentRunPlan.warningHorizons, h), ...
            experimentSpec.warningHorizons)), ...
            ['runPlans(%d).warningHorizons does not belong to ' ...
             'experimentSpec.warningHorizons.'], i);

        assert(any(arrayfun(@(s) isequal(currentRunPlan.pcaSpec, s), experimentSpec.pcaSpecs)), ...
            'runPlans(%d).pcaSpec does not belong to experimentSpec.pcaSpecs.', i);

        assert(any(arrayfun(@(s) isequal(currentRunPlan.modelSpec, s), experimentSpec.modelSpecs)), ...
            'runPlans(%d).modelSpec does not belong to experimentSpec.modelSpecs.', i);

        signatureKeys{i} = buildRunPlanSignature(currentRunPlan);
    end

    % No duplicates allowed
    numUniqueSignatures = numel(unique(signatureKeys));
    assert(numUniqueSignatures == numRuns, ...
        ['runPlans contains duplicate Cartesian-product entries. ' ...
         'Expected all run signatures to be unique.']);
end


function validateSinglePCASpec(pcaSpec, runIndex)
    % VALIDATESINGLEPCASPEC Validates a single PCA spec embedded in a run plan.

    assert(isstruct(pcaSpec) && isscalar(pcaSpec), ...
        'runPlans(%d).pcaSpec must be a scalar struct.', runIndex);

    requiredFields = {'enabled', 'selectionMode', 'varianceThreshold', 'fixedNumComponents'};
    missingFields = requiredFields(~isfield(pcaSpec, requiredFields));

    assert(isempty(missingFields), ...
        'runPlans(%d).pcaSpec is missing field(s): %s.', ...
        runIndex, strjoin(missingFields, ', '));

    assert(islogical(pcaSpec.enabled) && isscalar(pcaSpec.enabled), ...
        'runPlans(%d).pcaSpec.enabled must be a logical scalar.', runIndex);

    selectionMode = string(pcaSpec.selectionMode);
    assert(isscalar(selectionMode), ...
        'runPlans(%d).pcaSpec.selectionMode must be a string scalar or char vector.', runIndex);

    validSelectionModes = ["varianceThreshold", "fixedNumComponents"];
    assert(any(selectionMode == validSelectionModes), ...
        ['runPlans(%d).pcaSpec.selectionMode must be either ' ...
         '"varianceThreshold" or "fixedNumComponents".'], runIndex);

    assert(isnumeric(pcaSpec.varianceThreshold) && isscalar(pcaSpec.varianceThreshold) ...
        && isfinite(pcaSpec.varianceThreshold) ...
        && pcaSpec.varianceThreshold >= 0 && pcaSpec.varianceThreshold <= 1, ...
        'runPlans(%d).pcaSpec.varianceThreshold must be a scalar in [0, 1].', runIndex);

    assert(isnumeric(pcaSpec.fixedNumComponents) && isscalar(pcaSpec.fixedNumComponents) ...
        && isfinite(pcaSpec.fixedNumComponents) ...
        && pcaSpec.fixedNumComponents > 0 ...
        && mod(pcaSpec.fixedNumComponents, 1) == 0, ...
        ['runPlans(%d).pcaSpec.fixedNumComponents must be a positive ' ...
         'integer scalar.'], runIndex);
end

function validateSingleModelSpec(modelSpec, runIndex)
    % VALIDATESINGLEMODELSPEC Validates a single model spec embedded in a run plan.

    assert(isstruct(modelSpec) && isscalar(modelSpec), ...
        'runPlans(%d).modelSpec must be a scalar struct.', runIndex);

    requiredFields = {'modelName', 'hyperparameterGrid'};
    missingFields = requiredFields(~isfield(modelSpec, requiredFields));

    assert(isempty(missingFields), ...
        'runPlans(%d).modelSpec is missing field(s): %s.', ...
        runIndex, strjoin(missingFields, ', '));

    modelName = string(modelSpec.modelName);
    assert(isscalar(modelName) && strlength(modelName) > 0, ...
        'runPlans(%d).modelSpec.modelName must be nonempty.', runIndex);

    assert(isstruct(modelSpec.hyperparameterGrid) && isscalar(modelSpec.hyperparameterGrid), ...
        'runPlans(%d).modelSpec.hyperparameterGrid must be a scalar struct.', runIndex);
end


function validateSingleCMAPSSSubset(cmapssSubset, runIndex)
    % VALIDATESINGLECMAPSSSUBSET Validates a CMAPSS subset value.

    isValidCharSubset = ischar(cmapssSubset) && isrow(cmapssSubset);
    isValidStringSubset = isstring(cmapssSubset) && isscalar(cmapssSubset);

    assert(isValidCharSubset || isValidStringSubset, ...
        ['runPlans(%d).cmapssSubset must be a char row vector ' ...
         'or a string scalar.'], runIndex);

    cmapssSubset = char(string(cmapssSubset));
    validSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    assert(any(strcmp(cmapssSubset, validSubsets)), ...
        'runPlans(%d).cmapssSubset must be one of FD001, FD002, FD003, FD004.', ...
        runIndex);
end


function validateSingleWarningHorizons(warningHorizons, runIndex)
    % VALIDATESINGLEWARNINGHORIZONS Validates warning horizon vector in a run plan.

    assert(isnumeric(warningHorizons) && isvector(warningHorizons) && ~isempty(warningHorizons), ...
        ['runPlans(%d).warningHorizons must be a nonempty numeric vector.'], ...
        runIndex);

    assert(all(isfinite(warningHorizons)) && all(warningHorizons > 0), ...
        'runPlans(%d).warningHorizons must contain only positive finite values.', ...
        runIndex);
end


function signatureKey = buildRunPlanSignature(runPlan)
    % BUILDRUNPLANSIGNATURE Builds a deterministic signature string for duplicate detection.

    cmapssSubsetKey = char(string(runPlan.cmapssSubset));
    warningHorizonsKey = mat2str(runPlan.warningHorizons);

    pcaSpecKey = jsonencode(orderfields(runPlan.pcaSpec));
    modelSpecKey = jsonencode(orderfields(runPlan.modelSpec));

    signatureKey = strjoin({ ...
        ['windowSize=' num2str(runPlan.windowSize)], ...
        ['cmapssSubset=' cmapssSubsetKey], ...
        ['warningHorizons=' warningHorizonsKey], ...
        ['pcaSpec=' pcaSpecKey], ...
        ['modelSpec=' modelSpecKey] ...
    }, '|');
end