function pcaTransform = fitPCATransform(Xtrain, pcaSpec)
    % FITPCATRANSFORM Fits PCA transform on training dataset according to pipeline specifications.
    %
    % INPUTS: 
    %  Xtrain (nTrain x d double) - training feature matrix
    %  
    %  pcaSpec struct with fields:
    %      .enabled (boolean)
    %      .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %      .varianceThreshold (double in [0,1]) - 
    %      .fixedNumComponents (int > 0) - number of principal components to compute 
    %
    % OUTPUT:
    %  pcaTransform struct with fields: 
    %      .mu (1 x d double) - mean vector used for centering dataset
    %      .coeff (d x k double) - principal directions
    %      .explained (1 x k) - explained variance percentages
    %      .originalDimension (int) - original dataset dimension
    %      .projectedDimension (int) - projected dimension after PCA
    %      .eigenvalues (1 x k) - eigenvalues associated with PCA transform

    
    % Implementation requirements and notes:
    % 1. You can ignore the enabled field - this function doesn't get called
    % without it
    % 2. The behavior of this function depends on the selection mode. If it
    % is 'varianceThreshold', return whatever number of principal
    % components is needed to explain at least that percentage of dataset
    % variance. If it is 'numComponents', return exactly the fixed number of
    % principal components specified by the pcaSpec struct. 
    % 3. 'selectionMode' will always have exactly one value and one
    % corresponding parameter (either 'varianceThreshold' or
    % 'numComponents'). Whichever mode is selected, please ignore the
    % parameter passed in for the other mode.
    % 4. mu is computed from the training data passed into fitPCATransform, and must be 
    % used to center both training and test features during applyPCATransform.
    % 5. coeff is d x k, with columns equal to retained principal
    % directions. Those columns are orthonormal. Projection is performed as (X - mu) * coeff

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % -- Output validation - PLEASE DO NOT REMOVE --
    validatePCATransform(pcaTransform);
end