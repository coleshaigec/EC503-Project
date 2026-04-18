function attributes = getNonnegativeScalarDoubleAttributes()
    % GETNONNEGATIVESCALARDOUBLEATTRIBUTES Returns attributes of a nonnegative scalar double for validation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  attributes (cell array of character vectors)

    attributes = {'scalar', 'real', 'finite', 'nonnegative', 'double'};
end

