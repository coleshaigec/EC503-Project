function foldIndices = buildEngineIndicesForCrossValidationFolds(cmapssSubset, numFolds)
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
    %  numFolds (positive integer)
    %
    % OUTPUTS
    %  foldIndices (1 x numFolds cell) - each cell contains a
    %  row vector of engine indices assigned to one validation fold
    
    % -- Construct random engine indices for each fold --
    rawFoldIndices = randperm(cmapssSubset.train.numEngines);

    if mod(cmapssSubset.train.numEngines, numFolds) ~= 0
         error('buildEngineIndicesForCrossValidationFolds:InvalidFieldValue', ...
            'cmapssSubset.train.numEngines = %i must be evenly divisible by numFolds = %i', cmapssSubset.train.numEngines, numFolds);
    end

    numEnginesPerFold = cmapssSubset.train.numEngines / numFolds;
    foldIndices = mat2cell(rawFoldIndices, 1, numEnginesPerFold * ones(1, numFolds));
end
