;This script was used to create the supplementary table for Brierley & Wainer (2018?) - although that was then tidied up in Excel to make it presentable
;It cycles through all the files in a "data" directory and calculates the standard devations of the timeseries and their correlations/regressions

; run with:
; ncl -n data_scripts/mk_mode_tables.ncl

load "scripts/cvdp_data_PMIP4-midHolocene.functions.ncl"

PRINT_OUT_CSV=False
OVERWRITE_INTERIM=True

mh_files=systemfunc("ls ../data/midHolocene/")
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
timeseries=(/"amoc_timeseries_ann","sic_nh_extent_climo"/)

modenames=array_append_record(timeseries, patterns, 0)
modes_id=ispan(0, dimsizes(modenames)-1,1)
modenames!0="modes_id"
modenames&modes_id=modes_id

modes_array=new((/dimsizes(models),dimsizes(expts),dimsizes(timeseries)+dimsizes(patterns)/),float)
modes_array@_FillValue=default_fillvalue("float")
modes_array!0="model_id"
modes_array&model_id=model_id
modes_array!1="expt_id"
modes_array&expt_id=expt_id
modes_array!2="modes_id"
modes_array&modes_id=modes_id

interim_filename="tables/modes_array.nc"
if .not.fileexists(interim_filename).or.OVERWRITE_INTERIM then
  setfileoption("nc", "Format",  "NetCDF4")
  do mod_i=0,dimsizes(models)-1
    do expt_i=0,dimsizes(expts)-1
      filenames=systemfunc("ls "+data_dir+"/"+models(mod_i)+"_"+expts(expt_i)+".cvdp_data.*-*.nc 2>/dev/null")
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
          if any(expts(expt_i).eq.(/"1pctCO2","abrupt4xCO2","rcp26","rcp85"/)) then
            ts_opt@subset=True
            ts_opt@subset_syear=-30
            ts_opt@subset_eyear=0
            ts_opt@DETREND=True
          end if
          do ts_i=0,dimsizes(timeseries)-1
            if isStrSubset(timeseries(ts_i),"global") then
               foo_str=str_sub_str(timeseries(ts_i),"mon_stddev","mon")
               modes_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,foo_str,"stddev",ts_opt)/)
               delete(foo_str)
            else
              if (timeseries(ts_i).eq."nino34_skew") then
                modes_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,"nino34","skew",ts_opt)/)
              else
                modes_array(mod_i,expt_i,ts_i)=(/stat_ts_var(filenames,timeseries(ts_i),"stddev",ts_opt)/)
              end if
            end if
          end do ;ts_i
          do patt_i=0,dimsizes(patterns)-1
            f=addfile(filenames,"r")
            if isfilevar(f,patterns(patt_i)) then
              if any(patterns(patt_i).eq.(/"tas_spatialmean_ann","pr_spatialmean_ann"/)) then
                modes_array(mod_i,expt_i,dimsizes(timeseries)+patt_i)=extract_latlon_areastat(filenames,patterns(patt_i),patterns_regions(patt_i,0,:),patterns_regions(patt_i,1,:),"mean")
                print("Global mean of "+modes_array(mod_i,expt_i,dimsizes(timeseries)+patt_i))
              else
                modes_array(mod_i,expt_i,dimsizes(timeseries)+patt_i)=extract_latlon_areastat(filenames,patterns(patt_i),patterns_regions(patt_i,0,:),patterns_regions(patt_i,1,:),"stddev")
              end if
            else
              modes_array(mod_i,expt_i,dimsizes(timeseries)+patt_i)=modes_array@_FillValue
            end if
            delete(f)
          end do
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
  ifil->modenames=modenames
  delete(ifil)
else
  ifil=addfile(interim_filename,"r")
  modes_array=ifil->modes_array
end if

if PRINT_OUT_CSV then 
  ;write out values for each timeseries 
  hlist=[/"MODEL,"+str_join(expts,",")/]
  do ts_i=0,dimsizes(timeseries)-1
    fname="tables/"+timeseries(ts_i)+".csv"
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

if PRINT_OUT_CSV then 
  ;write out values for each pattern
  hlist=[/"MODEL,"+str_join(expts,",")/]
  do patt_i=0,dimsizes(patterns)-1
    fname="tables/"+patterns(patt_i)+".csv"
    write_table(fname, "w", hlist, "%s ")
    alist=NewList("lifo")
    ListAppend(alist,models)
    format_string="%s"
    do expt_i=0,dimsizes(expts)-1
      values=modes_array(:,expt_i,dimsizes(timeseries)+patt_i)
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

;Change from piControl

;Write out the ensemble mean variance ratios
if PRINT_OUT_CSV then
  var_ratio_array=modes_array(:,1:,:)^2/conform(modes_array(:,1:,:), modes_array(:,0,:),(/0,2/))^2
  ens_mn_var_ratio=dim_avg_n(var_ratio_array,0)
  ;write out values for each timeseries
  joint = array_append_record (timeseries, patterns, 0)
  hlist=[/"MODE,"+str_join(expts(1:),",")/];avoid piControl
  fname="tables/ens_mn_var_ratio.csv"
  write_table(fname, "w", hlist, "%s ")
  alist=NewList("lifo")
  ListAppend(alist,joint)
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
