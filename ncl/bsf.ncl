;画最后一年年平均的正压流函数bsf
output                 = "/home/yyq/mls/dataprocess/photo/bsf"
datapath               = "/data06/yyq/mls/licom2/ctrl/exe/"
f_year                 = addfile(datapath+"YME.nc", "r")

bsf_year_a             = f_year->bsf(:,:,:)

lon_size               = dimsizes(bsf_year_a(0,0,:)) - 3
bsf_year               = bsf_year_a(:,:,0:lon_size)

size_time              = dimsizes(bsf_year(:,0,0))
bsf_year_last          = bsf_year((size_time-1),:,:)

level                  = new((/14/),float)  
level                  = ispan(-80,180,20)
level                  = level / 1

wks      = gsn_open_wks("png", output)
plots    = new(1,"graphic")
res_0    = True
    res_0@gsnDraw                   = False
    res_0@gsnFrame                  = False
    res_0@cnFillOn                  = True
    res_0@mpCenterLonF              = 180
    res_0@cnLineLabelsOn            = True
    res_0@cnLevelSelectionMode      = "ExplicitLevels"
    res_0@cnLevels                  = level
    res_0@lbLabelBarOn              = False              ;关闭colorbar
    res_0@gsnLeftString             = "Barotropic Stream Function"
    res_0@gsnLeftStringFontHeightF  = 15
    res_0@gsnRightString            = "Sverdrup"
    res_0@gsnRightStringFontHeightF = 15
;   res_0@cnFillPalette             = "temp_diff_18lev"
plots(0) = gsn_csm_contour_map(wks,bsf_year(29,:,:), res_0)

resP     = True
    resP@gsnPanelLabelBar           = True
    resP@lbLabelStride              = 3              ;colorbar每1个色块一个标注
    resP@lbLabelAutoStride          = False          ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn      = False          ;colorbar内部边框隐藏
    resP@lbBoxLinesOn               = False          ;colorbar外边框设置为隐藏
    resP@lbBoxEndCapStyle           = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)