datapath = "/data06/yyq/mls/licom2/ctrl/exe/"

f_yaer = addfile(datapath+"YME.nc", "r")
psi_year = f_yaer->psi(:,{-2000:-500},{25:75})
printVarSummary(psi_year)
psi_year_maxtem = dim_max_n_Wrap(psi_year, 1)
psi_year_max = dim_max_n_Wrap(psi_year_maxtem, 1)

print(psi_year_max)