;It cycles through all the files in a "data" directory and calculates the standard devations of the timeseries and their correlations/regressions

; run with:
; ncl -n data_scripts/mk_ipcc_tables.ncl

load "data_scripts/cvdp_data.functions.ncl"

PRINT_OUT_CSV=False
OVERWRITE_INTERIM=True

data_dir="/data/aod/cvdp_PVar_kira/cvdp_data"

models=systemfunc("ls -I README -I C20-Reanalysis /data/CMIP/curated_ESGF_replica")
model_id=ispan(0, dimsizes(models)-1,1)
models!0="model_id"
models&model_id=model_id
expts=(/"piControl","midHolocene"/)
expt_id=ispan(0, dimsizes(expts)-1,1)
expts!0="expt_id"
expts&expt_id=expt_id
timeseries=(/"ipcc_ALA_pr","ipcc_ALA_tas","ipcc_AMZ_pr","ipcc_AMZ_tas","ipcc_ANT_lnd_pr","ipcc_ANT_lnd_tas","ipcc_ANT_ocn_pr","ipcc_ANT_ocn_tas","ipcc_ARC_lnd_pr","ipcc_ARC_lnd_tas","ipcc_ARC_ocn_pr","ipcc_ARC_ocn_tas","ipcc_CAM_pr","ipcc_CAM_tas","ipcc_CAR_pr","ipcc_CAR_tas","ipcc_CAS_pr","ipcc_CAS_tas","ipcc_CEU_pr","ipcc_CEU_tas","ipcc_CGI_pr","ipcc_CGI_tas","ipcc_CNA_pr","ipcc_CNA_tas","ipcc_EAF_pr","ipcc_EAF_tas","ipcc_EAS_pr","ipcc_EAS_tas","ipcc_ENA_pr","ipcc_ENA_tas","ipcc_ETP_pr","ipcc_ETP_tas","ipcc_GLOBAL_all_pr","ipcc_GLOBAL_all_tas","ipcc_GLOBAL_lnd_pr","ipcc_GLOBAL_lnd_tas","ipcc_GLOBAL_ocn_pr","ipcc_GLOBAL_ocn_tas","ipcc_MED_pr","ipcc_MED_tas","ipcc_NAS_pr","ipcc_NAS_tas","ipcc_NAU_pr","ipcc_NAU_tas","ipcc_NEB_pr","ipcc_NEB_tas","ipcc_NEU_pr","ipcc_NEU_tas","ipcc_NTP_pr","ipcc_NTP_tas","ipcc_SAF_pr","ipcc_SAF_tas","ipcc_SAH_pr","ipcc_SAH_tas","ipcc_SAS_lnd_pr","ipcc_SAS_lnd_tas","ipcc_SAS_ocn_pr","ipcc_SAS_ocn_tas","ipcc_SAU_pr","ipcc_SAU_tas","ipcc_SEA_lnd_pr","ipcc_SEA_lnd_tas","ipcc_SEA_ocn_pr","ipcc_SEA_ocn_tas","ipcc_SSA_pr","ipcc_SSA_tas","ipcc_STP_pr","ipcc_STP_tas","ipcc_TIB_pr","ipcc_TIB_tas","ipcc_WAF_pr","ipcc_WAF_tas","ipcc_WAS_pr","ipcc_WAS_tas","ipcc_WIO_pr","ipcc_WIO_tas","ipcc_WNA_pr","ipcc_WNA_tas","ipcc_WSA_pr","ipcc_WSA_tas","monsoon_area_AUSMC","monsoon_area_EAS","monsoon_area_NAF","monsoon_area_NAMS","monsoon_area_SAF","monsoon_area_SAMS","monsoon_area_SAS","monsoon_area_global","monsoon_rain_AUSMC","monsoon_rain_EAS","monsoon_rain_NAF","monsoon_rain_NAMS","monsoon_rain_SAF","monsoon_rain_SAMS","monsoon_rain_SAS","monsoon_rain_global"/)
timeseries_id=ispan(0, dimsizes(timeseries)-1,1)
timeseries!0="timeseries_id"
timeseries&timeseries_id=timeseries_id


ipcc_region_array=new((/dimsizes(models),dimsizes(expts),dimsizes(timeseries),2/),float)
ipcc_region_array!0="model_id"
ipcc_region_array&model_id=model_id
ipcc_region_array!1="expt_id"
ipcc_region_array!2="timeseries_id"
ipcc_region_array!3="stddev_not_mean"
ipcc_region_array@_FillValue=default_fillvalue("float")

interim_filename="tables/ipcc_region_array.nc"
if .not.fileexists(interim_filename).or.OVERWRITE_INTERIM then
  setfileoption("nc", "Format",  "NetCDF4")
  do mod_i=0,dimsizes(models)-1
    do expt_i=0,dimsizes(expts)-1
      filenames=systemfunc("ls "+data_dir+"/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
      if all(ismissing(filenames)) then 
        ipcc_region_array(mod_i,expt_i,:,:)=ipcc_region_array@_FillValue
      else ;file exists
        if dimsizes(filenames).ne.1 then
          print("ERROR: "+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc results in multiple files")
          exit()
        else
          print("Working on "+filenames)
          ts_opt=True
          ts_opt@NO_EXIT_ON_ERROR=True
          ts_opt@make_absolute=True
          if any(expts(expt_i).eq.(/"1pctCO2","abrupt4xCO2"/)) then
            ts_opt@subset=True
            ts_opt@subset_syear=-30
            ts_opt@subset_eyear=0
            ts_opt@DETREND=True
          end if
          do ts_i=0,dimsizes(timeseries)-1
            ipcc_region_array(mod_i,expt_i,ts_i,0)=(/stat_ts_var(filenames,timeseries(ts_i),"mean",ts_opt)/)
            ipcc_region_array(mod_i,expt_i,ts_i,1)=(/stat_ts_var(filenames,timeseries(ts_i),"stddev",ts_opt)/)
          end do ;ts_i
          delete(ts_opt)
        end if; dimsizes(filenames).ne.1
      end if; all(ismissing(filenames))  
      delete(filenames)
    end do ;expt_i
  end do ;mod_i
  system("rm -f "+interim_filename)
  ifil=addfile(interim_filename,"c")
  ifil->ipcc_region_array=ipcc_region_array
  ifil->models=models
  ifil->expts=expts
  ifil->timeseries=timeseries
  delete(ifil)
else
  ifil=addfile(interim_filename,"r")
  ipcc_region_array=ifil->ipcc_region_array
end if

if PRINT_OUT_CSV then
  ;write out values for each timeseries
  hlist=[/"MODEL,"+str_join(expts,",")/]
  ;mean 
  do ts_i=0,dimsizes(timeseries)-1
    fname="tables/"+timeseries(ts_i)+"_mean.csv"
    write_table(fname, "w", hlist, "%s ")
    alist=NewList("lifo")
    ListAppend(alist,models)
    format_string="%s"
    do expt_i=0,dimsizes(expts)-1
      values=ipcc_region_array(:,expt_i,ts_i,0)
      values@_FillValue=-999.
      str = unique_string("polymarker")
      values@$str$=values
      ListAppend(alist,values@$str$)
      format_string=format_string+",%5.2f"
    end do
    write_table(fname, "a", alist,format_string)
    delete([/alist,values,format_string,fname/])
  end do ;loop over timeseries 
  ;stddev
  do ts_i=0,dimsizes(timeseries)-1
    fname="tables/"+timeseries(ts_i)+"_stddev.csv"
    write_table(fname, "w", hlist, "%s ")
    alist=NewList("lifo")
    ListAppend(alist,models)
    format_string="%s"
    do expt_i=0,dimsizes(expts)-1
      values=ipcc_region_array(:,expt_i,ts_i,1)
      values@_FillValue=-999.
      str = unique_string("polymarker")
      values@$str$=values
      ListAppend(alist,values@$str$)
      format_string=format_string+",%5.2f"
    end do
    write_table(fname, "a", alist,format_string)
    delete([/alist,values,format_string,fname/])
  end do ;loop over timeseries 
  delete(hlist)

  ;Change from piControl
  var_ratio_array=ipcc_region_array(:,1:,:)^2/conform(ipcc_region_array(:,1:,:),ipcc_region_array(:,0,:),(/0,2/))^2
  ens_mn_var_ratio=dim_avg_n(var_ratio_array,0)

  ;Write out the ensemble mean variance ratios
  ;write out values for each timeseries
  hlist=[/"TIMESERIES,"+str_join(expts(1:),",")/];avoid piControl
  fname="tables/ens_mn_var_ratio.csv"
  write_table(fname, "w", hlist, "%s ")
  alist=NewList("lifo")
  ListAppend(alist,timeseries)
  format_string="%s"
  do expt_i=0,dimsizes(expts)-2
    values=ens_mn_var_ratio(expt_i,:)
    values@_FillValue=-999.
    str = unique_string("polymarker")
    values@$str$=values
    ListAppend(alist,values@$str$)
    format_string=format_string+",%5.2f"
  end do
  write_table(fname, "a", alist,format_string)
  delete([/hlist,alist,values,format_string,fname/])
end if
