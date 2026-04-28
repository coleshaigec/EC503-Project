function pcaTransform = fitPCATransform(X, pcaSpec)
    % FITPCATRANSFORM Fits PCA transform on specified dataset according to pipeline specifications.
    %
    % INPUTS: 
    %  X (n x d double) - feature matrix
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


    % size
    [n,d]=size(X);
    
    % data analysis
    mu=mean(X,1);
    Xc=X-mu;
    S=(Xc'*Xc)/n;

    % eigenvals
    [V,D]=eig(S);
    eigvals=diag(D);
    [eigvals_sorted,idx]=sort(eigvals,'descend');  % sorting eigenvals
    V_sorted=V(:,idx);
    eigvals_sorted(eigvals_sorted < 0) = 0; % changing possible neg to 0
    total_var=sum(eigvals_sorted);
    if total_var == 0
        explained_all = zeros(size(eigvals_sorted));
    else
        explained_all = 100 * eigvals_sorted/total_var;
    end

    %components being kept
    if strcmp(pcaSpec.selectionMode, 'fixedNumComponents')
        k=pcaSpec.fixedNumComponents;
    elseif strcmp(pcaSpec.selectionMode, 'varianceThreshold')
        cum_var=cumsum(eigvals_sorted);

        if total_var == 0
            k = 1;
        else
            frac_var=cum_var/total_var;
            k=find(frac_var >= pcaSpec.varianceThreshold,1,'first');
        end
    else
        error('Unknown PCA selection mode.');
    end

    % double checking k is valid
    k=min(k,d);
    k=max(k,1);

    coeff=V_sorted(:,1:k);
    explained=explained_all(1:k);
    eigenvalues=eigvals_sorted(1:k);

    %building output struct
    pcaTransform = struct();
    pcaTransform.mu=mu;
    pcaTransform.coeff=coeff;
    pcaTransform.explained=explained';
    pcaTransform.originalDimension=d;
    pcaTransform.projectedDimension=k;
    pcaTransform.eigenvalues=eigenvalues';
    
    
    % -- Output validation - PLEASE DO NOT REMOVE --
    validatePCATransform(pcaTransform, X);
end
