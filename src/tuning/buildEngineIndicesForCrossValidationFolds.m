function foldIndices = buildEngineIndicesForCrossValidationFolds(cmapssSubset)
    % BUILDCROSSVALIDATIONFOLDS Defines indices that randomly partition a CMAPSS subset into k folds for cross-validation.
    %
    % INPUTS 
    %  cmapssSubset struct with fields
    %      .train struct with fields
    %          .engines (array of structs with fields)
    %              .unitNumber (double)
    %              .timestamps (maxTimestamp x 1 double)
    %              .maxTimestamp (double)
    %              .operatingConditions (maxTimestamp x 3 double)
    %              .RUL (maxTimestamp x 3 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .test struct with fields
    %          .engines (array of structs with fields)
    %              .unitNumber (double)
    %              .timestamps (maxTimestamp x 1 double)
    %              .maxTimestamp (double)
    %              .operatingConditions (maxTimestamp x 3 double)
    %              .RUL (maxTimestamp x 3 double)
    %          .numEngines (double)
    %          .numRecords (double)
    %      .name (string)
    %
    % OUTPUTS
    %  foldIndices (1 x CROSS_VALIDATION_FOLDS cell) - each cell contains a
    %  row vector of engine indices assigned to one validation fold
    
    % -- Construct random engine indices for each fold --
    rawFoldIndices = randperm(cmapssSubset.train.numEngines);

    if mod(cmapssSubset.train.numEngines, CROSS_VALIDATION_FOLDS) ~= 0
         error('buildEngineIndicesForCrossValidationFolds:InvalidFieldValue', ...
            'cmapssSubset.train.numEngines = %i must be evenly divisible by CROSS_VALIDATION_FOLDS = %i', cmapssSubset.train.numEngines, CROSS_VALIDATION_FOLDS);
    end

    numEnginesPerFold = cmapssSubset.train.numEngines / CROSS_VALIDATION_FOLDS;
    foldIndices = mat2cell(rawFoldIndices, 1, numEnginesPerFold * ones(1, CROSS_VALIDATION_FOLDS));
end
