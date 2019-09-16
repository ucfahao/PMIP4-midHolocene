# PMIP4-midHolocene
This repository is a live document/analysis needed to write a multi-model manuscript about the PMIP4 midHolocene simulations. It is being coordinated by [Chris Brierley](c.brierley@ucl.ac.uk) and [Anni Zhao](anni.zhao.16@ucl.ac.uk) at University College London. Where people have already agreed to contribute to a particular section, they are mentioned below. But the more-the-merrier, so contact us if you want to help. 

The model status is presented in [data/README.md](data/README.md). You should be able to run this repository on a Pangeo Binder, but be aware that may take 30mins to load everything up to be ready to use
[![Binder](https://binder.pangeo.io/badge_logo.svg)](https://binder.pangeo.io/v2/gh/chrisbrierley/PMIP4-midHolocene/master)

## Manuscript Outline
_This is the current plan for the manuscript. Where we have already created the possible figures, they will have hyperlinks to the respective notebooks._
1. Introduction
   * Importance of MH
   * Brief literature review
   * Purpose of paper: present preliminary results
2. Methodology
   * PMIP4 overview
   * Summary of midHolocene protocol and differences from PMIP3
   * Participating models
   	 * __Table 1__: [PMIP3 and PMIP4 simulations](data/README.md)
   * Analysis procedure (inc. [PaleoCalAdjust](https://github.com/pjbartlein/PaleoCalAdjust) by @pjbartlein)
   	 * __Fig 1__: impact of calendar adjustment DJF and JJA
3. Results
   * Describe Simulated mean climate state and how has it changed in consequence of model improvements and/or higher climate sensitivity (w. Bette Otto-Bliesner, Allegra LeGrande, Charlie Williams)
   	 * [__Fig 2__: Annual Mean Temperature: ensemble average and uncertainty maps, PMIP3 vs PMIP4](https://github.com/chrisbrierley/PMIP4-midHolocene/blob/master/notebooks/PMIP4_Mid-Holocene_new.ipynb)
   	 * [__Fig 3__: Changes in seasonal cycle of surface temp: Ensemble average and uncertainty maps, PMIP3 vs PMIP4](https://github.com/chrisbrierley/PMIP4-midHolocene/blob/master/notebooks/PMIP4_Mid-Holocene_new.ipynb)
   	 * [__Fig 4__: Hydrological cycle: ensemble average and uncertainty maps, PMIP3 vs PMIP4](https://github.com/chrisbrierley/PMIP4-midHolocene/blob/master/notebooks/PMIP4_Mid-Holocene_new.ipynb)
   * Simulation of the monsoons (w. Pascale Braconnot, Roberta D'Agostino)
	 * __Fig 5__: Ensemble mean change in global monsoon domain
	 * __Fig 6__: Changes in individual monsoons (mean and variability, include observations)
4. Data model comparison (w. Sandy Harrison, Julien Emile-Geay)
   * Impact of new terrestrial data synthesis on dmc. Sandy Harrison](s.p.harrison@reading.ac.uk)
   	 * __Fig 7__: comparing Bartlein vs Cleator data sets at sites where both (all variables)
   	 * __Fig 8__: Taylor diagrams for all six variables, old data vs new data, different symbols for PMIP3 and PMIP4
   	 * __Fig 9__: Benchmarking carpet plot
   * Comparison with new gradient compilations ([Routson et al., 2019](https://www.nature.com/articles/s41586-019-1060-3) esp. focus on ocean)
   	 * __Fig 10__: Change in latitudinal gradients vs data
   * ENSO amplitude in comparison [Emile-Geay et al., 2015](https://github.com/CommonClimate/EmileGeay_NatGeo2015) compilation by @CommonClimate
   	 * __Fig 11__: Changes in annual cycle and interannual variability in pseudocorals in Tropical Pacific
5. Discussion (w. Julia Hargreaves)
   * Impact of changing boundary conditions and set up (between PMIP4 and PMIP3). e.g. Radiative forcing difference between 280 and 260. Would be nice to have sensitivity runs about vegetation impacts, but that can wait for people to perform the simulations. 
   * Future work section - used to highlight upcoming analyses
   * Potential for hydrological palaeobservational constraints
   	 * __Fig 12__: scatter plot of MH NAF monsoon vs future response
6. Summary and Conclusion
