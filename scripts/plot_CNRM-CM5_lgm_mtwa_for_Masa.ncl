load "cvdp_data_PMIP4-midHolocene.functions.ncl"
plots_dir="../plots/"
OUTPUT_TYPE="png"; either "png" or "pdf"
data_dir="/home/p2f-v/public_html/PMIPVarData/cvdp_data"
gcms=(/"AWI-CM-1-1-LR","BCC-CSM1-1","CCSM4","CESM2","CNRM-CM5","CSIRO-Mk3-6-0","CSIRO-Mk3L-1-2","EC-EARTH-2-2","FGOALS-g3","FGOALS-f3-L","FGOALS-g2","FGOALS-s2","GISS-E2-1-G","GISS-E2-R","HadGEM2-CC","HadGEM2-ES","HadGEM3-GC31","INM-CM4-8","IPSL-CM5A-LR","IPSL-CM6A-LR","MIROC-ES2L","MIROC-ESM","MPI-ESM-P","MRI-CGCM3","MRI-ESM2-0","NESM3","NorESM1-F","UofT-CCSM-4"/)
ECS=(/-999.           ,3.1         , 2.9   , 5.2   , 3.3      ,4.1            , 3.1            , 4.2          ,2.9        ,3.           , 3.7       , 4.5       , 2.7         , 2.1       , 4.5        , 4.6        , 5.4          ,2.1        ,4.1           , 4.5          ,2.66        , 4.7       , 3.5       , 2.6       , 3.1        , 3.7   ,2.29     , 3.2/)

opt=True
opt@cnFillPalette="CBR_coldhot"
opt@cnLevelSelectionMode = "ExplicitLevels"
opt@cnLevels=(/-5.,-3.,-2.,-1.,-0.5,0.5,1.,2.,3.,5./)

gcm_i=ind(gcms.eq."CNRM-CM5")
var_strs=(/"tas_warmestmonth","tas_spatialmean_jja","tas_spatialmean_djf","tas_spatialmean_ann"/)
do var_i=0,dimsizes(var_strs)-1
    opt@gsnLeftString=gcms(gcm_i)
    opt@gsnRightString=ECS(gcm_i)
    opt@lbTitleString=var_strs(var_i)+" change (~S~o~N~C)"
    output_string=plots_dir+gcms(gcm_i)+"_LGM_change_in_"+var_strs(var_i)
    output_string@filetype="png"
    plot_output_DiffEnsMn(gcms(gcm_i)+"_lgm-cal-adj",gcms(gcm_i)+"_piControl",var_strs(var_i),output_string,opt)
end do
