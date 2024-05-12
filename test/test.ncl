datapath = "/data06/yyq/mls/licom2/addwater_new/exe/"
f_yaer = addfile(datapath+"YME.nc", "r")

sst_year_ori = f_yaer->ts(:,0,:,:)

lon_size = dimsizes(sst_year_ori(0,0,:))
lon_size = lon_size - 3             ;扣除边界经度重复格点
sst_year = sst_year_ori(:,:,0:lon_size)

lat   = f_yaer ->lat(:)
angle2radian = 4.0 * atan(1.0) / 180.0
dlat = cos (lat*angle2radian)
sst_year_area = wgt_areaave_Wrap(sst_year, dlat, 1.0, 1)
print(sst_year_area)


