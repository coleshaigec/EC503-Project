function plotTimestampLengthHistogram(cmapssData)

    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};
    
    for i = 1:numel(cmapssSubsets)
        
        currentSubset = cmapssData.(cmapssSubsets{i});
        
        numTrainEngines = currentSubset.train.numEngines;
        numTestEngines  = currentSubset.test.numEngines;
        
        trainLifetimes = zeros(numTrainEngines, 1);
        testLifetimes  = zeros(numTestEngines, 1);
        testObservedLengths = zeros(numTestEngines, 1);
    
        % -----------------------------
        % Training: full lifetimes
        % -----------------------------
        for j = 1:numTrainEngines
            trainLifetimes(j) = currentSubset.train.engines(j).maxTimestamp;
        end 

        % -----------------------------
        % Test: observed + inferred
        % -----------------------------
        for j = 1:numTestEngines
            engine = currentSubset.test.engines(j);
            
            observedLength = engine.maxTimestamp;
            RUL = engine.RULFinal;
            
            testObservedLengths(j) = observedLength;
            testLifetimes(j) = observedLength + RUL;
        end

        % -----------------------------
        % Plot 1: Full lifetime comparison
        % -----------------------------
        figure; hold on; grid on;
        histogram(trainLifetimes, 15, 'FaceColor', 'b');
        histogram(testLifetimes, 15, 'FaceColor', 'r');
        
        title(sprintf('Full lifetime distribution (train vs test) — %s', cmapssSubsets{i}));
        xlabel('Lifetime (cycles)');
        ylabel('Frequency');
        legend({'Train (observed)', 'Test (inferred)'}, 'Location', 'best');

        % -----------------------------
        % Plot 2: Observed truncation
        % -----------------------------
        figure; hold on; grid on;
        histogram(trainLifetimes, 15, 'FaceColor', 'b');
        histogram(testObservedLengths, 15, 'FaceColor', 'g');
        
        title(sprintf('Observed trajectory lengths (train vs test) — %s', cmapssSubsets{i}));
        xlabel('Observed cycles');
        ylabel('Frequency');
        legend({'Train (full)', 'Test (truncated)'}, 'Location', 'best');

    end
end