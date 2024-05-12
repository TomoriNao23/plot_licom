;画经向流函数psi最后一年年平均与ctrl试验的差值
output                 = "/home/yyq/mls/dataprocess/photo/delta_psi"
datapath               = "/data06/yyq/mls/licom2/addwater_new/exe/"
datapath_ctrl          = "/data06/yyq/mls/licom2/ctrl/exe/"
f_year                 = addfile(datapath+"YME.nc", "r")
f_year_ctrl            = addfile(datapath_ctrl+"YME.nc", "r")

psi_year_a             = f_year->psi(:,:,:)
psi_year_ctrl_a        = f_year_ctrl->psi(:,:,:)

lon_size               = dimsizes(psi_year_a(0,0,:)) - 3
psi_year               = psi_year_a(:,:,0:lon_size)
psi_year_ctrl          = psi_year_ctrl_a(:,:,0:lon_size)

size                   = dimsizes(psi_year(:,0,0))
psi_delta              = psi_year((size-1),:,:) - psi_year_ctrl((size-1),:,:)
copy_VarMeta(psi_year(0,:,:), psi_delta)

level                  = new((/31/),float)  
level                  = ispan(-20,10,1)
level                  = level / 10

wks      = gsn_open_wks("png", output)
plots    = new(1,"graphic")
res_0    = True
    res_0@gsnDraw                   =  False
    res_0@gsnFrame                  =  False
    res_0@cnFillOn                  = True
    res_0@cnLevelSelectionMode      = "ExplicitLevels"
    res_0@cnLevels                  = level
    res_0@gsnLeftString             = "delta Meridioanl Stream Function"
    res_0@gsnLeftStringFontHeightF  = 15
    res_0@gsnRightString            = "Sverdrup"
    res_0@gsnRightStringFontHeightF = 15
;   res_0@cnFillPalette             = "temp_diff_18lev"
    res_0@gsnXAxisIrregular2Linear  = True
    res_0@gsnYAxisIrregular2Linear  = True
    res_0@cnInfoLabelOn             =  False              ;关闭右下角标注
    res_0@cnLinesOn                 =  False              ;不显示等值线
    res_0@cnLineLabelsOn            =  False              ;不显示等值线数值
    res_0@lbLabelBarOn              =  False              ;关闭colorbar

plots(0) = gsn_csm_contour(wks,psi_delta, res_0)

resP = True
    resP@gsnPanelLabelBar = True
    resP@lbLabelStride             = 5              ;colorbar每1个色块一个标注
    resP@lbLabelAutoStride         = False          ;colorbar每条等值线均标注
    resP@lbBoxSeparatorLinesOn     = False          ;colorbar内部边框隐藏
    resP@lbBoxLinesOn              = False          ;colorbar外边框设置为隐藏
    resP@lbBoxEndCapStyle          = "TriangleBothEnds"
gsn_panel(wks, plots, (/1,1/), resP)