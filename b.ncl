datapath = "/data06/yyq/mls/licom2_/addwater/exe/"
fileslist = systemfunc("ls "+ datapath+"MMEAN" +"*")    
f = addfiles(fileslist, "r")   
;f = addfile(datapath+"YME.nc", "r")
psi = f[:]->psi(:,{-2000:-500},{25:75})
psi_maxtem = dim_max_n_Wrap(psi, 1)
psi_max = dim_max_n_Wrap(psi_maxtem, 1)

month = dimsizes(psi_max)
x  = new((/month/),float)  
x = ispan(1,month,1)
x = x / 12

wks = gsn_open_wks("png", "./b")
plots=new(1,"graphic")
res_0 = True
    res_0@gsnDraw                =  False
    res_0@gsnFrame               =  False
    res_0@tiXAxisString     =  "year" 
plots(0) = gsn_csm_xy(wks, x, psi_max, res_0)

;年数据
f_yaer = addfile(datapath+"YME.nc", "r")
psi_year = f_yaer->psi(:,{-2000:-500},{25:75})
psi_year_maxtem = dim_max_n_Wrap(psi_year, 1)
psi_year_max = dim_max_n_Wrap(psi_year_maxtem, 1)
year = dimsizes(psi_year_max)
xx   = new((/year/),float) 
xx   = ispan(1,year,1)


plots(0) = gsn_csm_xy(wks, x, psi_max, res_0)
plot_year = gsn_csm_xy(wks, xx, psi_year_max, res_0)
overlay(plots(0), plot_year)

resP = True
gsn_panel(wks, plots, (/1,1/), resP)
