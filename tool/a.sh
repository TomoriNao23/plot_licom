#!bash
###################################################################################
#利用bash和cdo工具,利用月平均文件整合为年平均文件，并且整合为一个文件YME.NC
###################################################################################

#给出输入文件位置和命名规则
datapath=/data06/yyq/mls/licom2/GM-Case1501/exe/
law=MMEAN

#根据输出文件计算开始年份，结束年份和总的年份
fileslist=$(ls "$datapath$law"*)
file_first=$(echo "$fileslist" | head -n 1)
year_start=$((10#$(echo "$file_first" | grep -oP "${law}\d+" | sed "s/${law}//")))
file_end=$(echo "$fileslist" | tail -n 1)
year_end=$((10#$(echo "$file_end" | grep -oP "${law}\d+" | sed "s/${law}//")))
number=$(($year_end - $year_start + 1 ))

#根据12个月数据计算出年平均,输出结果为文件YME????.nc,并且利用提交后台的方式实现并行
for ((i=1; i<=number; i++)); do
year=$(($year_start + $i - 1))
input=$(ls $fileslist|grep $(printf "%04d" $year))
cdo ensmean $input $datapath"YME"$(printf "%04d" $i).nc 
done

#将所有年平均文件整合为YME.nc,并且删除中间文件和fort.22.*文件
rm -f $(ls $datapath"YME".nc)
cdo mergetime $(ls "$datapath""YME"*) $datapath"YME".nc
rm -f $(ls $datapath"YME"????.nc)
rm -f $(ls $datapath"fort.22."* 2>/dev/null)