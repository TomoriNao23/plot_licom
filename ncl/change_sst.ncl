;画sst(包含年均和月数据)时间序列
output                 = "/home/yyq/mls/dataprocess/photo/change_sst"
datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
fileslist              = systemfunc("ls "+ datapath+"MMEAN" +"*") 
f_year                 = addfile(datapath+"YME.nc", "r")
f                      = addfiles(fileslist, "r")  

sst_ori                = f[:]->ts(:,0,:,:)
sst_year_ori           = f_year->ts(:,0,:,:)

lon_size               = dimsizes(sst_year_ori(0,0,:))
lon_size               = lon_size - 3             ;扣除边界经度重复格点
sst                    = sst_ori(:,:,0:lon_size)
sst_year               = sst_year_ori(:,:,0:lon_size)

lat                    = f_year ->lat(:)
angle2radian           = 4.0 * atan(1.0) / 180.0
dlat                   = cos (lat*angle2radian)
sst_area               = wgt_areaave_Wrap(sst, dlat, 1.0, 1)
sst_year_area          = wgt_areaave_Wrap(sst_year, dlat, 1.0, 1)

month                  = dimsizes(sst_area)
x                      = new((/month/),float)  
x                      = ispan(1,month,1)
x                      = x / 12
year                   = dimsizes(sst_year_area)
xx                     = new((/year/),float) 
xx                     = ispan(1,year,1)

wks      = gsn_open_wks("png", output)
plots    = new(1,"graphic")
res_0    = True
    res_0@gsnDraw                =  False
    res_0@gsnFrame               =  False
    res_0@tiXAxisString          =  "year" 
plots(0) = gsn_csm_xy(wks, x, sst_area, res_0)
plot_year= gsn_csm_xy(wks, xx, sst_year_area, res_0)
overlay(plots(0), plot_year)

resP     = True
gsn_panel(wks, plots, (/1,1/), resP)