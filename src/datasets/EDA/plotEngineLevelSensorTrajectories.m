function plotEngineLevelSensorTrajectories(cmapssData, numEnginesToPlot)
    %PLOTENGINELEVELSENSORTRAJECTORIES Plot trajectories for all sensors
    %across a set of randomly selected engines from each CMAPSS subset

    cmapssSubsets = {'FD001', 'FD002', 'FD003', 'FD004'};

    for i = 1:numel(cmapssSubsets)
        
        currentSubset = cmapssData.(cmapssSubsets{i});
        numTrainEngines = currentSubset.train.numEngines;
        numTestEngines  = currentSubset.test.numEngines;

        trainEnginesToSample = randi(numTrainEngines, [numEnginesToPlot,1]);
        testEnginesToSample = randi(numTestEngines, [numEnginesToPlot,1]);

        numSensors = size(currentSubset.train.engines(1).sensorReadings, 2);

        % Sample and plot training engines
        for j = 1 : numEnginesToPlot
            figure; 
            subplotSizes = factor(numSensors);
            mSubplot = subplotSizes(1);
            nSubplot = subplotSizes(2);

            idxCurrentEngine = trainEnginesToSample(j);
            sgtitle(sprintf('Sensor trajectories for training engine %i from CMAPSS subset %s', idxCurrentEngine, cmapssSubsets{i}));
            currentEngine = currentSubset.train.engines(idxCurrentEngine);
            numReadingsForCurrentEngine = size(currentEngine.sensorReadings,1);

            
            for k = 1 : numSensors
                subplot(mSubplot,nSubplot,k); hold on; grid on;
                currentSensorReadings = currentEngine.sensorReadings(:, k);
                plot(1:numReadingsForCurrentEngine, currentSensorReadings, 'Color', 'b');
                title(sprintf('Sensor %i', k));
                xlabel('Time');
                ylabel('Sensor reading');
            end
            
            title(sprintf('Sensor readings for engine %i', idxCurrentEngine));
        end
   
        % Sample and plot test engines
        for j = 1 : numEnginesToPlot
            figure; 
            subplotSizes = factor(numSensors);
            mSubplot = subplotSizes(1);
            nSubplot = subplotSizes(2);

            idxCurrentEngine = testEnginesToSample(j);
            sgtitle(sprintf('Sensor trajectories for test engine %i from CMAPSS subset %s', idxCurrentEngine, cmapssSubsets{i}));
            currentEngine = currentSubset.test.engines(idxCurrentEngine);
            numReadingsForCurrentEngine = size(currentEngine.sensorReadings,1);

            
            for k = 1 : numSensors
                subplot(mSubplot,nSubplot,k); hold on; grid on;
                currentSensorReadings = currentEngine.sensorReadings(:, k);
                plot(1:numReadingsForCurrentEngine, currentSensorReadings, 'Color', 'r');
                title(sprintf('Sensor %i', k));
                xlabel('Time');
                ylabel('Sensor reading');
            end
            
            title(sprintf('Sensor readings for engine %i', idxCurrentEngine));
        end

    end
end