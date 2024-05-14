output                 = "/home/yyq/mls/dataprocess/photo/mask"
grid_path              = "/home/yyq/mls/dataprocess/nc/BASIN_362X196_new.nc"
f_grid                 = addfile(grid_path, "r")

;print(f_grid)
indd                    = (/f_grid->ind(:,{0:359})/)
lat                     =(/f_grid->lat/)
lon                     =(/f_grid->lon(0:359)/)
indd!0 = "lat"
indd!1 = "lon"
lon_pts = lon
lat_pts = lat
lon_pts@units = "degrees_east" 
lat_pts@units = "degrees_north"
indd&lon = lon_pts 
indd&lat = lat_pts
print(indd(:,{80}))
indd = where(indd.eq.5,2,indd);大西洋2
indd = where(indd.eq.7,4,indd);太平洋4
indd = where(indd.eq.6,3,indd);印度洋3

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
;   res_0@cnLevelSelectionMode      = "ExplicitLevels"
;    res_0@cnLevels                  = level
;    res_0@gsnLeftString             = "delta SST"
;    res_0@gsnLeftStringFontHeightF  = 15
;    res_0@gsnRightString            = "K"
;    res_0@gsnRightStringFontHeightF = 15
;    res_0@cnFillPalette             = "temp_diff_18lev"
    res_0@mpCenterLonF              = 180
plots(0) = gsn_csm_contour_map(wks,indd, res_0)

resP    = True
    resP@gsnPanelLabelBar           = True
;    resP@lbLabelStride              = 4              ;colorbar每1个色块一个标注
    resP@lbLabelAutoStride          = False          ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn      = False          ;colorbar内部边框隐藏
    resP@lbBoxLinesOn               = False          ;colorbar外边框设置为隐藏
    resP@lbBoxEndCapStyle           = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)