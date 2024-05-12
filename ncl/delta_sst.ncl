;画最后一年平均sst场与ctrl试验的差值
output                 = "/home/yyq/mls/dataprocess/photo/delta_sst"
datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
datapath_ctrl          = "/data06/yyq/mls/licom2/ctrl/exe/"
f                      = addfile(datapath+"YME.nc", "r")
f_year_ctrl            = addfile(datapath_ctrl+"YME.nc", "r")

sst_a                  = f->ts(:,0,:,:)
sst_ctrl_a             = f_year_ctrl->ts(:,0,:,:)

lon_size               = dimsizes(sst_a(0,0,:)) - 3
sst                    = sst_a(:,:,0:lon_size)
sst_ctrl               = sst_ctrl_a(:,:,0:lon_size)

size_1                 = dimsizes(sst(:,0,0)) - 1
sst_delta_0            = sst(size_1,:,:) - sst_ctrl(0,:,:)
copy_VarMeta(sst(0,:,:), sst_delta_0)

level                  = new((/17/),float)  
level                  = ispan(-16,16,2)
level                  = level / 10

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
    res_0@gsnLeftString             = "delta SST"
    res_0@gsnLeftStringFontHeightF  = 15
    res_0@gsnRightString            = "K"
    res_0@gsnRightStringFontHeightF = 15
    res_0@cnFillPalette             = "temp_diff_18lev"
    res_0@mpCenterLonF              = 180
plots(0) = gsn_csm_contour_map(wks,sst_delta_0, res_0)

resP    = True
    resP@gsnPanelLabelBar           = True
    resP@lbLabelStride              = 4              ;colorbar每1个色块一个标注
    resP@lbLabelAutoStride          = False          ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn      = False          ;colorbar内部边框隐藏
    resP@lbBoxLinesOn               = False          ;colorbar外边框设置为隐藏
    resP@lbBoxEndCapStyle           = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)