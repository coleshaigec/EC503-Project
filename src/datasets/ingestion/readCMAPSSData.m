function rawCMAPSSData = readCMAPSSData()
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

    % -- Read raw data from file --
    cmapssDataFolderPath = getCMAPSSDataFolderPath();
    rawCMAPSSData = struct();

    rawCMAPSSData.FD001 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD001');
    rawCMAPSSData.FD002 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD002');
    rawCMAPSSData.FD003 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD003');
    rawCMAPSSData.FD004 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD004'); 

    fprintf('CMAPSS data read successfully.\n');
end