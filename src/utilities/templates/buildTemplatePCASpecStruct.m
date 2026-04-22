function templatePCASpecStruct = buildTemplatePCASpecStruct()
    % BUILDTEMPLATEPCASPECSTRUCT Builds template PCASpec struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templatePCASpecStruct struct with fields
    %      .enabled
    %      .selectionMode
    %      .varianceThreshold
    %      .fixedNumComponents

    templatePCASpecStruct = struct( ...
        'enabled', [], ...
        'selectionMode', [], ...
        'varianceThreshold', [], ...
        'fixedNumComponents', [] ...
    );
end