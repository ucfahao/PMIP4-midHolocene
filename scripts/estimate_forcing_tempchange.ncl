;Test the impacts of regridding on the correlation coefficients from data-model comparison

load "/home/ucfaccb/ncl/common.ncl"

gcms=(/"ACCESS-ESM1-5","AWI-CM-1-1-LR","BCC-CSM1-1","CCSM4","CESM2","CNRM-CM5","COSMOS-ASO","CSIRO-Mk3-6-0","CSIRO-Mk3L-1-2","EC-EARTH-2-2","FGOALS-g3","FGOALS-f3-L","FGOALS-g2","FGOALS-s2","GISS-E2-1-G","GISS-E2-R","HadCM3","HadGEM2-CC","HadGEM2-ES","HadGEM3-GC31","INM-CM4-8","IPSL-CM5A-LR","IPSL-CM6A-LR","KCM1-2-2","MIROC-ES2L","MIROC-ESM","MPI-ESM-P","MRI-CGCM3","MRI-ESM2-0","NESM3","NorESM1-F","UofT-CCSM-4"/)
ECS=(/ 3.9            ,-999.          ,3.1         , 2.9   , 5.2   , 3.3      , -999.      , 4.1           , 3.1            , 4.2          ,2.9        ,3.           , 3.7       , 4.5       , 2.7         , 2.1       , 3.3    , 4.5        , 4.6        , 5.4          ,2.1        ,4.1           , 4.5          , -999.    ,2.66        , 4.7       , 3.5       , 2.6       , 3.1        , 3.7   ,2.29     , 3.2/)
isCMIP6=(/True        ,True           ,False       ,False  ,True   ,False     ,False       ,False          ,False           ,False         ,True       ,True         ,False      ,False      ,True         ,False      ,False   ,False       ,False       ,True          ,True       ,False         ,True          ,False     ,True        ,False      ,False      ,False      ,True       ,True   ,True       ,True/)
ECS@_FillValue=-999.

PMIP4_ECS=ECS(ind(isCMIP6))
PMIP4_forced_response=-0.3/3.74*PMIP4_ECS
print(PMIP4_forced_response)
print(avg(PMIP4_forced_response))

patt_file=addfile("/data/aod/Ilyasetal2017_annual/scalable_patterns.r1i1p1_ONLY.nc","r")
scalable_patterns=patt_file->scalable_patterns(:(50*dimsizes(PMIP4_ECS)-1),0,:,:)
temp_change_all=scalable_patterns
do i=0,dimsizes(PMIP4_ECS)-1
  temp_change_all(50*i:50*i+49,:,:)=PMIP4_forced_response(i)*temp_change_all(50*i:50*i+49,:,:)
end do
forced_temp_change=dim_avg_n_Wrap(temp_change_all,0)

outname="estimated_forcing_tempchange.nc"
system("rm "+outname)
outfile=addfile(outname,"c")
outfile->forced_temp_change=forced_temp_change
delete(outfile)

