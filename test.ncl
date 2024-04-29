;画经向流函数最后一年年平均与ctrl试验的差值
datapath = "/data06/yyq/mls/licom2/addwater_new/exe/"

f_yaer = addfile(datapath+"YME.nc", "r")
psi_year = f_yaer->psi(:,:,:)

datapath_ctrl = "/data06/yyq/mls/licom2/ctrl/exe/"

f_yaer_ctrl = addfile(datapath_ctrl+"YME.nc", "r")
psi_year_ctrl = f_yaer_ctrl->psi(:,:,:)

size = dimsizes(psi_year(:,0,0))
psi_delta = psi_year((size-1),:,:)-psi_year_ctrl((size-1),:,:)
copy_VarMeta(psi_year(0,:,:), psi_delta)

wks = gsn_open_wks("png", "./test")
plots=new(1,"graphic")
    level                        = new((/16/),float)  
    level                        = ispan(-20,10,2)
    level = level/10
res_0 = True
    res_0@gsnDraw                =  False
    res_0@gsnFrame               =  False
    res_0@cnFillOn               = True

    res_0@cnLevelSelectionMode = "ExplicitLevels"
    res_0@cnLevels             = level
;    res_0@gsnLeftString = ""
;    res_0@gsnLeftStringFontHeightF =15
;    res_0@gsnRightString = "delta sst"
    res_0@gsnRightStringFontHeightF =15
;    res_0@cnFillPalette  = "temp_diff_18lev"
    res_0@gsnYAxisIrregular2Linear = True


plots(0) = gsn_csm_contour(wks,psi_delta, res_0)

resP = True
gsn_panel(wks, plots, (/1,1/), resP)