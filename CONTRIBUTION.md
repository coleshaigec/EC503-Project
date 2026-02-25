# Contributing Guidelines
Thank you for contributing to the EC503 project!
This document describes the current repository organization and a few conventions
intended to make collaboration smoother and experiments easier to reproduce. These
guidelines may evolve as the project develops.
---
## General Philosophy
The repository separates reusable implementation code from experimental scripts:
- src/ contains reusable functionality
- experiments/ contains experiment runners and analysis scripts
This helps ensure results remain reproducible and easy to extend.
---
## Where Things Go
### Models
New model implementations can be added to:
src/+pm/+models/
---
### Datasets
Dataset loaders belong in:
src/+pm/+datasets/
Datasets themselves should be placed locally in:
data/
(Large datasets are not tracked by Git.)
---
### Experiments
Experiment scripts and comparisons should live in:
experiments/
The goal is that project results can ultimately be reproduced from:
experiments.run_experiments
---
## Before Committing Changes
It is helpful to run:
startup
experiments.smoke_test
This verifies that the pipeline still runs end-to-end.
---
## Adding New Functionality
When possible:
- Avoid hard-coded file paths
- Prefer configuration parameters (configs/)
- Keep reusable logic inside functions rather than scripts
---
## Outputs
Generated figures and intermediate results should be written to:
outputs/
This directory is ignored by Git to avoid committing large files.
---
## Questions or Improvements
If you think the structure should change or improve, feel free to suggest updates —
the organization is intended to support the whole team.
