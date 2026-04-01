function transformedData = applyFeatureTransformationsToData(rawData, transformationSpec)
    % APPLYFEATURETRANSFORMATIONSTODATA Applies specified feature transformations to the dataset.  
    %
    % INPUT:
    %   rawData struct with fields:
    %       .Xtrain (nTrain x d double) - training feature matrix
    %       .ytrain (nTrain x 1 double) - training label vector
    %       .Xtest  (nTest x d double)  - test feature matrix
    %       .ytest  (nTest x 1 double)  - test label vector
    %       .ntrain (int)               - training dataset size
    %       .ntest  (int)               - test dataset size
    %       .d      (int)               - dataset dimension
    %
    %  transformationSpec struct with fields:
    %      .pcaSpec struct with fields:
    %          .enabled (boolean)
    %          .varianceThreshold (double in [0,1])
    %      .normalizationSpec struct with fields:
    %          .enabled (boolean)
    %
    % OUTPUT:
    %  transformedData struct with fields:
    %       .Xtrain (nTrain x d double) - training feature matrix
    %       .ytrain (nTrain x 1 double) - training label vector
    %       .Xtest  (nTest x d double)  - test feature matrix
    %       .ytest  (nTest x 1 double)  - test label vector
    %       .ntrain (int)               - training dataset size
    %       .ntest  (int)               - test dataset size
    %       .d      (int)               - dataset dimension

    % -- Invariants: spec structs --
    assert(isfield(transformationSpec, 'pcaSpec'), ...
        'transformationSpec must contain field pcaSpec');
    assert(isfield(transformationSpec, 'normalizationSpec'), ...
        'transformationSpec must contain field normalizationSpec');
    validatePCASpec(transformationSpec.pcaSpec);
    assert(isfield(transformationSpec.normalizationSpec, 'enabled'), ...
        'normalizationSpec must contain field enabled');

    % -- Invariants: dataset -- 
    validateSingleRunDataset(rawData);

    % -- Normalization --
    if transformationSpec.normalizationSpec.enabled
        normalizationParameters = fitNormalizationTransform(rawData.Xtrain);
        dataset = applyNormalizationTransform(rawData, normalizationParameters);
    else 
        % If no normalization, use the raw dataset
        dataset = rawData;
    end

    % -- PCA --
    if transformationSpec.pcaSpec.enabled
        pcaTransform = fitPCATransform(rawData.Xtrain, pcaSpec);
        SOMETHING = applyPCATransform(rawData, pcaTransform);s
    end



    
end