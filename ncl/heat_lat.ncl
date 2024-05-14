;画经向热输送的纬向平均
output                 = "/home/yyq/mls/dataprocess/photo/heat_lat"
datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
gridpath               = "/home/yyq/mls/dataprocess/nc/basin_new.nc"

fileslist              = systemfunc("ls "+ datapath+"MMEAN" +"*") 
f                      = addfiles(fileslist, "r") 
f_grid                 = addfile(gridpath, "r")

lev                    = f[0]->lev1
lat                    = f[0]->lat
vs_a                   = f[348:359]->vs
ts_a                   = f[348:359]->ts
indd                   = f_grid->indd              ;各个大洋的掩膜

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
dz                     = new((/lev_size/),typeof(lev))
do z = 1,lev_size
    dz(z-1)            = ((lev(z) - lev(z-1))) * (-1)
end do 

dz_conform             = new((/time_size + 1,lev_size,lat_size + 1,lon_size + 1/),float)          ;[12]time x [30]lev x [115]lat x [180]lon
dz_conform             = conform(dz_conform, dz, (/1/))

dx_conform             = new((/time_size + 1,lev_size,lat_size + 1,lon_size + 1/),float)          ;[12]time x [30]lev x [115]lat x [180]lon
dx_conform             = conform(dx_conform, dx, (/2/))

heat                   = vs * ts * dz_conform * dx_conform * Cp * rho0                            ;[12]time x [30]lev x [115]lat x [180]lon
heat_integrate_lev     = dim_sum_n(heat, 1)                                                       ;[12]time x [115]lat x [180]lon
heat_avg               = dim_avg_n(heat_integrate_lev,0)                                          ;[115]lat x [180]lon
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

y                      = new((/4,lat_size + 1/),float)
y(3,:)                 = heat_avg_lat
y(2,:)                 = heat_avg_lat_pacfic
y(1,:)                 = heat_avg_lat_atlantic
y(0,:)                 = heat_avg_lat_indian

;draw
wks                               = gsn_open_wks("png", output)
plots                             = new(1,"graphic")
res_0                             = True
    res_0@gsnDraw                 = False
    res_0@gsnFrame                = False           
    res_0@vpHeightF               = 0.3                                     ;图片高度
    res_0@vpWidthF                = 0.6                                     ;图片宽度
    res_0@tiXAxisString           = "Latitude" 
    res_0@tiYAxisString           = "Heat Transport(PW)" 
    res_0@gsnYRefLine             = 0                                       ;添加参考线
    res_0@gsnYRefLineThicknessF   = 1.5                                     ;参考线宽度
    res_0@xyLineColors            = (/"purple","red","green","black"/)      ;折线颜色
    res_0@xyDashPatterns          = (/0,0,0,0/)                             ;折线线型
    res_0@xyLineThicknessF        = 3
    res_0@trYMinF                 = -2.5            
    res_0@trYMaxF                 = 2.5
    res_0@trXMinF                 = -35
    res_0@trXMaxF                 = 65

    res_0@pmLegendDisplayMode     = "Always"         ; Turn on a legend
    res_0@pmLegendOrthogonalPosF  = -0.61            ; Move legend inside plot
    res_0@pmLegendParallelPosF    = 0.89             ; Move legend to right
    res_0@pmLegendWidthF          = 0.13             ; Change width and height
    res_0@pmLegendHeightF         = 0.1
  
  res_0@xyExplicitLabels          = (/"Indian","Atlantic","Pacific","Total"/)  ; explicit labels

plots(0)                          = gsn_csm_xy(wks, lat,y/(1e15), res_0)

resP                              = True
gsn_panel(wks, plots, (/1,1/), resP)











