function generateRunSpecsFromExperimentSpec(experimentSpec)
    idxNoiseOptions = 1:numel(experimentSpec.noiseOptions);
    idxMissingnessOptions = 1:numel(experimentSpec.missingnessOptions);
    idxPCAOptions = 1:numel(experimentSpec.pcaOptions);
    idxImbalanceOptions = 1:numel(experimentSpec.imbalanceOptions);
    idxModelOptions = 1:numel(experimentSpec.modelOptions);
    idxDatasetOptions = 1:numel(experimentSpec.datasetOptions);
    
    % Construct experiment indices as Cartesian product of option struct
    % indices
    experimentIndices = combinations(idxNoiseOptions, ...
        idxMissingnessOptions, ...
        idxPCAOptions, ...
        idxImbalanceOptions, ...
        idxModelOptions, ...
        idxDatasetOptions ...
    );

    numExperiments = height(experimentIndices);
end