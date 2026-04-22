function csvOutFileName =  getCSVOutFileName()
    % GETCSVOUTFILENAME Returns name of CSV file to which experiment results will be written.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  csvOutFileName (string)
    %
    % NOTES
    % - For clean separation of experiments, this function writes the
    % results of each experiment to a file with a standardized,
    % experiment-specific name.

    csvOutFileName = strcat('EXPERIMENT_RESULT_', string(datetime("now")), '.csv');
end