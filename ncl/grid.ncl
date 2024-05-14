;将各个大洋插值到指定网格
output                 = "/home/yyq/mls/dataprocess/photo/grid"
outfile                = "/home/yyq/mls/dataprocess/nc/basin_new.nc"
grid_path              = "/home/yyq/mls/dataprocess/nc/BASIN_362X196_new.nc"
f_grid                 = addfile(grid_path, "r")

datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
f_year                 = addfile(datapath+"YME.nc", "r")

lat_new                = f_year->lat                                        ;目标网格lat
lon_new                = f_year->lon({0:359})                               ;目标网格lon

indd                   = (/f_grid->ind(:,{0:359})/)
lat                    = (/f_grid->lat/)                                    ;原始网格lat
lon                    = (/f_grid->lon({0:359})/)                           ;原始网格lat

indd                   = where(indd.eq.5,2,indd)                            ;大西洋2
indd                   = where(indd.eq.7,4,indd)                            ;太平洋4
indd                   = where(indd.eq.6,3,indd)                            ;印度洋3
indd_new               = linint2 (lon,lat,indd, True, lon_new,lat_new, 0)   ;插值

;提供元信息
indd_new!0             = "lat"                                                            
indd_new!1             = "lon"
lon_pts                = lon_new
lat_pts                = lat_new
lon_pts@units          = "degrees_east" 
lat_pts@units          = "degrees_north"
indd_new&lon           = lon_pts 
indd_new&lat           = lat_pts

;输出nc文件
if (isfilepresent(outfile)) then
    system ("rm " + outfile)
end if
f_output = addfile(outfile, "c")
f_output->lat = lat_new
f_output->lon = lon_new
f_output->indd = indd_new

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
    res_0@mpCenterLonF              = 180
plots(0) = gsn_csm_contour_map(wks,indd_new, res_0)

resP    = True
    resP@gsnPanelLabelBar           = True
;   resP@lbLabelStride              = 4                 ;colorbar每4个色块一个标注
    resP@lbLabelAutoStride          = False             ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn      = False             ;colorbar内部边框隐藏
    resP@lbBoxLinesOn               = False             ;colorbar外边框设置为隐藏
    resP@lbBoxEndCapStyle           = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)