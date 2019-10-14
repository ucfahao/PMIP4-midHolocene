# PMIP4-midHolocene Data
This directory holds the data for the scripts to run off. 

If this directory is empty then please move into ../scripts and run `./download_cvdp_data_tar.sh`. If you are running this a pangeo binder, then you will need to do that command in a [terminal](https://jupyterlab.readthedocs.io/en/stable/user/terminal.html) first.

## PMIP4 Models

Model name | Modelling center | On ESGF | Reference(s) | Contact | In plots so far
--------   | --------         | ------- | --------     | ------- | -------
AWI-CM-1-1-LR | Alfred Wegener Institute, Germany | No | ? | Gerrit Lohmann | Y
CESM2 | National Center for Atmospheric Research (NCAR), USA | Yes | ? | Bette Otto-Bliesner | N
EC-Earth3 | Stockholm University | No | ? | Qiong Zhang | N
FGOALS-f/G3 | Chinese Academy of Sciences, Beijing | No |? | Weipeng Zheng | N
GISS-E2-G | Goddard Institute for Space Studies (GISS), USA | Yes | ? | Allegra LeGrande | N
HadGEM3-GC31 | Met. Office, UK | No | ? | Charlie Williams | Y
IPSL-CM6A-LR | Institut Pierre Simon Laplace (IPSL), France | Yes | ? | Pascale Braconnot | Y
MIROC-ES2L | Japan Agency for Marine-Earth Science and Technology, Atmosphere and Ocean Research Institute (The University of Tokyo), and National Institute for Environmental Studies | Yes | ? | Rumi Ohgaito | N 
MPI-ESM2? | Max Planck Institute für Meteorologie (MPI), Germany | No | ? | Roberta D'Agostino | N
MRI-ESM2 | Japan | Yes | ? | Seiji Yukimoto | N
NESM3 | Nanjing University of Information Science and Technology, China | Yes | [Cao et al. (2018)](https://www.geosci-model-dev.net/11/2975/2018/) | Jian Cao | N 
NorESM1-F | Bjerknes Centre for Climate Research, Norway | Yes | ? | Chuncheng Guo | N
NorESM2 | Bjerknes Centre for Climate Research, Norway | No | ? | Zhongshi Zhang | N

## PMIP3 Models

Model name | Modelling center | Grid	| Reference(s)
--------   | --------         | ----- | --------
BCC-CSM1-1 | Beijing Climate Center, China Meteorological Administration | Atm: 128 × 64 × L26; Ocean: 360 × 232 × L40 | Xin et al. (2013)
CCSM4	| National Center for Atmospheric Research (NCAR), USA | Atm: 288 × 192 × L26; Ocean: 320 × 384 × L60	| Gent et al. (2011)
CNRM-CM5 | Centre National de la Recherche Météorologique (CNRM) & Centre Européen de Recherche et de Formation Avancées en Calcul Scientifiqque (CERFACS), France	| Atm: 256 × 128 × L31; Ocean: 362 × 292 × L42 | Voldoire et al. (2012)
CSIRO-MK3-6-0	| Queensland Climate Change Centre of Excellence (QCCCE), Australia	|	Atm: 92 × 96 × L18; Ocean: 192 × 192 × L31 |	Jeffrey et al. (2013) Rotstayn et al. (2012)
CSIRO-MK3L-1-2 | University of New South Wales, Australia	| Atm: 64 × 56 × L18; Ocean: 128 × 112 × L21|Phipps et al., 2011, Phipps et al., 2012
FGOALS-G2|Institute of Atmospheric Physics, Chinese Academy of Sciences (LASG-IAP)|Atm: 128 × 60 × L26; Ocean: 360 × 180 × L30|Li et al. (2013)
FGOALS-S2|Institute of Atmospheric Physics, Chinese Academy of Sciences (LASG-IAP)|Atm: 128 × 60 × L26; Ocean: 360 × 180 × L30|Bao et al. (2013)
GISS-E2-R|Goddard Institute for Space Studies (GISS), USA	| Atm: 144 × 90 × L40; Ocean: 288 × 180 × L32	| Schmidt et al., 2014a, Schmidt et al., 2014b
IPSL-CM5A-LR| Institut Pierre Simon Laplace (IPSL), France| Atm: 96 × 96 × L39; Ocean: 182 × 149 × L31 | Dufresne et al. (2013)
MIROC-ESM|Japan Agency for Marine-Earth Science and Technology, Atmosphere and Ocean Research Institute (The University of Tokyo), and National Institute for Environmental Studies	|Atm: 128 × 64 × L80; Ocean: 256 × 192 × L44|Sueyoshi et al. (2013) Watanabe et al. (2011)
MPI-ESM-P|Max Planck Institute für Meteorologie (MPI), Germany|Atm: 196 × 98 × L47;	Ocean: 256 × 220 × L40| Giorgetta et al. (2013)
MRI-CGCM3|Meteorological Research Institute (MRI), Japan|Atm: 20 × 160 × L48; Ocean: 364 × 368 × L51 | Yukimoto et al. (2012)

## Output Variables

Long name | CMOR/ESGF name | GISS Name	| CESM Name
--------  | -------- | ----- | --------
Surface air temperature | tas | tsurf | TREFHT
Skin Temperature | ts | - | TS
Sea level pressure | psl | slp | PSL
precipitation rate | pr | prec | PRECT
Total cloud fraction | clt | clrsky |CLDTOT
--------  | -------- | ----- | --------
Ocean grid areas | areacello | - | TAREA
Sea surface temperature | tos | sst | SST 
Sea surface salinity | sos | sss | SALT (top level only)
Meridional streamfunction | msftmyz | sf_Atl | MOC

