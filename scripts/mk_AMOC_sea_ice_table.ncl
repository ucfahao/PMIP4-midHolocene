;This script was used to create the supplementary table for Brierley & Wainer (2018?) - although that was then tidied up in Excel to make it presentable
;It cycles through all the files in a "data" directory and calculates the standard devations of the timeseries and their correlations/regressions

; run with:
; ncl -n scripts/mk_AMOC_sea_ice_table.ncl

load "scripts/cvdp_data_PMIP4-midHolocene.functions.ncl"

PRINT_OUT_CSV=True
OVERWRITE_INTERIM=True

;work out what models we have...
mh_files=systemfunc("ls data/midHolocene/")
;mh_files=systemfunc("(cd ~p2f-v/public_html/PMIPVarData/cvdp_data/ ; ls *_midHolocene.*nc)")
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
timeseries=(/"sic_nh_extent_climo","amoc_timeseries_ann"/)

modes_array=new((/dimsizes(models),dimsizes(expts),dimsizes(timeseries)/),float)
modes_array@_FillValue=default_fillvalue("float")
modes_array!0="model_id"
modes_array&model_id=model_id
modes_array!1="expt_id"
modes_array&expt_id=expt_id
modes_array!2="timeseries_id"

interim_filename="data/amoc_seaice_array.nc"
if .not.fileexists(interim_filename).or.OVERWRITE_INTERIM then
  setfileoption("nc", "Format",  "NetCDF4")
  do mod_i=0,dimsizes(models)-1
    do expt_i=0,dimsizes(expts)-1
      filenames=systemfunc("ls data/"+expts(expt_i)+"/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
      ;filenames=systemfunc("ls ~p2f-v/public_html/PMIPVarData/cvdp_data/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
      if all(ismissing(filenames)) then 
        modes_array(mod_i,expt_i,:)=modes_array@_FillValue
      else ;file exists
        if dimsizes(filenames).ne.1 then
           print("ERROR: "+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc results in multiple files")
          exit()
        else
          print("Working on "+filenames)
          ts_opt=True
          ts_opt@NO_EXIT_ON_ERROR=True
          do ts_i=0,dimsizes(timeseries)-1
            if isStrSubset(timeseries(ts_i),"extent_climo") then
               modes_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,timeseries(ts_i),"min",ts_opt)/)
            else
              modes_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,timeseries(ts_i),"mean",ts_opt)/)
            end if
          end do ;ts_i
          delete(ts_opt)
        end if; dimsizes(filenames).ne.1
      end if; all(ismissing(filenames))  
      delete(filenames)
    end do ;expt_i
  end do ;mod_i
  system("rm -f "+interim_filename)
  ifil=addfile(interim_filename,"c")
  ifil->modes_array=modes_array
  ifil->models=models
  ifil->expts=expts
  ifil->timeseries=timeseries
  delete(ifil)
else
  ifil=addfile(interim_filename,"r")
  modes_array=ifil->modes_array
end if

if PRINT_OUT_CSV then 
  ;write out values for each timeseries 
  hlist=[/"MODEL,"+str_join(expts,",")/]
  do ts_i=0,dimsizes(timeseries)-1
    fname="data/"+timeseries(ts_i)+".csv"
    write_table(fname, "w", hlist, "%s ")
    alist=NewList("lifo")
    ListAppend(alist,models)
    format_string="%s"
    do expt_i=0,dimsizes(expts)-1
      values=modes_array(:,expt_i,ts_i)
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
