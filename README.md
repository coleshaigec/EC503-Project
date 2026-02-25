# EC503 Project: Predictive Maintenance with Machine Learning

## Overview
This repository hosts the course project for **ENG EC503 – Learning from Data** at Boston University. 

Our objective is to implement and evaluate classical machine learning methods for industrial predictive maintenance. This framework is designed to help us collaborate efficiently, ensuring our experiments are reproducible and our core logic remains organized as the project scales.

---

## Why This Structure?
To make our collaboration as smooth as possible, I've set up a modular structure. This allows us to:
* **Avoid Merge Conflicts:** By separating logic (`src/`) from scripts (`experiments/`), we won't constantly overwrite each other's work.
* **Standardize Testing:** The "Smoke Test" ensures that if the code works for one of us, it works for everyone.
* **Stay Organized:** MATLAB packages (the folders starting with `+`) keep our namespace clean.

---

## Repository Map
```text
EC503-Project/
├── configs/             # Central experiment configurations (.m or .json)
├── data/                # Local datasets (Git-ignored to save space)
├── experiments/         # Scripts for running specific tests and simulations
│   ├── smoke_test.m     # Quick check to verify environment setup
│   └── run_main.m       # Main execution script for project results
├── outputs/             # Figures, tables, and saved models (Git-ignored)
├── src/                 # Core library code (The "+pm" package)
│   └── +pm/             # All functions called via 'pm.module.function'
│       ├── +datasets/   # Data loading and ingestion
│       ├── +preprocess/ # Cleaning and feature engineering
│       ├── +models/     # ML model definitions
│       ├── +evaluation/ # Metrics and scoring
│       └── +util/       # Shared helper functions
├── startup.m            # Run this first to set up paths
└── README.md

---
## Setup Instructions
### 1. Clone the Repository
```bash
git clone <repo-url>
cd EC503-Project
```
### 2. Open MATLAB
Open MATLAB with the repository root directory as the working directory.
### 3. Initialize the Project
```matlab
startup
```
This adds all required source directories to the MATLAB path.
### 4. Run the Smoke Test
```matlab
experiments.smoke_test
```
The smoke test runs a minimal end-to-end pipeline to verify that:
- paths are configured correctly
- MATLAB packages resolve properly
- core pipeline components execute successfully
If this runs without errors, your environment is correctly configured.
---
## Workflow Guidelines
To keep development organized and reproducible, the repository separates reusable implementation co- Reusable functions generally live in `src/`
- Experiment runners and analysis scripts live in `experiments/`
This separation helps ensure experiments remain easy to reproduce and extend throughout the project---
## Adding Models
New model implementations can be added under:
```
src/+pm/+models/
```
Example usage:
```matlab
model = pm.models.train_logreg(Xtrain, ytrain, cfg);
```
---
## Adding Datasets
Dataset loaders are located in:
```
src/+pm/+datasets/
```
Datasets themselves are stored locally in:
```
data/
```
Large datasets are intentionally excluded from version control.
---
## Running Experiments
Project experiments are designed to be reproducible through:
```matlab
experiments.run_experiments
```
---
## Data Management
Datasets are stored locally and excluded from version control.
Each teammate should place datasets inside:
```
data/
```
Download instructions or preprocessing notes will be documented as needed.
---
## Output Files
Generated figures, tables, and intermediate results are written to:
```
outputs/
```
The `outputs` directory exists in the repository structure, but its contents are ignored by Git to ---
## Configuration
Experiment parameters are controlled through configuration files located in:
```
configs/
```
This allows experiments to be modified without changing implementation code.
---
## Troubleshooting
If something does not run:
1. Ensure MATLAB is opened in the repository root
2. Run:
```matlab
startup
```
3. Run:
```matlab
experiments.smoke_test
```
4. Verify datasets are placed inside the `data/` directory
---
## Project Status
■ Initial project architecture under development
