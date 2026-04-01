function transformedData = applyFeatureTransformationsToData(rawData, transformationSpec)
    %APPLYFEATURETRANSFORMATIONSTODATA Applies specified feature transformations to the dataset.  

    % Step 1: Fit normalization transform on training data
    if transformationSpec.normalizationSpec.enabled
        normalizationParameters = fitNormalizationTransform(rawData.Xtrain);
        normalizedDataset = applyNormalizationTransform(rawData, normalizationParameters);
    end



    
end