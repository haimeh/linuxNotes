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

/etc/dhcpcd.conf
'''
nohook resolv.conf
'''


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# DNScrypt
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
systemctl edit dnscrypt-proxy.socket
or
lib/systemd/system/dnscrypt-proxy.socket
'''
ListenStream=127.0.0.1#1992
ListenDatagram=127.0.0.1#1992
'''

https://servers.opennicproject.org/
/etc/conf.d/dnscrypt-config
'''
DNSCRYPT_LOCALIP=127.0.0.1
DNSCRYPT_LOCALPORT=1992
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
server=127.0.0.1#1992
listen-address=127.0.0.1
cache-size=500 ## default is 150?
'''

/etc/NetworkManager/NetworkManager.conf
'''
[main]
plugins=keyfile
dns=dnsmasq
'''

sudo systemctl enable dnsmasq.service

