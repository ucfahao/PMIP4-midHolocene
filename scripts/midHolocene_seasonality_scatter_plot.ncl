load "/home/ucfaccb/Documents/local_repos/cvdp_pmip/data_scripts/cvdp_data.functions.ncl"

data_dir="/home/p2f-v/public_html/PMIPVarData/cvdp_data"
plot_dir="../plots"
VERBOSE=True
PRINT_OUT_CSV=True
GMT_for_Y=False
BARTLEIN_EURASIA=False


;Dependent variable
X_VARNAME="climate_sensitivity"         
X_VARNAME@STAT="mean"
X_VARNAME@ABS=True
X_VARNAME@SEASON="DJF"
X_VARNAME@PCT_CHANGES=False
X_VARNAME@pdf=True

;Independent variable
if GMT_for_Y then 
  Y_VARNAME="tas_spatialmean_ann"
  Y_VARNAME@STAT="mean"; mean, stddev, skew, kurtosis, pcvar
  Y_VARNAME@LATLON=True
  Y_VARNAME@MINLAT=-90.
  Y_VARNAME@MAXLAT=90.
  Y_VARNAME@MINLON=0.
  Y_VARNAME@MAXLON=360.
  Y_VARNAME@EXPT="midHolocene" ; select a particular experiment; "all" or "missing" selects all experiments
  X_VARNAME@EXPT="midHolocene"
else
  if BARTLEIN_EURASIA then
    Y_VARNAME="tas_seasonality"
    Y_VARNAME@STAT="mean"; mean, stddev, skew, kurtosis, pcvar
    Y_VARNAME@LATLON=True
    Y_VARNAME@MINLAT=30.
    Y_VARNAME@MAXLAT=60.
    Y_VARNAME@MINLON=30.
    Y_VARNAME@MAXLON=120.
  else
    Y_VARNAME="ipcc_CAS_tas"
    Y_VARNAME@STAT="AnnCycAmp"; mean, stddev, skew, kurtosis, pcvar
  end if
  Y_VARNAME@EXPT="midHolocene-cal-adj" ; select a particular experiment; "all" or "missing" selects all experiments
  X_VARNAME@EXPT="midHolocene-cal-adj"
end if
Y_VARNAME@SEASON="ANN"
Y_VARNAME@ABS=True; determines whether to set ts_opt@make_absolute=True
Y_VARNAME@PCT_CHANGES=False



  ;Dependent variable
  SCATTER_X_VARNAME=X_VARNAME
  SCATTER_X_STAT=X_VARNAME@STAT; mean, stddev, skew, kurtosis, pcvar
  SCATTER_X_ABS=X_VARNAME@ABS; determines whether to set ts_opt@make_absolute=True
  SCATTER_X_SEASON=X_VARNAME@SEASON ; determines which season to compute (for monthly timeseries)
  SCATTER_X_PCT_CHANGES=X_VARNAME@PCT_CHANGES
  SCATTER_X_EXPT=X_VARNAME@EXPT ; select a particular experiment; "all" or "missing" selects all experiments
  if isatt(X_VARNAME,"2DVAR").and.(X_VARNAME@LATLON) then
    SCATTER_X_2DVAR=X_VARNAME@LATLON
    SCATTER_X_MINLAT=X_VARNAME@MINLAT
    SCATTER_X_MAXLAT=X_VARNAME@MAXLAT
    SCATTER_X_MINLON=X_VARNAME@MINLON
    SCATTER_X_MAXLON=X_VARNAME@MAXLON
  else
    SCATTER_X_2DVAR=False 
  end if

  ;Independent variable
  SCATTER_Y_VARNAME=Y_VARNAME
  SCATTER_Y_STAT=Y_VARNAME@STAT; mean, stddev, skew, kurtosis, pcvar
  SCATTER_Y_ABS=Y_VARNAME@ABS; determines whether to set ts_opt@make_absolute=True
  SCATTER_Y_SEASON=Y_VARNAME@SEASON ; determines which season to compute (for monthly timeseries)
  SCATTER_Y_PCT_CHANGES=Y_VARNAME@PCT_CHANGES
  SCATTER_Y_EXPT=Y_VARNAME@EXPT ; select a particular experiment; "all" or "missing" selects all experiments
  if isatt(Y_VARNAME,"LATLON").and.(Y_VARNAME@LATLON) then
    SCATTER_Y_2DVAR=Y_VARNAME@LATLON
    SCATTER_Y_MINLAT=Y_VARNAME@MINLAT
    SCATTER_Y_MAXLAT=Y_VARNAME@MAXLAT
    SCATTER_Y_MINLON=Y_VARNAME@MINLON
    SCATTER_Y_MAXLON=Y_VARNAME@MAXLON
  else
    SCATTER_Y_2DVAR=False 
  end if


OUTPUT_TYPE="pdf"
 
  expts=(/"piControl","midHolocene","midHolocene-cal-adj","lgm","lig127k","1pctCO2","abrupt4xCO2"/)
  expts_color=(/"grey24","darkgreen","darkgreen","dodgerblue4","yellowgreen","firebrick","orangered2"/)
  gcms=(/"AWI-CM-1-1-LR","BCC-CSM1-1","CCSM4","CESM2","CNRM-CM5","COSMOS-ASO","CSIRO-Mk3-6-0","CSIRO-Mk3L-1-2","EC-EARTH-2-2","FGOALS-g3","FGOALS-f3-L","FGOALS-g2","FGOALS-s2","GISS-E2-1-G","GISS-E2-R","HadCM3","HadGEM2-CC","HadGEM2-ES","HadGEM3-GC31","INM-CM4-8","IPSL-CM5A-LR","IPSL-CM6A-LR","KCM1-2-2","MIROC-ES2L","MIROC-ESM","MPI-ESM-P","MRI-CGCM3","MRI-ESM2-0","NESM3","NorESM1-F","UofT-CCSM-4"/)
  ECS=(/ 3.6           ,3.1         , 2.9   , 5.2   , 3.3      , -999.      , 4.1           , 3.1            , 4.2          ,2.9        ,3.           , 3.7       , 4.5       , 2.7         , 2.1       , 3.3    , 4.5        , 4.6        , 5.4          ,2.1        ,4.1           , 4.5          , -999.    ,2.66        , 4.7       , 3.5       , 2.6       , 3.1        , 3.7   ,2.29     , 3.2/)
  isCMIP6=(/True           ,False       ,False  ,True   ,False     ,False       ,False          ,False           ,False         ,True       ,True         ,False      ,False      ,True         ,False      ,False   ,False       ,False       ,True          ,True       ,False         ,True          ,False     ,True        ,False      ,False      ,False      ,True       ,True   ,True       ,True/)
  ECS@_FillValue=-999.
  alphabet=(/"a","b","c","d","e","f","g","h","i","j","k","l"/)

  plotname="SCATTER_"+SCATTER_X_EXPT+"-expt_"+SCATTER_X_STAT+"_"+SCATTER_X_VARNAME+"_vs_"+SCATTER_Y_EXPT+"-expt_"+SCATTER_Y_STAT+"_"+SCATTER_Y_VARNAME+"."+OUTPUT_TYPE

  dY=new((/dimsizes(gcms),dimsizes(expts)-1/),float);array to hold variability change
  dY=(/dY@_FillValue/)
  dX=new((/dimsizes(gcms),dimsizes(expts)-1/),float);array to hold mean state change
  dX=(/dX@_FillValue/)
  ts_opt=True
  ts_opt@NO_EXIT_ON_ERROR=True
  ts_transient=ts_opt
  ts_transient@subset=True
  ts_transient@subset_syear=-30
  ts_transient@subset_eyear=0
  ts_transient@DETREND=True

  ;do some quick checks...
  possible_expt_settings=array_append_record(expts,(/"all","missing"/),0)
  if .not.any(SCATTER_Y_EXPT.eq.possible_expt_settings).or..not.any(SCATTER_Y_EXPT.ne.possible_expt_settings) then
    print("You've set SCATTER_X_EXPT as "+SCATTER_X_EXPT+" and SCATTER_Y_EXPT as "+SCATTER_Y_EXPT)
    print("The only possible values for these are: "+str_join(possible_expt_settings,","))
    exit
  end if

  if any(SCATTER_X_EXPT.eq.(/"all","missing"/)) then
    if any(SCATTER_Y_EXPT.eq.(/"all","missing"/)) then
      if VERBOSE then
        print("Selecting all experiments and plotting on a single graph")
      end if
      ALL_EXPTS=True
    else
      print("You've set SCATTER_X_EXPT as "+SCATTER_X_EXPT+" (so selecting all experiments), but SCATTER_Y_EXPT as "+SCATTER_Y_EXPT)
      print("I don't see how that can be plotted, so am exiting now")
      exit
    end if
  else
    if any(SCATTER_Y_EXPT.eq.(/"all","missing"/)) then
      print("You've set SCATTER_X_EXPT as "+SCATTER_X_EXPT+" (so selecting all experiments), but SCATTER_Y_EXPT as "+SCATTER_Y_EXPT)
      print("I don't see how that can be plotted, so am exiting now")
      exit
    else
      if VERBOSE then
        print("Selecting X axis as "+SCATTER_X_EXPT+" and Y axis as "+SCATTER_Y_EXPT)
      end if
      ALL_EXPTS=False
      X_expt_i=ind(expts.eq.SCATTER_X_EXPT)
      Y_expt_i=ind(expts.eq.SCATTER_Y_EXPT)
    end if
  end if

  ;collect all the data
  do expt_i=1,dimsizes(expts)-1
    if VERBOSE then
      print("Working on data for scatter plot for expt "+expt_i+": "+expts(expt_i))
    end if
    if any(expts(expt_i).eq.(/"1pctCO2","abrupt4xCO2","rcp85"/)) then
      ts_a=ts_transient
      ts_b=ts_opt
    else  
      ts_a=ts_opt
      ts_b=ts_opt
    end if
    ;collect the X_Variable changes
    if SCATTER_X_ABS then 
      ts_a@make_absolute=True
      ts_b@make_absolute=True
    end if
    if .not.any((/isStrSubset(SCATTER_X_VARNAME,"ann"),isStrSubset(SCATTER_X_VARNAME,"djf"),\
      isStrSubset(SCATTER_X_VARNAME,"mam"),isStrSubset(SCATTER_X_VARNAME,"jja"),\
      isStrSubset(SCATTER_X_VARNAME,"son"),isStrSubset(SCATTER_X_VARNAME,"monsoon")/)) then 
      ts_a@SEASON=SCATTER_X_SEASON
      ts_b@SEASON=SCATTER_X_SEASON
    end if
    if ALL_EXPTS.or.(expt_i.eq.X_expt_i) then
      do gcm_i=0,dimsizes(gcms)-1
        if SCATTER_X_VARNAME.eq."climate_sensitivity" then
          dX(gcm_i,expt_i-1)=ECS(gcm_i)
        else
          if SCATTER_X_2DVAR then
            fnames_both=find_pair_files_wVar(data_dir,expts(expt_i),"piControl",SCATTER_X_VARNAME)       
            X_a=extract_latlon_areastat(fnames_both(gcm_i,0),SCATTER_X_VARNAME,(/SCATTER_X_MINLAT,SCATTER_X_MAXLAT/),(/SCATTER_X_MINLON,SCATTER_X_MAXLON/),SCATTER_X_STAT)
            X_b=extract_latlon_areastat(fnames_both(gcm_i,1),SCATTER_X_VARNAME,(/SCATTER_X_MINLAT,SCATTER_X_MAXLAT/),(/SCATTER_X_MINLON,SCATTER_X_MAXLON/),SCATTER_X_STAT)
            if .not.ALL_EXPTS then
              if SCATTER_X_PCT_CHANGES then
                dX(gcm_i,1)=100.*(X_a-X_b)/X_b
              else
                dX(gcm_i,1)=X_a-X_b
              end if
            else
              if SCATTER_X_PCT_CHANGES then
                dX(gcm_i,expt_i-1)=100.*(X_a-X_b)/X_b
              else
                dX(gcm_i,expt_i-1)=X_a-X_b
              end if
            end if
            delete([/X_a,X_b/])
          else
            piC_file=find_files_wVar(data_dir,gcms(gcm_i)+"_piControl",SCATTER_X_VARNAME)
            piC_file@_FillValue=default_fillvalue(typeof(piC_file))
            expt_file=find_files_wVar(data_dir,gcms(gcm_i)+"_"+expts(expt_i)+".",SCATTER_X_VARNAME)
            expt_file@_FillValue=default_fillvalue(typeof(expt_file))
            if VERBOSE then
              print(SCATTER_X_VARNAME+": "+expt_file+" and "+piC_file)
            end if
            if .not.any((/ismissing(piC_file),ismissing(expt_file)/)) then
              X_a=stat_ts_var(expt_file,SCATTER_X_VARNAME,SCATTER_X_STAT,ts_a)
              X_b=stat_ts_var(piC_file,SCATTER_X_VARNAME,SCATTER_X_STAT,ts_b)
              if .not.ALL_EXPTS then
                if SCATTER_X_PCT_CHANGES then
                  dX(gcm_i,0)=100.*(X_a-X_b)/X_b
                else
                  dX(gcm_i,0)=X_a-X_b
                end if
              else
                if SCATTER_X_PCT_CHANGES then
                  dX(gcm_i,expt_i-1)=100.*(X_a-X_b)/X_b
                else
                  dX(gcm_i,expt_i-1)=X_a-X_b
                end if
              end if
              delete([/X_a,X_b/])
            end if
            delete([/piC_file,expt_file/])
          end if
        end if
      end do
    end if

    ;Now collect the Y_Variable changes
    delete([/ts_a,ts_b/])
    if any(expts(expt_i).eq.(/"1pctCO2","abrupt4xCO2","rcp85"/)) then
      ts_a=ts_transient
      ts_b=ts_opt
    else  
      ts_a=ts_opt
      ts_b=ts_opt
    end if
    if SCATTER_Y_ABS then 
      ts_a@make_absolute=True
      ts_b@make_absolute=True
    end if
    if .not.any((/isStrSubset(SCATTER_Y_VARNAME,"ann"),isStrSubset(SCATTER_Y_VARNAME,"djf"),\
      isStrSubset(SCATTER_Y_VARNAME,"mam"),isStrSubset(SCATTER_Y_VARNAME,"jja"),\
      isStrSubset(SCATTER_Y_VARNAME,"son"),isStrSubset(SCATTER_Y_VARNAME,"monsoon")/)) then 
      ts_a@SEASON=SCATTER_Y_SEASON  
      ts_b@SEASON=SCATTER_Y_SEASON
    end if
    if ALL_EXPTS.or.(expt_i.eq.Y_expt_i) then
      do gcm_i=0,dimsizes(gcms)-1
        if SCATTER_Y_VARNAME.eq."climate_sensitivity" then
          if .not.ALL_EXPTS then
            dY(gcm_i,0)=ECS(gcm_i)
          else
            dY(gcm_i,expt_i-1)=ECS(gcm_i)
          end if
        else
          if SCATTER_Y_2DVAR then
            piC_file=find_files_wVar(data_dir,gcms(gcm_i)+"_piControl",SCATTER_Y_VARNAME)
            piC_file@_FillValue=default_fillvalue(typeof(piC_file))
            expt_file=find_files_wVar(data_dir,gcms(gcm_i)+"_"+expts(expt_i)+".",SCATTER_Y_VARNAME)
            expt_file@_FillValue=default_fillvalue(typeof(expt_file))
            if VERBOSE then
              print(SCATTER_Y_VARNAME+": "+expt_file+" and "+piC_file)
            end if
            if .not.any((/ismissing(piC_file),ismissing(expt_file)/)) then
              Y_a=extract_latlon_areastat(expt_file,SCATTER_Y_VARNAME,(/SCATTER_Y_MINLAT,SCATTER_Y_MAXLAT/),(/SCATTER_Y_MINLON,SCATTER_Y_MAXLON/),SCATTER_Y_STAT)
              Y_b=extract_latlon_areastat(piC_file,SCATTER_Y_VARNAME,(/SCATTER_Y_MINLAT,SCATTER_Y_MAXLAT/),(/SCATTER_Y_MINLON,SCATTER_Y_MAXLON/),SCATTER_Y_STAT)
              if .not.ALL_EXPTS then
                if SCATTER_Y_PCT_CHANGES then
                 dY(gcm_i,0)=100.*(Y_a-Y_b)/Y_b
                else
                 dY(gcm_i,0)=Y_a-Y_b
                end if
              else
                if SCATTER_Y_PCT_CHANGES then
                  dY(gcm_i,expt_i-1)=100.*(Y_a-Y_b)/Y_b
                else
                  dY(gcm_i,expt_i-1)=Y_a-Y_b
                end if
                if VERBOSE then
                  print(fnames_both(gcm_i,1)+": Y_a="+Y_a+", Y_b="+Y_b)
                end if
              end if
              delete([/Y_a,Y_b/])
            end if
          else
            piC_file=find_files_wVar(data_dir,gcms(gcm_i)+"_piControl",SCATTER_Y_VARNAME)
            piC_file@_FillValue=default_fillvalue(typeof(piC_file))
            expt_file=find_files_wVar(data_dir,gcms(gcm_i)+"_"+expts(expt_i)+".",SCATTER_Y_VARNAME)
            expt_file@_FillValue=default_fillvalue(typeof(expt_file))
            if VERBOSE then
              print(SCATTER_Y_VARNAME+": "+expt_file+" and "+piC_file)
            end if
            if .not.any((/ismissing(piC_file),ismissing(expt_file)/)) then
              Y_a=stat_ts_var(expt_file,SCATTER_Y_VARNAME,SCATTER_Y_STAT,ts_a)
              Y_b=stat_ts_var(piC_file,SCATTER_Y_VARNAME,SCATTER_Y_STAT,ts_b)
              if VERBOSE then
                print("Y_a="+Y_a+", Y_b="+Y_b)
              end if
              if .not.ALL_EXPTS then
                if SCATTER_Y_PCT_CHANGES then
                 dY(gcm_i,0)=100.*(Y_a-Y_b)/Y_b
                else
                 dY(gcm_i,0)=Y_a-Y_b
                end if
              else
                if SCATTER_Y_PCT_CHANGES then
                  dY(gcm_i,expt_i-1)=100.*(Y_a-Y_b)/Y_b
                else
                  dY(gcm_i,expt_i-1)=Y_a-Y_b
                end if
              end if
              delete([/Y_a,Y_b/])
            end if
            delete([/piC_file,expt_file/])
          end if
        end if
      end do
    end if
  end do

  if VERBOSE then
    print("Loaded all the data")
    print(dX(:,0))
    print(dY(:,0))
  end if

  ;do a final error check
  dY=where(dY.eq.default_fillvalue("float"),dY@_FillValue,dY)
  dX=where(dX.eq.default_fillvalue("float"),dX@_FillValue,dX)

  ;Write out the values to csv files
  if PRINT_OUT_CSV then
    if ALL_EXPTS then
      hlist=[/"MODEL,"+str_join(expts(1:),",")/]
      fname=plot_dir+"/SCATTER_"+SCATTER_X_EXPT+"-expt_"+SCATTER_X_STAT+"_"+SCATTER_X_VARNAME+".csv"
      write_table(fname, "w", hlist, "%s ")
      alist=NewList("lifo")
      ListAppend(alist,gcms)
      format_string="%s"
      printVarSummary(dX)
      do expt_i=0,dimsizes(expts)-2
        values=dX(:,expt_i)
        values@_FillValue=-999.
        str = unique_string("polymarker")
        values@$str$=values
        ListAppend(alist,values@$str$)
        format_string=format_string+",%5.2f"
      end do
      write_table(fname, "a", alist,format_string)
      delete([/alist,values,format_string,fname/])
      hlist=[/"MODEL,"+str_join(expts(1:),",")/]
      fname=plot_dir+"/SCATTER_"+SCATTER_Y_EXPT+"-expt_"+SCATTER_Y_STAT+"_"+SCATTER_Y_VARNAME+".csv"
      write_table(fname, "w", hlist, "%s ")
      alist=NewList("lifo")
      ListAppend(alist,gcms)
      format_string="%s"
      do expt_i=0,dimsizes(expts)-2
        values=dY(:,expt_i)
        values@_FillValue=-999.
        str = unique_string("polymarker")
        values@$str$=values
        ListAppend(alist,values@$str$)
        format_string=format_string+",%5.2f"
      end do
      write_table(fname, "a", alist,format_string)
      delete([/alist,values,format_string,fname/])
    else
      hlist=[/"MODEL",SCATTER_X_EXPT/]
      fname=plot_dir+"/SCATTER_"+SCATTER_X_EXPT+"-expt_"+SCATTER_X_STAT+"_"+SCATTER_X_VARNAME+".csv"
      write_table(fname, "w", hlist, "%s ")
      alist=NewList("lifo")
      ListAppend(alist,gcms)
      format_string="%s,%5.2f"
      values=dX(:,X_expt_i-1)
      values@_FillValue=-999.
      ListAppend(alist,values)
      write_table(fname, "a", alist,format_string)
      delete([/alist,values,format_string,fname,hlist/])
      hlist=[/"MODEL",SCATTER_Y_EXPT/]
      fname=plot_dir+"/SCATTER_"+SCATTER_Y_EXPT+"-expt_"+SCATTER_Y_STAT+"_"+SCATTER_Y_VARNAME+".csv"
      write_table(fname, "w", hlist, "%s ")
      alist=NewList("lifo")
      ListAppend(alist,gcms)
      format_string="%s,%5.2f"
      values=dY(:,0)
      values@_FillValue=-999.
      ListAppend(alist,values)
      write_table(fname, "a", alist,format_string)
      delete([/alist,values,format_string,fname,hlist/])
    end if
  end if

  ;print out the correlation coefficient
  if .not.ALL_EXPTS then
    print("Correlation between "+SCATTER_X_VARNAME+" & "+SCATTER_Y_VARNAME+"_"+SCATTER_Y_STAT+" = "+escorc(dX(:,0),dY(:,0)))
  end if

  ;create the scatter plot
  wks = gsn_open_wks(OUTPUT_TYPE,plot_dir+"/SCATTER_"+SCATTER_X_EXPT+"-expt_"+SCATTER_X_STAT+"_"+SCATTER_X_VARNAME+"_vs_"+SCATTER_Y_EXPT+"-expt_"+SCATTER_Y_STAT+"_"+SCATTER_Y_VARNAME)
  res = True ; plot mods desired
  res@gsnDraw = False
  res@gsnFrame = False ; plot mods desired
  res@tiMainString= " " ; add title
  res@xyMarkLineModes = "Markers"; choose which have markers
  res@xyMonoMarkerColor = True
  res@xyMarkerSizeF = 0.01 ; Marker size (default 0.01)
  res@gsnYRefLine=0.0
  res@gsnXRefLine=0.0
  res@tmLabelAutoStride = True ; nice tick mark labels
  if SCATTER_X_PCT_CHANGES then
    res@tiXAxisString = "Change in "+SCATTER_X_STAT+" "+SCATTER_X_VARNAME+" (%)"
  else
    res@tiXAxisString = "Change in "+SCATTER_X_STAT+" "+SCATTER_X_VARNAME
  end if
  if SCATTER_Y_PCT_CHANGES then
    res@tiYAxisString = "Change in "+SCATTER_Y_STAT+" "+SCATTER_Y_VARNAME+" (%)"
  else
    res@tiYAxisString = "Change in "+SCATTER_Y_STAT+" "+SCATTER_Y_VARNAME
  end if
  if (.not.GMT_for_Y).and.(.not.BARTLEIN_EURASIA).and.(.not.SCATTER_Y_PCT_CHANGES) then
    res@trYMaxF=4.05
    res@trYMinF=2.
  else
    res@trYMaxF=max(dY(:,0))
    res@trYMinF=min(dY(:,0))
  end if
  res@trXMaxF=5.5
  res@trXMinF=2.

  expt_i=0
  res@xyMarker=3 
  res@xyMonoMarker = True
  res@xyMarkerColor = expts_color(expt_i+1)
  if VERBOSE then 
    print(res)
  end if
  if ALL_EXPTS then
    plot= gsn_csm_xy(wks,dX(ind(.not.isCMIP6),expt_i),dY(ind(.not.isCMIP6),expt_i),res) ; create plot
    do expt_i=1,dimsizes(expts)-2
      res@xyMarkerColor =expts_color(expt_i+1) 
      str=unique_string("oplot")
      plot@$str$= gsn_csm_xy (wks,dX(ind(.not.isCMIP6),expt_i),dY(ind(.not.isCMIP6),expt_i),res)
      overlay(plot,plot@$str$)
    end do
    res@xyMarker=16; choose type of marker
    do expt_i=0,dimsizes(expts)-2
      res@xyMarkerColor =expts_color(expt_i+1) 
      str=unique_string("oplot")
      plot@$str$= gsn_csm_xy (wks,dX(ind(isCMIP6),expt_i),dY(ind(isCMIP6),expt_i),res)
      overlay(plot,plot@$str$)
    end do
  else
    res@xyMarker=4 
    res@tiXAxisString = SCATTER_X_EXPT+" "+res@tiXAxisString
    res@tiYAxisString = SCATTER_Y_EXPT+" "+res@tiYAxisString
    plot= gsn_csm_xy(wks,dX(ind(.not.isCMIP6),0),dY(ind(.not.isCMIP6),0),res) ; create plot
    res@xyMarker=16; choose type of marker
    oplot = gsn_csm_xy(wks,dX(ind(isCMIP6),0),dY(ind(isCMIP6),0),res) ; create plot
    overlay(plot,oplot)
  end if
  draw(plot)
  frame(wks)
  delete(wks)
