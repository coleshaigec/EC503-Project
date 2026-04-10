function cmapssData = readCMAPSSData()
    % READCMAPSSDATA Extracts raw CMAPSS data from text files
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  cmapssData struct with fields
    %      .FD001 struct with fields
    %
    %
    %
    % DOCSTRING STILL UNDER CONSTRUCTION
    cmapssDataFolderPath = './dataCMAPSS/CMAPSSData/';
    cmapssData = struct();

    cmapssData.FD001 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD001');
    cmapssData.FD002 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD002');
    cmapssData.FD003 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD003');
    cmapssData.FD004 = readSubsetFromCMAPSS(cmapssDataFolderPath, 'FD004'); 
end