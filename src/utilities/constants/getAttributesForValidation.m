function validationAttributes = getAttributesForValidation()
    % GETATTRIBUTESFORVALIDATION Returns attribute sets for use in validation workflows.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  validationAttributes struct with fields
    %      .positiveInteger (cell array of character vectors)
    %      .nonnegativeScalarDouble (cell array of character vectors)
    %      .dataMatrix (cell array of character vectors)
    %      .finiteRealVector (cell array of character vectors)
    %      .positiveIntegerVector (cell array of character vectors)
    %      .scalarDouble (cell array of character vectors)

    validationAttributes = struct();

    validationAttributes.positiveInteger = ...
        {'scalar', 'finite', 'positive', 'integer'};

    validationAttributes.positiveIntegerVector = ...
        {'vector', 'finite', 'positive', 'integer'};

    validationAttributes.nonnegativeScalarDouble = ...
        {'scalar', 'real', 'finite', 'nonnegative', 'double'};

    validationAttributes.scalarDouble = ...
        {'scalar', 'real', 'finite', 'double'};

    validationAttributes.dataMatrix = ...
        {'2d', 'real', 'nonempty', 'finite', 'double'};

    validationAttributes.realVector = ...
        {'vector', 'real', 'nonempty', 'finite'};
end