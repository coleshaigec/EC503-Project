function templateStruct = buildTemplateTestEngineStruct()
    templateStruct = struct();
    templateStruct.unitNumber = 1;
    templateStruct.timestamps = ones(2,1);
    templateStruct.operatingConditions = ones(2, 3);
    templateStruct.sensorReadings = ones(2,26);
    templateStruct.RULFinal = 1;
end