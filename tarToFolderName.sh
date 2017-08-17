#This script can't be run as it is! The problem lies in tar -tf ${0} being extrapolated by the script to the ${0} argument passed to the string, i.e. /bin/bash
#Copy below command and run it
ls -a $LFS/sources | grep -P '.*\.tar\.' | xargs -n1 echo $LFS/sources | sed -r 's/ /\//g' | grep -P '.*.tar.[bz2,xz,gz]*$' | xargs -L1 -n1 bash -c "tar -tf ${0} | tail -n1 & echo ${0}" | sed -r 's@/.*@@g'
