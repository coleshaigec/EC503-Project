function startup()
   %  experimentSpec struct with fields
    %      .id         (positive integer)
    %      .modelSpecs (array of modelSpec structs - see OUTPUTS)
    %      .pcaSpecs   (array of pcaSpec structs - see OUTPUTS)
    %      .missingnessSpecs (array of missingnessSpec structs -- see OUTPUTS)
    %      .warningHorizons (nonempty cell array; each cell contains a positive numeric vector)
    %      .cmapssSubsets (nonempty cell array of subset names: 'FD001', 'FD002', 'FD003', or 'FD004')
    %      .windowSizes (array of positive integers)

    modelSpec = struct( ...
        );

    
    experimentSpec = struct( ...
        'id', 1, ...
        )

end