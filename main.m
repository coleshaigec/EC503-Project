function main()
    % MAIN Runs full pipeline workflow, building and executing experiment plan.
    %
    % AUTHOR: Cole H. Shaigec

    experimentSpec = buildExperimentSpec();

    runExperiment(experimentSpec);
end