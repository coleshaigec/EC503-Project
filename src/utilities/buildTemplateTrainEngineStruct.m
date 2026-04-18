function templateStruct = buildTemplateTrainEngineStruct()
    templateStruct = struct();
    templateStruct.unitNumber = 1;
    templateStruct.timestamps = [];
    templateStruct.maxTimestamp = 100;
    templateStruct.operatingConditions = [];
    templateStruct.sensorReadings = [];
    templateStruct.RUL = [];
end