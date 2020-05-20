;It cycles through all the files in a "data" directory and calculates the standard devations of the timeseries and their correlations/regressions

; run with:
; ncl -n data_scripts/mk_ipcc_tables.ncl

load "scripts/cvdp_data_PMIP4-midHolocene.functions.ncl"

PRINT_OUT_CSV=True
OVERWRITE_INTERIM=True

;work out what models we have...
;mh_files=systemfunc("ls data/midHolocene/")
mh_files=systemfunc("(cd ~p2f-v/public_html/PMIPVarData/cvdp_data/ ; ls *_midHolocene.*nc)")
models=new(dimsizes(mh_files),string)
do mod_i=0,dimsizes(mh_files)-1
  bit_parts=str_split(mh_files(mod_i), "_")
  models(mod_i)=bit_parts(0)
end do
model_id=ispan(0, dimsizes(models)-1,1)
models!0="model_id"
models&model_id=model_id
expts=(/"piControl","midHolocene","midHolocene-cal-adj"/)
expt_id=ispan(0, dimsizes(expts)-1,1)
expts!0="expt_id"
expts&expt_id=expt_id
timeseries=(/"ipcc_GLOBAL_all_tas","ipcc_GLOBAL_lnd_tas","ipcc_GLOBAL_ocn_tas","ipcc_NH_highlats_all_tas","ipcc_NH_highlats_lnd_tas","ipcc_NH_highlats_ocn_tas","ipcc_NH_midlats_all_tas","ipcc_NH_midlats_lnd_tas","ipcc_NH_midlats_ocn_tas","ipcc_NH_tropics_all_tas","ipcc_NH_tropics_lnd_tas","ipcc_NH_tropics_ocn_tas","ipcc_SH_highlats_all_tas","ipcc_SH_highlats_lnd_tas","ipcc_SH_highlats_ocn_tas","ipcc_SH_midlats_all_tas","ipcc_SH_midlats_lnd_tas","ipcc_SH_midlats_ocn_tas","ipcc_SH_tropics_all_tas","ipcc_SH_tropics_lnd_tas","ipcc_SH_tropics_ocn_tas","ipcc_ARC_lnd_tas"/)
timeseries_id=ispan(0, dimsizes(timeseries)-1,1)
timeseries!0="timeseries_id"
timeseries&timeseries_id=timeseries_id

ipcc_array=new((/dimsizes(models),dimsizes(expts),dimsizes(timeseries)/),float)
ipcc_array!0="model_id"
ipcc_array&model_id=model_id
ipcc_array!1="expt_id"
ipcc_array!2="timeseries_id"
ipcc_array@_FillValue=default_fillvalue("float")

interim_filename="data/ipcc_array.nc"
if .not.fileexists(interim_filename).or.OVERWRITE_INTERIM then
  setfileoption("nc", "Format",  "NetCDF4")
  do mod_i=0,dimsizes(models)-1
    do expt_i=0,dimsizes(expts)-1
      ;filenames=systemfunc("ls data/"+expts(expt_i)+"/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
      filenames=systemfunc("ls ~p2f-v/public_html/PMIPVarData/cvdp_data/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
      if all(ismissing(filenames)) then 
        ipcc_array(mod_i,expt_i,:)=ipcc_array@_FillValue
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
            ipcc_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,timeseries(ts_i),"mean",ts_opt)/)
          end do ;ts_i
          delete(ts_opt)
        end if; dimsizes(filenames).ne.1
      end if; all(ismissing(filenames))  
      delete(filenames)
    end do ;expt_i
  end do ;mod_i
  system("rm -f "+interim_filename)
  ifil=addfile(interim_filename,"c")
  ifil->ipcc_array=ipcc_array
  ifil->models=models
  ifil->expts=expts
  ifil->timeseries=timeseries
  delete(ifil)
else
  ifil=addfile(interim_filename,"r")
  ipcc_array=ifil->ipcc_array
end if

if PRINT_OUT_CSV then
  ;write out values for each timeseries
  hlist=[/"MODEL,"+str_join(expts,",")/]
  ;mean 
  do ts_i=0,dimsizes(timeseries)-1
    fname="data/"+timeseries(ts_i)+".csv"
    write_table(fname, "w", hlist, "%s ")
    alist=NewList("lifo")
    ListAppend(alist,models)
    format_string="%s"
    do expt_i=0,dimsizes(expts)-1
      values=ipcc_array(:,expt_i,ts_i)
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
end if
