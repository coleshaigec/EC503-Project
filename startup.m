% function startup()
%     x = 0; % placeholder
% end

% experimentPlan = struct( ...
% 
%     );

gaussianNoiseConfig = struct( ...
    'dimension', 1, % validator will ensure that config statistics match dimension
    'mean', 0,
    'covariance', 1 
    ...
    );

noiseSpec = struct( ...
    'enabled', true, % other members ignored if enabled false
    'type', 'Gaussian',
    'parameters', gaussianNoiseConfig
    );

missingnessSpec = struct( ...
    'enabled', true, % other members ignored if enabled false
    'type', 'mcar',
    'percentage', 5
    );

pcaSpec = struct( ...
    'enabled', true, % other members ignored if enabled false
    'varianceFraction', 0.95
    );

imbalanceSpec = struct( ...
    'enabled', false
    );

modelSpec = struct( ...
    'modelName', 'gradientBoosting',
    'modelType', 'regression'
    );

syntheticDatasetSpec = struct( ...
    'name', 'exampleDataset',
    'numSamples', 10000,
    other fields TBD
    );

datasetSpec = struct( ...
    'source', 'synthetic', % below config field optional if CMAPSS used
    'datasetParameters', 
    );


singleRunSpec = struct( ...
    'id', 1,
    'experimentKey', 209242,
    'experimentName', 'experimentName',
    'T', 5,
    'noiseSpec', noiseSpec,
    'missingnessSpec', missingnessSpec
    'pcaSpec', pcaSpec,
    'imbalanceSpec', imbalanceSpec,
    'modelSpec', modelSpec,
    'datasetSpec', datasetSpec
    ...
    );







% 
% 
% mcarSpec = struct( ...
%     % insert members here
%     );
% 
% missingnessSpec = struct( ...
%     'mcar', mcarSpec,
%     ...
%     )
% 
% gaussianNoiseSpec = struct( ...
%     'enabled', true,
%     'mean', 0,
%     'covarianceMatrix' = 1,
%     ...
%     );
% 
% 
% noiseSpec = struct( ...
%     'gaussian', gaussianNoiseSpec,
%     'impulse', impulseNoiseSpec,
%     'superimposeGaussianAndImpulseNoise', true
%     );
% 
% experimentSpec = struct( ...
%     'key', 1,
%     'Name', 'gaussianVersusImpulseNoise',
%     'noise', noiseSpec,
%     'missingness', missingnessSpec
%     ...
%     );
% 
