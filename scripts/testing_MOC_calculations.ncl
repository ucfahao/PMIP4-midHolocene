;Test the impacts of regridding on the correlation coefficients from data-model comparison

load "/home/ucfaccb/ncl/common.ncl"

AFTER_R3=False ;Setting this option will test the implications of Reviewer 3's definition of the AMOC

files=(/;"/data/CMIP/curated_ESGF_replica/EC-Earth3-LR/midHolocene/msftyz_Omon_EC-Earth3-LR_midHolocene_r1i1p1f1_gn_224501-244712.nc",\
    ;"/data/CMIP/curated_ESGF_replica/EC-Earth3-LR/piControl/msftyz_Omon_EC-Earth3-LR_piControl_r1i1p1f1_gn_221901-241912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/HadGEM3-GC31/midHolocene/msftyz_Omon_HadGEM3-GC31-LL_midHolocene_r1i1p1f1_gn_225001-234912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/HadGEM3-GC31/piControl/msftyz_Omon_HadGEM3-GC31-LL_piControl_r1i1p1f1_gn_185001-234912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/MPI-ESM1-2-LR/midHolocene/msftmz_Omon_MPI-ESM1-2-LR_midHolocene_r1i1p1f1_gn_100101-150012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/MPI-ESM1-2-LR/piControl/msftmz_Omon_MPI-ESM1-2-LR_piControl_r1i1p1f1_gn_185001-284912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/MRI-ESM2-0/midHolocene/msftmz_Omon_MRI-ESM2-0_midHolocene_r1i1p1f1_gr2z_195101-215012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/MRI-ESM2-0/piControl/msftmz_Omon_MRI-ESM2-0_piControl_r1i1p1f1_gr2z_185001-255012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/CCSM4/midHolocene/msftmyz_Omon_CCSM4_midHolocene_r1i1p1_100001-130012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/CCSM4/piControl/msftmyz_Omon_CCSM4_piControl_r1i1p1_025001-130012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/CESM2/midHolocene/msftmz_Omon_CESM2_midHolocene_r1i1p1f1_gn_000101-070012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/CESM2/piControl/msftmz_Omon_CESM2_piControl_r1i1p1f1_gn_000101-120012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/FGOALS-f3-L/historical/msftmz_Omon_FGOALS-f3-L_historical_r1i1p1f1_gn_185001-201412.nc",\
    ;"/data/CMIP/curated_ESGF_replica/FGOALS-f3-L/midHolocene/msftmz_Omon_FGOALS-f3-L_midHolocene_r1i1p1f1_gn_072001-121912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/FGOALS-g2/midHolocene/msftmyz_Omon_FGOALS-g2_midHolocene_r1i1p1_034001-101912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/FGOALS-g2/piControl/msftmyz_Omon_FGOALS-g2_piControl_r1i1p1_020101-090012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/GISS-E2-1-G/midHolocene/msftmz_Omon_GISS-E2-1-G_midHolocene_r1i1p1f1_gn_290001-299912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/GISS-E2-1-G/piControl/msftmyz_Omon_GISS-E2-1-G_piControl_r1i1p1f1_gn_415001-500012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/INM-CM4-8/midHolocene/msftmz_Omon_INM-CM4-8_midHolocene_r1i1p1f1_gr1_188001-207912.nc",\
    ;"/data/CMIP/curated_ESGF_replica/INM-CM4-8/piControl/msftmz_Omon_INM-CM4-8_piControl_r1i1p1f1_gr1_185001-238012.nc",\
    ;"/data/CMIP/curated_ESGF_replica/IPSL-CM6A-LR/midHolocene/msftyz_Omon_IPSL-CM6A-LR_midHolocene_r1i1p1f1_gn_185001-239912.nc",\
    "/data/CMIP/curated_ESGF_replica/IPSL-CM6A-LR/piControl/msftyz_Omon_IPSL-CM6A-LR_piControl_r1i1p1f1_gn_185001-234912.nc",\
    "/data/CMIP/curated_ESGF_replica/MPI-ESM-P/midHolocene/msftmyz_Omon_MPI-ESM-P_midHolocene_r1i1p1_185001-194912.nc",\
    "/data/CMIP/curated_ESGF_replica/MPI-ESM-P/piControl/msftmyz_Omon_MPI-ESM-P_piControl_r1i1p1_185001-300512.nc",\
    "/data/CMIP/curated_ESGF_replica/MRI-CGCM3/midHolocene/msftmyz_Omon_MRI-CGCM3_midHolocene_r1i1p1_195101-205012.nc",\
    "/data/CMIP/curated_ESGF_replica/MRI-CGCM3/piControl/msftmyz_Omon_MRI-CGCM3_piControl_r1i1p1_185101-235012.nc",\
    "/data/CMIP/curated_ESGF_replica/NorESM2-LM/midHolocene/msftmz_Omon_NorESM2-LM_midHolocene_r1i1p1f1_grz_210101-220012.nc",\
    "/data/CMIP/curated_ESGF_replica/NorESM2-LM/piControl/msftmz_Omon_NorESM2-LM_piControl_r1i1p1f1_grz_160001-210012.nc"/)


do  fi=0,dimsizes(files)-1
    print((/files(fi)/))
    ;load in the data
    data_file=addfile(files(fi),"r")
    if all(ismissing((/str_match(files(fi),"EC-Earth3-LR"),str_match(files(fi),"IPSL-CM6A-LR"),str_match(files(fi),"MPI-ESM1-2-LR")/))) then
      atl_ind=0
    else
      atl_ind=1
    end if
    if (isfilevar(data_file, "msftyz")) then
        if isfilevar(data_file,"nav_lat") then ;detect IPSL
          all_data=data_file->msftyz(:,:,:,:330,0)
          nav_lat=data_file->nav_lat(:330,0)
          all_data&y=nav_lat
        else
          all_data=data_file->msftyz(:,:,:,:)
        end if
        all_data(:,:,:,{60.:})=all_data@_FillValue;remove data north of 60oN
        time_avgd=dim_avg_n_Wrap(all_data(:,atl_ind,:,:),0)
    else
      if (isfilevar(data_file, "msftmz")) then 
          if .not.ismissing(str_match(files(fi),"historical")) then
            ;take first 50 years
            all_data=data_file->msftmz(0:599,:,:,:)
            all_data = where(abs(all_data).gt.1e20, all_data@_FillValue, all_data)
          else
            all_data=data_file->msftmz(:,:,:,:)
          end if
      else
          all_data=data_file->msftmyz
      end if
      time_avgd=dim_avg_n_Wrap(all_data(:,atl_ind,:,:),0)
    end if
    if AFTER_R3 then
      AMOC_30N_avg=dim_max_n_Wrap(time_avgd(:,{25.5:34.5}),1)
      print(" Max AMOC 26-30N index = "+max(AMOC_30N_avg({500:}))/10^9+" Sv")
    end if
    AMOC_30N_avg=dim_avg_Wrap(time_avgd(:,{29.:31.}))
    print(" Max AMOC 30N index = "+max(AMOC_30N_avg({500:}))/10^9+" Sv")
    AMOC_50N_avg=dim_avg_Wrap(time_avgd(:,{49.:51.}))
    print(" Max AMOC 50N index = "+max(AMOC_50N_avg({500:}))/10^9+" Sv")
    print(" ")
    ;do i = 0, dimsizes(AMOC_30N_avg)-1
    ;    print(" "+i+", "+AMOC_30N_avg&lev(i)+", "+AMOC_30N_avg(i)/10^9+" Sv"); write loop content
    ;end do
    delete([/data_file,all_data,AMOC_30N_avg,AMOC_50N_avg,time_avgd/])
end do
