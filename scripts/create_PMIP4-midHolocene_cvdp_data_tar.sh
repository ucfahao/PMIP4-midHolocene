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

# thirdly define a litte function to say whether a netcdf file has the seasonal extent of NH sea ice
function hasNHice {
  hasNHice_DIR=$1
  hasNHice_filename=$2
  hasNHice_varnames=`ncdump -h $hasNHice_DIR/$hasNHice_filename | grep float | cut -d\( -f1 | cut -d\  -f2`
  if [[ $hasNHice_varnames == *"sic_nh_extent_climo"* ]]
  then
    return 1
  else
    return 0
  fi
}  

# thirdly define a litte function to say whether a netcdf file has the seasonal extent of NH sea ice
function hasipcc {
  hasipcc_varnames=`ncdump -h $1/$2 | grep float | cut -d\( -f1 | cut -d\  -f2`
  if [[ $hasipcc_varnames == *"ipcc_NH_tropics_lnd_tas"* ]]
  then
    return 1
  else
    return 0
  fi
}  


#set up some paths and aliases
CVDP_DATA_DIR="/home/p2f-v/public_html/PMIPVarData/cvdp_data"
REPO_DATA_DIR=`pwd`"/../data" #relative to here
mean_vars="pr_spatialmean_ann,pr_spatialmean_djf,pr_spatialmean_jja,pr_spatialstddev_ann,pr_spatialstddev_djf,pr_spatialstddev_jja,tas_spatialmean_ann,tas_spatialmean_djf,tas_spatialmean_jja,tas_spatialstddev_ann,tas_spatialstddev_djf,tas_spatialstddev_jja,tas_coldestmonth,tas_coldestmonth_stddev,tas_warmestmonth,tas_warmestmonth_stddev,tas_seasonality,tas_seasonality_stddev"
monsoon_vars="monsoon_area_AUSMC,monsoon_area_EAS,monsoon_area_NAF,monsoon_area_NAMS,monsoon_area_SAF,monsoon_area_SAMS,monsoon_area_SAS,monsoon_area_global,monsoon_domain,monsoon_rain_AUSMC,monsoon_rain_EAS,monsoon_rain_NAF,monsoon_rain_NAMS,monsoon_rain_SAF,monsoon_rain_SAMS,monsoon_rain_SAS,monsoon_domain,monsoon_summer_rainrate,monsoon_intensity"
amoc_vars="amoc_mean_ann,amoc_timeseries_ann"
ice_vars="sic_nh_extent_climo"
ipcc_vars="ipcc_GLOBAL_all_tas,ipcc_GLOBAL_lnd_tas,ipcc_GLOBAL_ocn_tas,ipcc_NH_highlats_all_tas,ipcc_NH_highlats_lnd_tas,ipcc_NH_highlats_ocn_tas,ipcc_NH_midlats_all_tas,ipcc_NH_midlats_lnd_tas,ipcc_NH_midlats_ocn_tas,ipcc_NH_tropics_all_tas,ipcc_NH_tropics_lnd_tas,ipcc_NH_tropics_ocn_tas,ipcc_SH_highlats_all_tas,ipcc_SH_highlats_lnd_tas,ipcc_SH_highlats_ocn_tas,ipcc_SH_midlats_all_tas,ipcc_SH_midlats_lnd_tas,ipcc_SH_midlats_ocn_tas,ipcc_SH_tropics_all_tas,ipcc_SH_tropics_lnd_tas,ipcc_SH_tropics_ocn_tas"

#Collect all the relevant data from the files
cd $CVDP_DATA_DIR
ncfiles=`ls *{piControl,midHolocene-cal-adj,midHolocene}.cvdp_data.*-*.nc`
echo $ncfiles
cd $REPO_DATA_DIR
mkdir -p piControl midHolocene-cal-adj midHolocene
for ncfile in $ncfiles
do
  echo working on $ncfile
  case $ncfile in
    *"piControl"*)
       sub_dir="piControl";;
    *"midHolocene-cal-adj"*)
        sub_dir="midHolocene-cal-adj";;
    *"midHolocene"*)
        sub_dir="midHolocene";;
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
    ncks -A -v $amoc_vars $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
  fi
  hasNHice $CVDP_DATA_DIR $ncfile
  if [ $? == 1 ]; then
    ncks -A -v $ice_vars $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
  fi
  hasipcc $CVDP_DATA_DIR $ncfile
  if [ $? == 1 ]; then
    ncks -A -v $ipcc_vars $CVDP_DATA_DIR/$ncfile $sub_dir/$ncfile
  fi
done

#plus a couple of obs datasets
ncks -O -v pr_spatialmean_ann,pr_spatialmean_djf,pr_spatialmean_jja,pr_spatialstddev_ann,pr_spatialstddev_djf,pr_spatialstddev_jja\
  $CVDP_DATA_DIR/GPCP.cvdp_data.1979-2019.nc GPCP.cvdp_data.1979-2019.nc
ncks -A -v $monsoon_vars $CVDP_DATA_DIR/GPCP.cvdp_data.1979-2019.nc GPCP.cvdp_data.1979-2019.nc

ncks -O -v $mean_vars $CVDP_DATA_DIR/C20-Reanalysis.cvdp_data.1871-2012.nc C20-Reanalysis.cvdp_data.1871-2012.nc
ncks -A -v $monsoon_vars $CVDP_DATA_DIR/C20-Reanalysis.cvdp_data.1871-2012.nc C20-Reanalysis.cvdp_data.1871-2012.nc
ncks -A -v $ice_vars $CVDP_DATA_DIR/C20-Reanalysis.cvdp_data.1871-2012.nc C20-Reanalysis.cvdp_data.1871-2012.nc
ncks -A -v $ipcc_vars $CVDP_DATA_DIR/C20-Reanalysis.cvdp_data.1871-2012.nc C20-Reanalysis.cvdp_data.1871-2012.nc

#make a .tar.gz archive
#rm PMIP4_midHolocence_cvdp_data.tar.gz
#tar -czf PMIP4_midHolocence_cvdp_data.tar.gz */*.cvdp_data.*-*.nc C20-Reanalysis.cvdp_data.1871-2012.nc GPCP.cvdp_data.1979-2019.nc
#cp PMIP4_midHolocence_cvdp_data.tar.gz ~/public_html/PMIPVarData/data/PMIP4_midHolocence_cvdp_data.tar.gz

##Populate for_DMC directory
#mkdir for_DMC
#cd for_DMC
#files=`ls /data/CMIP/curated_ESGF_replica/*/midHolocene-cal-adj/preprocessed/*pollen*.nc`
#for fil in $files
#do
#  ln -s $fil ${fil##*/}
#done
#rm PMIP34_midHolocene_changes_for_DMC.zip
#zip PMIP34_midHolocene_changes_for_DMC.zip *pollen*nc
#cp PMIP34_midHolocene_changes_for_DMC.zip ~/public_html/PMIPVarData/data/PMIP34_midHolocene_changes_for_DMC.zip
