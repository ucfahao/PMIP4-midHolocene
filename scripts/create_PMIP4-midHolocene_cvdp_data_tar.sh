#!/bin/bash
# This script will create a .tar.gz file containing the data and put it on a sensible web-location for downloading.
# Written by Chris Brierley and only to be used by Chris (relies on stuff on UCL server).

#first define a litte function to say whether a netcdf file has required variables
function hasMHvars {
  hasMHvars_DIR=$1
  hasMHvars_filename=$2
  hasMHvars_varnames=`ncdump -h $hasMHvars_DIR/$hasMHvars_filename | grep float | cut -d\( -f1 | cut -d\  -f2`
  if [[ $hasMHvars_varnames == *"pr_spatialmean_ann"* ]] && [[ $hasMHvars_varnames == *"tas_spatialmean_ann"* ]] && [[ $hasMHvars_varnames == *"monsoon_domain"* ]]
  then
    return 1
  else
    return 0
  fi
}  

# second define a litte function to say whether a netcdf file has the amoc variables
function hasAMOC {
  hasAMOC_DIR=$1
  hasAMOC_filename=$2
  hasAMOC_varnames=`ncdump -h $hasAMOC_DIR/$hasAMOC_filename | grep float | cut -d\( -f1 | cut -d\  -f2`
  if [[ $hasAMOC_varnames == *"amoc_mean_ann"* ]]
  then
    return 1
  else
    return 0
  fi
}  


CVDP_DATA_DIR="/data/p2f/cvdp_data"
REPO_DATA_DIR=`pwd`"/../data" #relative to here
mean_vars="pr_spatialmean_ann,pr_spatialmean_djf,pr_spatialmean_jja,pr_spatialmean_mam,pr_spatialmean_son,pr_spatialstddev_ann,pr_spatialstddev_djf,pr_spatialstddev_jja,pr_spatialstddev_mam,pr_spatialstddev_son,tas_spatialmean_ann,tas_spatialmean_djf,tas_spatialmean_jja,tas_spatialmean_mam,tas_spatialmean_son,tas_spatialstddev_ann,tas_spatialstddev_djf,tas_spatialstddev_jja,tas_spatialstddev_mam,tas_spatialstddev_son"
monsoon_vars="monsoon_area_AUSMC,monsoon_area_EAS,monsoon_area_NAF,monsoon_area_NAMS,monsoon_area_SAF,monsoon_area_SAMS,monsoon_area_SAS,monsoon_area_global,monsoon_domain,monsoon_rain_AUSMC,monsoon_rain_EAS,monsoon_rain_NAF,monsoon_rain_NAMS,monsoon_rain_SAF,monsoon_rain_SAMS,monsoon_rain_SAS,monsoon_rain_global"

cd $CVDP_DATA_DIR
ncfiles=`ls *{piControl,historical,midHolocene-cal-adj,midHolocene,abrupt4xCO2}.cvdp_data.*-*.nc`
echo $ncfiles
cd $REPO_DATA_DIR
mkdir -p piControl historical midHolocene-cal-adj midHolocene abrupt4xCO2
for ncfile in $ncfiles
do
  echo working on $ncfile
  case $ncfile in
    *"piControl"*)
       sub_dir="piControl";;
    *"historical"*)
        sub_dir="historical";;
    *"midHolocene-cal-adj"*)
        sub_dir="midHolocene-cal-adj";;
    *"midHolocene"*)
        sub_dir="midHolocene";;
    *"abrupt4xCO2"*)
        sub_dir="abrupt4xCO2";;
    *)
        echo "INVALID FILE";;
  esac
  hasMHvars $CVDP_DATA_DIR $ncfile
  if [ $? == 1 ]; then
    ncks -O -v $mean_vars $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
    ncks -A -v $monsoon_vars $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
  fi
  hasAMOC $CVDP_DATA_DIR $ncfile
  if [ $? == 1 ]; then
    ncks -A -v amoc_mean_ann $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
  fi
done

#plus a couple of obs datasets
ncks -O -v pr_spatialmean_ann,pr_spatialmean_djf,pr_spatialmean_jja,pr_spatialmean_mam,pr_spatialmean_son,\
pr_spatialstddev_ann,pr_spatialstddev_djf,pr_spatialstddev_jja,pr_spatialstddev_mam,pr_spatialstddev_son,\
monsoon_area_AUSMC,monsoon_area_EAS,monsoon_area_NAF,monsoon_area_NAMS,monsoon_area_SAF,monsoon_area_SAMS,\
monsoon_area_SAS,monsoon_area_global,monsoon_domain,monsoon_rain_AUSMC,monsoon_rain_EAS,monsoon_rain_NAF,\
monsoon_rain_NAMS,monsoon_rain_SAF,monsoon_rain_SAMS,monsoon_rain_SAS,monsoon_rain_global\
  $CVDP_DATA_DIR/GPCP.cvdp_data.1979-1999.nc GPCP.cvdp_data.1979-1999.nc

ncks -O -v pr_spatialmean_ann,pr_spatialmean_djf,pr_spatialmean_jja,pr_spatialmean_mam,pr_spatialmean_son,\
pr_spatialstddev_ann,pr_spatialstddev_djf,pr_spatialstddev_jja,pr_spatialstddev_mam,pr_spatialstddev_son,\
tas_spatialmean_ann,tas_spatialmean_djf,tas_spatialmean_jja,tas_spatialmean_mam,tas_spatialmean_son,\
tas_spatialstddev_ann,tas_spatialstddev_djf,tas_spatialstddev_jja,tas_spatialstddev_mam,tas_spatialstddev_son,\
monsoon_area_AUSMC,monsoon_area_EAS,monsoon_area_NAF,monsoon_area_NAMS,monsoon_area_SAF,monsoon_area_SAMS,\
monsoon_area_SAS,monsoon_area_global,monsoon_domain,monsoon_rain_AUSMC,monsoon_rain_EAS,monsoon_rain_NAF,\
monsoon_rain_NAMS,monsoon_rain_SAF,monsoon_rain_SAMS,monsoon_rain_SAS,monsoon_rain_global\
  $CVDP_DATA_DIR/C20-Reanalysis.cvdp_data.1871-2012.nc C20-Reanalysis.cvdp_data.1871-2012.nc

#make a .tar.gz archive
rm PMIP4_midHolocence_cvdp_data.tar.gz
tar -czf PMIP4_midHolocence_cvdp_data.tar.gz */*.cvdp_data.*-*.nc C20-Reanalysis.cvdp_data.1871-2012.nc GPCP.cvdp_data.1979-1999.nc
cp PMIP4_midHolocence_cvdp_data.tar.gz ~/public_html/PMIPVarData/data/PMIP4_midHolocence_cvdp_data.tar.gz
