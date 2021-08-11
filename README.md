# MATLAB Solubility Models
MEng research project: used to compare the performance of different co-solvency solubility models. 
These models can be used to predict the solubility of co-solvent systems.

Included models:

(p - predictive, e : empirical)
- Log-Linear (e)
- Predictive Log-Linear (p)
- Jouyban-Acree (e)
- General Single Model / GSM (e)
- NRTL (e)
- UNIQUAC (e)

# Notes on the Solubility Models

**Log-Linear**
The Log-Linear model of Yalkowsky is a simple to use model that represents ideal cosolvent systems (i.e. no solubility peaks with solvent mixtures). Needs: Solubility data in neat solvent and co-solvent. 
This model is denoted in the code by _LL_IMM_ 

**Predictive Log-Linear**
An extenstion of the log-linear model that replaces co-solvent solubility with the co-solvent's solubization power found from constants from literature and the logKow value for the solute. Values for the constants for common co-solvents can be found in A.Jouyban's 'Handbook of Solubility Data for Pharmacueticals'  Table 1.11 on page 33 of the 2010 edition. (This book is also a good source for solubility data to try out the models with)





# How To Use

## Folders

- data_files : stores solubility data
- program_files : scripts found here
  - _ModelScript.m_
  - _SolModelTool.mlapp_
  - _corr_funs_ : correlation functions for models
  - _pred_funs_ : predicting functions for models
  - _other_funs_: functions that do other jobs


## Solubility Data

To perform correlation on a data-set the solubility data must be formatted in the same way as shown with the data in _SolubilityData - Propanol example.xlxs_ 

**Note** For the NRTL & UNIQUAC models, the solubility data must be prepared as a ternary mole fraction system for both the solvent fractions and unit of solubility for truly representative modelling.

## Using the models
To interpolate existing solubility data with the available models, the UI based _SolModelTool.mlapp_ is the easiest to use. 

To incorporate the models within your own scripts I would reccomend trying the models with _ModelScript.m_ to see how they are called, and then writing your own code by adding the   _corr_funs_ ,  _pred_funs_, and _other_funs_ folders to your directory.


