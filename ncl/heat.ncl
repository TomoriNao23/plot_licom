;画经向热输送全球分布
output                 = "/home/yyq/mls/dataprocess/photo/heat"
datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
gridpath               = "/home/yyq/mls/dataprocess/nc/basin_new.nc"

fileslist              = systemfunc("ls "+ datapath+"MMEAN" +"*") 
f                      = addfiles(fileslist, "r") 
f_grid                 = addfile(gridpath, "r")

lev                    = f[0]->lev1
lat                    = f[0]->lat
vs_a                   = f[348:359]->vs
ts_a                   = f[348:359]->ts
indd                    = f_grid->indd              ;各个大洋的掩膜

lat_size               = dimsizes(vs_a(0,0,:,0)) - 1
lon_size               = dimsizes(vs_a(0,0,0,:)) - 1 - 2
time_size              = dimsizes(vs_a(:,0,0,0)) - 1
lev_size               = dimsizes(lev) - 1
vs                     = vs_a(:,:,:,0:lon_size)
ts                     = ts_a(:,:,:,0:lon_size)

angle2radian           = 4.0 * atan(1.0) / 180.0    ; 角度转换弧度
r_earth                = 6.371e6                    ; 地球半径
dlon                   = 2                          ; 格点的纬向分辨率
Cp                     = 4.18e3                     ; 热容
rho0                   = 1027                       ; 海水密度

r                      = r_earth * cos (lat * angle2radian)
dx                     = r * (dlon * angle2radian)
dz = new((/lev_size/),typeof(lev))
do z = 1,lev_size
    dz(z-1) = ((lev(z) - lev(z-1))) * (-1)
end do 

dz_conform = new((/time_size+1,lev_size,lat_size+1,lon_size+1/),float)          ;[12]  x [30]  x [115]  x [180]
dz_conform=conform(dz_conform, dz, (/1/))
dx_conform = new((/time_size+1,lev_size,lat_size+1,lon_size+1/),float)          ;[12]  x [30]  x [115]  x [180]
dx_conform=conform(dx_conform, dx, (/2/))

heat = vs * ts * dz_conform * dx_conform * Cp * rho0                            ;[12]  x [30]  x [115]  x [180]
heat_integrate_lev =dim_sum_n(heat, 1)/(1e15)                                   ;[12]  x [115] x [180]
copy_VarMeta(vs(:,0,:,:), heat_integrate_lev)

;all basin
heat_avg               = dim_avg_n_Wrap(heat_integrate_lev,0)                                     ;[115]lat x [180]lon
heat_avg_lat           = dim_sum_n_Wrap(heat_avg,1)                                               ;[115]lat
heat_avg_lat           = runave(heat_avg_lat, 9, 0)
;Pacfic
heat_avg_pacfic        = heat_avg
heat_avg_pacfic        = where(indd.eq.4, heat_avg, heat_avg@_FillValue)
heat_avg_lat_pacfic    = dim_sum_n_Wrap(heat_avg_pacfic,1)
heat_avg_lat_pacfic    = runave(heat_avg_lat_pacfic, 9, 0)
;Atlantic
heat_avg_atlantic      = heat_avg
heat_avg_atlantic      = where(indd.eq.2, heat_avg, heat_avg@_FillValue)
heat_avg_lat_atlantic  = dim_sum_n_Wrap(heat_avg_atlantic,1)
heat_avg_lat_atlantic  = runave(heat_avg_lat_atlantic, 9, 0)
;Indian
heat_avg_indian        = heat_avg
heat_avg_indian        = where(indd.eq.3, heat_avg, heat_avg@_FillValue)
heat_avg_lat_indian    = dim_sum_n_Wrap(heat_avg_indian,1)
heat_avg_lat_indian    = runave(heat_avg_lat_indian, 9, 0)

level                  = new((/51/),float)  
level                  = ispan(-25,25,1)
level                  = level / 10

;画图检验
wks      = gsn_open_wks("png", output)
plots    = new(1,"graphic")
res_0    = True
    res_0@gsnDraw                   =  False
    res_0@gsnFrame                  =  False
    res_0@cnFillOn                  =  True
    res_0@cnInfoLabelOn             =  False              ;关闭右下角标注
    res_0@cnLinesOn                 =  False              ;不显示等值线
    res_0@cnLineLabelsOn            =  False              ;不显示等值线数值
    res_0@lbLabelBarOn              =  False              ;关闭colorbar
    res_0@cnLevelSelectionMode      = "ExplicitLevels"
    res_0@cnLevels                  = level
    res_0@gsnLeftString             = "Meridional Heat Transport"
    res_0@gsnLeftStringFontHeightF  = 15
    res_0@gsnRightString            = "PW"
    res_0@gsnRightStringFontHeightF = 15
;   res_0@cnFillPalette             = "temp_diff_18lev"
    res_0@mpCenterLonF              = 180
plots(0) = gsn_csm_contour_map(wks,heat_avg, res_0)

resP    = True
    resP@gsnPanelLabelBar           = True
    resP@lbLabelStride              = 5                 ;colorbar每5个色块一个标注
    resP@lbLabelAutoStride          = False             ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn      = False             ;colorbar内部边框隐藏
    resP@lbBoxLinesOn               = False             ;colorbar外边框设置为隐藏
    resP@pmLabelBarHeightF          = 0.05               ;colorbar高度
    resP@pmLabelBarWidthF           = 0.9               ;colorbar宽度
    resP@pmLabelBarParallelPosF     = 0.025             ;colorbar水平偏移
    resP@lbBoxEndCapStyle           = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)























