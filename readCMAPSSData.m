function cmapssData = readCMAPSSData()
    % READCMAPSSDATA Extracts raw CMAPSS data from text files
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  cmapssData struct with fields
    %      .FD001 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD002 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD003 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)
    %      .FD004 struct with fields
    %          .train struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RUL (maxTimestamp x 1 double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .test struct with fields
    %              .engines (array of structs with fields)
    %                  .unitNumber (double)
    %                  .timestamps (maxTimestamp x 1 double)
    %                  .maxTimestamp (double)
    %                  .operatingConditions (maxTimestamp x 3 double)
    %                  .sensorReadings (maxTimestamp x 21 double) 
    %                  .RULFinal (double) 
    %              .numEngines (double)
    %              .numRecords (double)
    %          .name (string)

    cmapssDataFolderPath = './dataCMAPSS/CMAPSSData/';
    cmapssData = struct();

    cmapssData.FD001 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD001');
    cmapssData.FD002 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD002');
    cmapssData.FD003 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD003');
    cmapssData.FD004 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD004'); 
end