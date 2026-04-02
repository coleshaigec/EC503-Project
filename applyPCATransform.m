function pcaResult = applyPCATransform(rawData, pcaTransform)
    % APPLYPCATRANSFORM Applies PCA transform to training and test datasets.
    %
    % INPUTS
    %  rawData struct with fields
    %      .Xtrain (nTrain x d double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x d double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - dataset dimension
    %
    %  pcaTransform struct with fields: 
    %      .mu (1 x d double) - mean vector used for centering dataset
    %      .coeff (d x k double) - principal directions
    %      .explained (1 x k) - explained variance percentages
    %      .originalDimension (int) - original dataset dimension
    %      .projectedDimension (int) - projected dimension after PCA
    %      .eigenvalues (1 x k) - eigenvalues associated with PCA transform
    %
    % OUTPUTS
    %  pcaResult struct with fields:
    %      .Xtrain (nTrain x k double) - training feature matrix
    %      .ytrain (nTrain x 1 double) - training label vector
    %      .Xtest  (nTest x k double)  - test feature matrix
    %      .ytest  (nTest x 1 double)  - test label vector
    %      .ntrain (int)               - training dataset size
    %      .ntest  (int)               - test dataset size
    %      .d      (int)               - projected dataset dimension
    %      .pcaTransform (struct)      - unchanged from implementation


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Implementation requirements and notes: %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 0. Please don't delete the docstring above these notes
    % 1. The pcaTransform struct from the fitPCATransform function is used to apply PCA to both training and test datasets 
    % 2. The return item pcaResult is a copy of the original dataset
    % struct with changed fields (i.e., Xtrain, Xtest, and d) overwritten
    % by this function and with the pcaTransform tacked on for later
    % debugging. The following original members should remain
    % unchanged:
    % ytest, ytrain, ntrain, ntest, pcaTransform
    % 3. PCA application entails Xproj = (X-mu)*W where mu =
    % pcaTransform.mu and W = pcaTransform.coeff --> we are centering and projecting both
    % training and test using the results derived from the training set

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- YOUR IMPLEMENTATION HERE -- %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    pcaResult = rawData;
   
    % -- Output validation - PLEASE DO NOT REMOVE --
    validatePCAResult(pcaResult, rawData, pcaTransform);
end