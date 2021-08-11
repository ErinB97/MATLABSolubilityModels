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

**Log-Linear:**

The Log-Linear model of Yalkowsky is a simple to use model that represents ideal cosolvent systems (i.e. no solubility peaks with solvent mixtures). Needs: Solubility data in neat solvent and co-solvent. 

This model is denoted in the code by _LL_IMM_ 

**Predictive Log-Linear:**

An extenstion of the log-linear model that replaces co-solvent solubility with the co-solvent's solubization power found from constants from literature and the logKow value for the solute. Values for the constants for common co-solvents can be found in A.Jouyban's 'Handbook of Solubility Data for Pharmacueticals'  Table 1.11 on page 33 of the 2010 edition. (This book is also a good source for solubility data to try out the models with). This model is often times _very_ innacurate (see my results) and I would not reccomend using it beyond testing / initial studies.

This model is denoted in the code by _LL_SIG_

**Jouyban-Acree Model:**

A straight-forward and highly effective correlative model that is more than adequate for modelling both ideal and non-ideal solubility systems. To use this model, the solubility data requires neat co-solvent solubility data points ("end points") and a series of data-points in-between. (See the _SolubilityData - Propanol example.xlxs_  for an example of what this looks like.) Personally, unless you specifically need to estimate the activity co-effictients of your components I would reccomend using this model.

This model is denoted in the code by _JA_REG_ 

**General Single Model:**

A simplification of the Jouyban-Acree model which requires only the solubility data in one neat co-solvent and a data series to correlate from. Yields very similar results to the Jouyban-Acree model.

This model is denoted in the code by _GSM_ 


**Further reading:** All of the above four models are discussed in more detail in the paper [Review of the Cosolvency Models for Predicting Drug Solubility in Solvent Mixtures: An Update](https://journals.library.ualberta.ca/jpps/index.php/JPPS/article/view/30611) by A. Jouyban. I would reccomend reading this review if you are interested: in cosolvency modelling in general, the algebraic form of the models, or wish to know the background of the above models.

**NRTL Model:**

[The NRTL Model](https://en.wikipedia.org/wiki/Non-random_two-liquid_model) is a popular activity coefficient model, in this project I have employed it in an empirical rather than a predictive fashion. Currently there is a gap in (publicly available) research for published generic NRTL BIPs (binary interaction parameters) for pharmacuetical compounds in co-solvent systems. Using this model, a series of solubility data points is entered, and an optimisation routine determines BIPs for the system. When using the model be sure to adjust the non-randomness factor alpha to a value between 0.1 & 0.5 for the best results.

This model is denoted in the code by _NRTL_ 

**UNIQUAC Model:**

[The UNIQUAC Model](https://en.wikipedia.org/wiki/UNIQUAC) is also a commonly used activity coefficient model, that likewise lacks available published pharamcuetical & co-solvent BIP data. UNIQUAC functionality in this project is the same to that as NRTL. However, the UNIQUAC model requires the group contribution data for each component. For this project I made use of the (Dortmund Data Bank online UNIFAC group assignment tool)[http://www.ddbst.com/unifacga.html] for this project. Unfortunately becusae this is the regular UNIQUAC model electrolytes and some drugs with complex structures are not supported.


This model is denoted in the code by _UNIQUAC_ 

**Further reading:** Significant advancements have been made to develop the NRTL & UNIQUAC models to cover their shortcomings. Some of these models include eNRTL, NRTL-SAC, eNRTL-SAC, Modified UNIQUAC, and eUNIQUAC to name just a few. If the models in this project do not fit your need, I would reccomend giving these models a search.

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

**Note:** For the NRTL & UNIQUAC models, the solubility data must be prepared as a ternary mole fraction system for both the solvent fractions and unit of solubility for truly representative modelling.

## Using the models
To interpolate existing solubility data with the available models, the UI based _SolModelTool.mlapp_ is the easiest to use. 

To incorporate the models within your own scripts I would reccomend trying the models with _ModelScript.m_ to see how they are called, and then writing your own code by adding the   _corr_funs_ ,  _pred_funs_, and _other_funs_ folders to your directory.


