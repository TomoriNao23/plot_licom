datapath=/data06/yyq/mls/licom2/addwater_new/exe/
law=MMEAN

fileslist=$(ls "$datapath$law"*)
file_first=$(echo "$fileslist" | head -n 1)
year_start=$((10#$(echo "$file_first" | grep -oP "${law}\d+" | sed "s/${law}//")))
file_end=$(echo "$fileslist" | tail -n 1)
year_end=$((10#$(echo "$file_end" | grep -oP "${law}\d+" | sed "s/${law}//")))
number=$(($year_end - $year_start +1 ))

for ((i=1; i<=number; i++)); do
year=$(($year_start + $i - 1))
input=$(ls $fileslist|grep $(printf "%04d" $year))
cdo ensmean $input $datapath"YME"$(printf "%04d" $i).nc
done
rm -f $(ls $datapath"YME".nc)
cdo mergetime $(ls "$datapath""YME"*) $datapath"YME".nc
rm -f $(ls $datapath"YME"????.nc)
rm -f $(ls $datapath"fort.22."* 2>/dev/null)
