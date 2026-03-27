function runEDAforCMAPSS(cmapssData)
    computeAndPlotEngineLevelSensorVariances(cmapssData);
    computeAndPlotGlobalSensorVariances(cmapssData);
    plotTimestampLengthHistogram(cmapssData);
end