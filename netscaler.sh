#!/bin/bash

netscalers=(
10.61.140.64
172.23.16.80
10.61.156.82
175.45.150.44
175.45.150.62
10.61.156.84
10.53.140.51
10.53.140.50
)

for i in "${netscalers[@]}"; do
    echo ++++----Netscaler: $i ----++++
    scp /Users/naterd/code/ssl/g0/sha2/############### nsroot@$i:/nsconfig/ssl/###########
    scp /Users/naterd/code/ssl/g0/sha2/###############.key nsroot@$i:/nsconfig/ssl/#############.key
    ssh nsroot@$i 'add ssl certKey ######### -cert ############.crt -key ##########.key -password ########'
    ssh nsroot@$i 'link ssl ############# DigiCertCA_Bundle'

done
