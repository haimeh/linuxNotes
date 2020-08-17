 
cd /home/phablet/apt-archive/
mkdir partial
echo dir::cache::archives /home/phablet/apt-archive; >> /etc/apt/apt.conf
#note that the old one is /var/cache/apt/archives

apt install dnscrypt-proxy dnsmasq

#list network things
ss -natu

#etc/NetworkManager/NetworkManager.conf
[main]
dns=dnsmasq

## Configure /etc/dnsmasq.conf
# ignore resolv.conf
no-resolv
# Listen only on localhost
listen-address=127.0.2.1
# dnscrypt is on port 40
server=127.0.2.1#53



sudo vim /etc/init.d/dnscrypt-config
DNSCRYPT_LOCAL_ADDRESS="127.0.2.1:53"
DNSCRYPT_USER=nobody

DNSCRYPT_PROVIDER_NAME=2.dnscrypt-cert.ns3.ca.dns.opennic.glue
DNSCRYPT_PROVIDER_KEY=1C19:7933:1BE8:23CC:CF08:9A79:0693:7E5C:3410:2A56:AC7F:6270:E046:25B2:EDDB:04E3
DNSCRYPT_RESOLVER_ADDRESS="142.4.204.111:443"

#add to start deamon2
--local-address="${DNSCRYPT_PROXY_LOCAL_ADDRESS}"
--user="${DNSCRYPT_PROXY_USER}"
--provider-name="${DNSCRYPT_PROVIDER_NAME}"
--provider-key="${DNSCRYPT_PROVIDER_KEY}"
--resolver-address="${DNSCRYPT_RESOLVER_ADDRESS}"

echo nohook resolv.conf >> /etc/dhcpcd.conf




dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem 
setting up dnscrypt-proxy service... dnscrypt-proxy




Local 
machines       |                                         The Internet
 +-----+       |     Local name resolver                                  DNSCrypt-enabled
 |     +-------+        (e.g. bind)                         ####           name resolver 
 +-----+       |         +------+       +-------+         ########           +------+
               +---------+      +-------+       +=========#########==========+      +
               |         +------+       +-------+          #######           +------+
               |                                            #####
             Local                    DNSCrypt-proxy
            network


Dnscrypt:
#encrypt your dns junk
Dnsmasq:
#local cache of dns query so that you avoid the dns server

In this rundown we are using port 1992
pacman -S dnscrypt-proxy dnsmasq dnsutils

/etc/resolv.conf
'''
nameserver 127.0.0.1
'''



#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DNScrypt
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
systemctl edit dnscrypt-proxy.socket
or
lib/systemd/system/dnscrypt-proxy.socket
'''
ListenStream=127.0.2.1:53
ListenDatagram=127.0.2.1:53
'''

https://servers.opennicproject.org/
/etc/conf.d/dnscrypt-config
'''
DNSCRYPT_LOCALIP=127.0.2.1
DNSCRYPT_LOCALPORT=53
DNSCRYPT_USER=nobody

DNSCRYPT_PROVIDER_NAME=2.dnscrypt-cert.ns3.ca.dns.opennic.glue
DNSCRYPT_PROVIDER_KEY=1C19:7933:1BE8:23CC:CF08:9A79:0693:7E5C:3410:2A56:AC7F:6270:E046:25B2:EDDB:04E3
DNSCRYPT_RESOLVERIP=142.4.204.111

DNSCRYPT_RESOLVERPORT=443
'''

sudo systemctl enable dnscrypt-proxy.service






#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DNSmasq
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/etc/dnsmasq.conf
port=0?
'''
proxy-dnssec
no-resolv
server=127.0.2.1#53
listen-address=127.0.2.1
cache-size=500 ## default is 150?
'''

/etc/NetworkManager/NetworkManager.conf
'''
[main]
plugins=keyfile
dns=dnsmasq
'''

sudo systemctl enable dnsmasq.service

