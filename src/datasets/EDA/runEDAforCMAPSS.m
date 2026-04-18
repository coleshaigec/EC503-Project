function runEDAforCMAPSS(cmapssData)
    computeAndPlotEngineLevelSensorVariances(cmapssData);
    computeAndPlotGlobalSensorVariances(cmapssData, true);
    plotTimestampLengthHistogram(cmapssData);
    plotEngineLevelSensorTrajectories(cmapssData, 4);
end