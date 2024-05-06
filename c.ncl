;画最后一年年平均的正压流函数bsf
datapath = "/data06/yyq/mls/licom2/ctrl/exe/"

f_yaer = addfile(datapath+"YME.nc", "r")
bsf_year = f_yaer->bsf(:,:,:)

size_time = dimsizes(bsf_year(:,0,0))
bsf_year_last = bsf_year((size_time-1),:,:)

wks = gsn_open_wks("png", "./c")
plots=new(1,"graphic")
    level                        = new((/14/),float)  
    level                        = ispan(-80,180,20)
    level = level
res_0 = True
    res_0@gsnDraw                =  False
    res_0@gsnFrame               =  False
    res_0@cnFillOn               = True

    res_0@mpCenterLonF = 180
    res_0@cnLineLabelsOn = True

    res_0@cnLevelSelectionMode = "ExplicitLevels"
    res_0@cnLevels             = level
;    res_0@gsnLeftString = ""
;    res_0@gsnLeftStringFontHeightF =15
;    res_0@gsnRightString = "delta sst"
    res_0@gsnRightStringFontHeightF =15
;    res_0@cnFillPalette  = "temp_diff_18lev"


plots(0) = gsn_csm_contour_map(wks,bsf_year(29,:,:), res_0)

resP = True
gsn_panel(wks, plots, (/1,1/), resP)