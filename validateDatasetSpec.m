function validateDatasetSpec(datasetSpec)
    % Function stub for dataset validation
    POSITIVE_INTEGER_ATTRIBUTES = {'scalar', 'finite', 'positive', 'integer'};
    
    
    validateattributes(spec.id, {'numeric'}, POSITIVE_INTEGER_ATTRIBUTES, mfilename, 'spec.id');
end