datapath = "/data06/yyq/mls/licom2_/addwater/exe/"

f = addfile(datapath+"YME.nc", "r")
sst_a = f->ts(:,0,:,:)
lon_size = dimsizes(sst_a(0,0,:)) - 3
sst = sst_a(:,:,0:lon_size)


size_1 = dimsizes(sst(:,0,0)) - 1
sst_delta_0 = sst(4,:,:) - sst(0,:,:)
sst_delta_1 = sst(9,:,:) - sst(0,:,:)
sst_delta_2 = sst(19,:,:) - sst(0,:,:)
sst_delta_3 = sst(size_1,:,:) - sst(0,:,:)
copy_VarMeta(sst(0,:,:), sst_delta_0)
copy_VarMeta(sst(0,:,:), sst_delta_1)
copy_VarMeta(sst(0,:,:), sst_delta_2)
copy_VarMeta(sst(0,:,:), sst_delta_3)

wks = gsn_open_wks("png", "./a")
plots=new(4,"graphic")
    level                        = new((/17/),float)  
    level                        = ispan(-16,16,2)
    level = level/10
res_0 = True
    res_0@gsnDraw                =  False
    res_0@gsnFrame               =  False
    res_0@cnFillOn               = True

    res_0@cnLevelSelectionMode = "ExplicitLevels"
    res_0@cnLevels             = level
    res_0@gsnLeftString = ""
    res_0@gsnLeftStringFontHeightF =15
    res_0@gsnRightString = "delta sst"
    res_0@gsnRightStringFontHeightF =15
    res_0@cnFillPalette  = "temp_diff_18lev"


plots(0) = gsn_csm_contour_map(wks,sst_delta_0, res_0)
plots(1) = gsn_csm_contour_map(wks,sst_delta_1, res_0)
plots(2) = gsn_csm_contour_map(wks,sst_delta_2, res_0)
plots(3) = gsn_csm_contour_map(wks,sst_delta_3, res_0)

resP = True
gsn_panel(wks, plots, (/2,2/), resP)