# EC503 Project — Predictive Maintenance with Machine Learning

## Overview

This repository contains the course project for **ENG EC503 – Learning from Data (Boston University)**.

The goal of this project is to investigate the use of classical machine learning methods for **predictive maintenance** problems using industrial-style sensor datasets. We focus on building a clean, reproducible experimental pipeline for evaluating model performance under realistic conditions such as:

- class imbalance  
- noisy sensor measurements  
- missing data  
- equipment degradation over time  

The repository is structured to separate reusable machine learning components from experiments and analysis so that results can be reproduced easily.

---

## Repository Structure


EC503-Project/
│
├── configs/
│ └── base_config.m # Central experiment configuration
│
├── data/ # Local datasets (not tracked by Git)
│
├── experiments/
│ ├── smoke_test.m # Environment + pipeline check
│ └── run_experiments.m # Main experiment runner
│
├── outputs/ # Generated results (ignored by Git)
│
├── src/
│ └── +pm/
│ ├── +datasets/ # Dataset loaders
│ ├── +preprocessing/ # Data preprocessing utilities
│ ├── +models/ # ML model implementations
│ ├── +evaluation/ # Metrics and evaluation
│ ├── +visualization/ # Plotting and visualization
│ └── +utilities/ # Shared helper functions
│
├── startup.m # MATLAB path initialization
└── README.md


---

## Setup Instructions

### 1. Clone the Repository


git clone <repo-url>
cd EC503-Project


---

### 2. Open MATLAB

Open MATLAB with the repository root directory as the working directory.

---

### 3. Initialize the Project

Run:


startup


This adds all required source directories to the MATLAB path.

---

### 4. Run the Smoke Test


experiments.smoke_test


The smoke test runs a minimal end-to-end pipeline to verify that:

- paths are configured correctly  
- MATLAB packages resolve properly  
- core pipeline components execute successfully  

If this runs without errors, your environment is correctly configured.

---

## Workflow Guidelines

### Core Principle

**Reusable code belongs in `src/`.  
Experiments belong in `experiments/`.**

Do **not** place experiment scripts inside `src/`.

---

### Adding Models

Model implementations should be added to:


src/+pm/+models/


Example usage:


model = pm.models.train_logreg(Xtrain, ytrain, cfg);


---

### Adding Datasets

Dataset loaders belong in:


src/+pm/+datasets/


Datasets themselves should be stored locally in:


data/


Large datasets should **not** be committed to GitHub.

---

### Running Experiments

All project results should ultimately be reproducible by running:


experiments.run_experiments


---

## Data Management

Datasets are stored locally and excluded from version control.

Each teammate should place datasets inside:


data/


Download instructions or preprocessing notes will be documented as needed.

---

## Output Files

Generated figures, tables, and intermediate results are written to:


outputs/


The `outputs` directory exists in the repository structure, but its contents are ignored by Git to avoid committing large generated files.

---

## Configuration

Experiment parameters are controlled through configuration files located in:


configs/


This allows experiments to be modified without changing implementation code.

---

## Troubleshooting

If something does not run:

1. Ensure MATLAB is opened in the repository root  
2. Run:


startup


3. Run:


experiments.smoke_test


4. Verify datasets are placed inside the `data/` directory  

---

## Project Status

🚧 Initial project architecture under development.
