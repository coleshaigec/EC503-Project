# EC503 CMAPSS Predictive Maintenance Pipeline
Authors: Cole H. Shaigec, Kelly Falcon, Youwei Chen

This repository contains a MATLAB implementation of an end-to-end machine learning pipeline for predictive maintenance experiments on the NASA CMAPSS turbofan degradation dataset.

The project evaluates classical machine learning models for remaining useful life (RUL) estimation and maintenance-warning classification. In addition to standard predictive metrics, the pipeline includes a decision-oriented maintenance cost model so that model performance can be evaluated in operational terms rather than only by RMSE, accuracy, or F1 score.

## Project Scope

The pipeline supports experiments over:

- CMAPSS subsets FD001 and FD003
- Regression and classification formulations
- Warning horizon sweeps
- Feature preprocessing and normalization
- Optional dimensionality reduction
- Hyperparameter tuning with cross-validation
- Model evaluation using both ML metrics and maintenance-policy cost metrics

The main project goal is to compare model behavior under different degradation regimes and evaluate whether prediction quality translates into better maintenance decisions.

## How to Run

To add the project files to the MATLAB path, run:

startup

Open MATLAB from the repository root and run:

main

The pipeline is configured directly through MATLAB experiment-specification code.

## Repository Organization

The codebase is organized around the main pipeline stages:

- Experiment specification
- Data loading and preprocessing
- Feature normalization and optional PCA
- Model training
- Hyperparameter tuning
- Prediction
- Metric computation
- Maintenance-policy evaluation
- Experiment reporting

The project uses MATLAB functions and structs to pass data, model specifications, hyperparameters, run plans, and result summaries through the pipeline.

## Data

The project uses NASA CMAPSS turbofan engine degradation data.

FD001 and FD003 are the primary subsets used in the experiments. FD001 contains a single operating condition and single failure mode, while FD003 contains a single operating condition with multiple failure modes. This makes FD003 a harder prediction problem because the relationship between sensor state and RUL is less uniform.

Raw CMAPSS data files should be placed in the expected project data directory before running the pipeline.

## Models

The project includes implementations or wrappers for several classical machine learning models, including:

- Ridge regression
- Weighted ridge regression
- Gaussian naive Bayes
- Quadratic discriminant analysis
- k-nearest neighbors
- Random forest classification
- Gradient boosting regression

Model interfaces are structured so that training functions return model structs and prediction functions operate on standardized dataset structs.

## Evaluation

Regression models are evaluated using RUL prediction error metrics such as:

- RMSE
- MAE
- R²
- Error diagnostics

Classification models are evaluated using warning-horizon-based labels and metrics such as:

- Accuracy
- Precision
- Recall
- F1 score
- Specificity
- Balanced accuracy
- Confusion matrix entries

The pipeline also evaluates models through a maintenance decision layer. Predicted RULs or warning labels are converted into maintenance decisions, and those decisions are scored using an operational cost model.

## Maintenance Decision Model

The decision model distinguishes between:

- Correctly scheduled maintenance
- Premature maintenance, which wastes remaining useful life
- Missed failures, which incur high failure costs

This allows the project to compare models based on their downstream operational consequences, not only their raw statistical prediction accuracy.

## Outputs

Pipeline runs generate experiment summaries and diagnostic outputs, including model metrics, cost metrics, and run-level reports. These outputs are intended to support comparison across datasets, model classes, warning horizons, and hyperparameter settings.

## External Analysis Tools

Some figures, plots, and statistical tests used in the accompanying report were produced using separate ad hoc analysis workflows (e.g., lightweight scripts and spreadsheet-based tools). These were used for presentation and exploratory analysis purposes and are not part of the core MATLAB pipeline. The repository is intended to capture the primary modeling and evaluation system rather than all auxiliary analysis artifacts.

## Reproducibility Notes

The project is designed around explicit MATLAB experiment specifications, structured run plans, and fixed data-processing logic. For reproducible results, avoid modifying preprocessing, model-selection, or cost-model code between compared runs unless the change is part of the experimental design.

## Requirements

This project requires MATLAB and the toolboxes needed by the selected models. In particular, models using MATLAB’s built-in machine learning routines may require the Statistics and Machine Learning Toolbox.
