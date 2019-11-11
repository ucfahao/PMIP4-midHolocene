;To compute the 1850-1900 zonal banded temperatures to be compared with the piControl values
; Will only run on Chris' computer as the input data locations are hard-wired.

load "$NCL_DIR/common.ncl"

;load in the data
anoms_file=addfile("/data/aod/Ilyasetal2017_annual/avg.18501900.wrt_19611990.nc","r")
anoms=anoms_file->temperature_anomaly
climo_file=addfile("/data/aod/Ilyasetal2017_annual/absolute.CRU.ANN_AVG.nc","r")
lat=climo_file->lat
tem=climo_file->tem(0,:,:)

;compute absolute temperatures from 1850-1900
absolute=anoms
absolute=(/anoms+conform(anoms,tofloat(tem(::-1,:)),(/1,2/))/)
znmn_absolute=dim_avg_Wrap(absolute)

;compute area arevages
lat=lat(::-1)
clat=tofloat(cos(0.01745329*lat)) ;area weighting
antarctic=wgt_areaave_Wrap(absolute(:,0:5,:),clat(0:5), 1.0, 1)
s_midlats=wgt_areaave_Wrap(absolute(:,6:11,:),clat(6:11), 1.0, 1)
s_tropics=wgt_areaave_Wrap(absolute(:,12:17,:),clat(12:17), 1.0, 1)
n_tropics=wgt_areaave_Wrap(absolute(:,18:23,:),clat(18:23), 1.0, 1)
n_midlats=wgt_areaave_Wrap(absolute(:,24:29,:),clat(24:29), 1.0, 1)
arctic=wgt_areaave_Wrap(absolute(:,30:35,:),clat(30:35), 1.0, 1)

print("The absolute temperatures for 1850-1900 from the Ilyas et al (2017) version of the HadCRUT4 dataset are...")
print("60-90oN = "+avg(arctic)+" +/- "+stddev(arctic)+" (1 SD)")
print("30-60oN = "+avg(n_midlats)+" +/- "+stddev(n_midlats)+" (1 SD)")
print("0-30oN = "+avg(n_tropics)+" +/- "+stddev(n_tropics)+" (1 SD)")
print("30oS-0 = "+avg(s_tropics)+" +/- "+stddev(s_tropics)+" (1 SD)")
print("60-30oS = "+avg(s_midlats)+" +/- "+stddev(s_midlats)+" (1 SD)")
print("90-60oS = "+avg(antarctic)+" +/- "+stddev(antarctic)+" (1 SD)")

print(" ")
print("Zonal mean absolute temperatures for 1850-1900 from the Ilyas et al (2017) version of the HadCRUT4 dataset are...")
print("lat, mean, std.dev")
do i = 0, 35
   print(" "+lat(i)+", "+avg(znmn_absolute(:,i))+", "+stddev(znmn_absolute(:,i)))    
end do