#! /bin/bash
# takes the hosts listed in ./forwarderhosts.txt and goes through them all to verify they are running the right version, if they arent, it proceeds to update them
# pre 6.3 splunk agents default root certificates expired on July 21, 2016, a lot of our linux hosts arent in chef yet, so this was created to update them
# https://answers.splunk.com/answers/395886/for-splunk-enterprise-splunk-light-and-hunk-pre-63.html


echo '==========BEGIN SCRIPT RUN ===========' >> windowsforwarders.txt
for i in $(cat ./forwarderhosts.txt); do
    echo ++++----Server: $i ----++++
    portopen=$(nmap $i -Pn -p 22 | grep 22/tcp | awk '{print $2}')
    if [ "${portopen}" = "open" ]; then
    printf "port is open, checking splunk version\n"
    splunkversion="/opt/splunkforwarder/bin/splunk version"
    version=$(ssh $i $splunkversion)
    version=$(echo $version | awk -F ' ' '{print $4}' | tr -d '.')
    printf "$version\n"
    if [ "$version" -lt "641" ] && [ "$version" -gt "600" ]; then
        printf "Updating Version to 6.4.1\n"
        ssh $i 'wget ##UPDATE##splunkforwarder-6.4.1-debde650d26e-linux-2.6-x86_64.rpm'
        ssh $i 'cp -r /opt/splunkforwarder/etc/ ~/splunkconfbak7-25/'
        ssh $i '/opt/splunkforwarder/bin/splunk stop'
        ssh $i 'rpm -Uvh ~/splunkforwarder-6.4.1-debde650d26e-linux-2.6-x86_64.rpm'
        ssh $i '/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes'
    else
        printf "Version is not within the range to be upgraded or forwarder is not installed\n"
    fi
    else
    printf "SSH not detected, adding IP to windowsforwaders file\n"
    echo $i >> windowsforwarders.txt
    fi
done
