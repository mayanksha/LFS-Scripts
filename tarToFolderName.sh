#!/bin/bash

#Developed by : Mayank Sharma 
#Project : Linux From Scratch under Association of Computing Activities (ACA), IIT Kanpur
#License : MIT

tarFolderNames=()
MainArray=()

tarPath=($(ls -a ${1} | grep -P '.*\.tar\.' | xargs -n1 echo ${1} | sed -r 's/ /\//g' | grep -P '.*.tar.[bz2,xz,gz]*$' | xargs  -n1 -i echo {} | sed -r 's/ /\n/g'))
echo "Working!"	

counter=0
for i in ${tarPath[@]}
do
		temp=$(tar -tf $i | head -n1 | sed -r 's@/.*@@g' | xargs -n1 -i echo {})
		tarFolderNames+=("$temp")
		printf '%s %s \n' "$({tarPath[$counter]} | sed -r 's/\n/ /g') " "${tarFolderNames[$counter]}"
		counter=$((counter + 1))
done

printf "Done! A file named tarFolderNames.txt was created."


##################### BELOW IS OBSOLETE ##################### 
#This script can't be run as it is! The problem lies in tar -tf ${0} being extrapolated by the script to the ${0} argument passed to the string, i.e. /bin/bash
#Copy below command and run it


#ls -a $LFS/sources | grep -P '.*\.tar\.' | xargs -n1 echo $LFS/sources | sed -r 's/ /\//g' | grep -P '.*.tar.[bz2,xz,gz]*$' | xargs -L1 -n1 bash -c "tar -tf ${0} | tail -n1 & echo ${0}" | sed -r 's@/.*@@g'
