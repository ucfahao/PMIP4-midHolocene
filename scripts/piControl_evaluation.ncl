;This script was used to block out some figures to populate a research publication on ENSO
;It makes full use of the programs in cvdp_data.functions.ncl to plot figures solely from the output data of cvdp (without needing recomputation).
; It makes 1 table (showing simulations used) and many figures. 

;load some functions
loadscript("./cvdp_data_PMIP4-midHolocene.functions.ncl")
plots_dir="../plots/"

;some plot switches
VERBOSE=False ;if True, provides a modicum of more information about whats going on in the plots - used for debugging mainly.
OUTPUT_TYPE="pdf"; either "png" or "pdf"
INC_PREIND_wHIST=True; adds the preindustrial to all the plots including the Historical 
expts=(/"piControl","historical","midHolocene","lgm","lig127k","1pctCO2","abrupt4xCO2"/)
expts_color=(/"grey60","black","darkgreen","dodgerblue4","yellowgreen","firebrick","orangered2"/)

wks=gsn_open_wks(OUTPUT_TYPE,plots_dir+"piControl_evaluation")
wks@VERBOSE=VERBOSE
opt=True
  opt@cnLevelSelectionMode = "ManualLevels"   
  opt@cnMinLevelValF       = 0
  opt@cnMaxLevelValF       = 35
  opt@cnLevelSpacingF = 2.
  opt@cnFillPalette="WhiteBlueGreenYellowRed"
  opt@mpProjection="CylindricalEqualArea"
  opt@mpCenterLonF=180.
  opt@gsnStringFontHeightF=0.03
  opt@tiMainString=""
  opt@gsnCenterString=""
  opt@lbLabelBarOn=True
  opt@lbTitleString="Annual Temperature (~S~o~N~C)"
opt_pan=True
  opt_pan@lbTitleOn=False
  opt_pan@lbOrientation = "vertical"
  opt_pan@gsnPanelLabelBar=False
  opt_pan@lbLabelFontHeightF=0.016
  opt_pan@gsnPanelBottom=0.66
  opt_pan@gsnPanelRight=0.5
  opt_pan@gsnFrame=False
  opt@gsnRightString="C20-Reanalysis"
  opt@gsnLeftString="a"
  opt_pan@lbTitleString=opt@lbTitleString
  plotCVDPcomparisonMaps("C20-Reanalysis","tas_spatialmean_ann",wks,opt,opt_pan)

;temperature biases
  opt@cnFillPalette="CBR_coldhot"
  opt@cnLevelSelectionMode = "ExplicitLevels"   
  opt@cnLevels=(/-5.,-3.,-2.,-1.,-0.5,0.5,1.,2.,3.,5./)
  opt@lbTitleString="Temperature Difference (~S~o~N~C)"
  opt@gsnLeftString="b"
  opt@CONSISTENCY=True ;Turn on Stippling
  opt_pan@gsnPanelLeft=0.5
  opt_pan@gsnPanelRight=1.0
  opt@gsnRightString="Ensemble Mean Bias"
  plotDiffEnsMnMaps("piControl","C20-Reanalysis","tas_spatialmean_ann",wks,opt,opt_pan)
  delete([/opt@gsnRightString,opt@CONSISTENCY,opt@lbTitleString,opt@gsnLeftString,opt_pan@gsnRightString,opt_pan@lbTitleString,opt_pan@gsnLeftString/])

;Move onto precip
  opt@cnLevelSelectionMode = "ManualLevels"   
  opt@cnMinLevelValF       = 0
  opt@cnMaxLevelValF       = 10
  opt@cnLevelSpacingF = 1.
  opt@cnFillPalette="CBR_wet"
  opt_pan@gsnPanelTop=0.66
  opt_pan@gsnPanelBottom=0.0
  opt_pan@gsnPanelLeft=0.0
  opt_pan@gsnPanelRight=0.5
  opt_pan@gsnRightString=(/"DJF","JJA"/)+" Precip."
  opt@gsnRightString=opt_pan@gsnRightString
  opt_pan@gsnLeftString=(/"c","e"/)
  opt@gsnLeftString=opt_pan@gsnLeftString
  opt@lbTitleString="Precipitation Rate (mm/day)"
  opt_pan@lbTitleString="Precipitation Rate (mm/day)"
  opt_pan@dims=(/2,1/)
plotCVDPcomparisonMaps("GPCP",(/"pr_spatialmean_djf","pr_spatialmean_jja"/),wks,opt,opt_pan)


;And do the precip differences
  opt@CONSISTENCY=True ;Turn on Stippling
  opt@cnFillPalette="CBR_drywet"
  opt@cnLevelSelectionMode = "ExplicitLevels"   
  opt@cnLevels=(/-5.,-2.,-1.,-0.5,-0.1,0.1,0.5,1.,2.,5./)
  opt@lbTitleString="Precip. Difference (mm/day)"
  opt_pan@gsnPanelLeft=0.5
  opt_pan@gsnPanelRight=1.
  opt_pan@gsnRightString=(/"DJF","JJA"/)+" Bias"
  opt@gsnRightString=opt_pan@gsnRightString
  opt_pan@gsnLeftString=(/"d","f"/)
  opt@gsnLeftString=opt_pan@gsnLeftString
  opt_pan@lbTitleString=opt@lbTitleString
plotDiffEnsMnMaps("piControl","GPCP",(/"pr_spatialmean_djf","pr_spatialmean_jja"/),wks,opt,opt_pan)

frame(wks)
delete(wks)
delete([/opt,opt_pan/])