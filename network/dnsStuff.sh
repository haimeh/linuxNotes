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
pacman -S dnscrypt-proxy dnsmasq

Lets start with nameserver..
/etc/resolv.conf
make sure this has the loopback adress
'''
nameserver 127.0.0.1
'''

once this is done, start the dnscrypt thing
make sure dnsmasq starts before dnscrypt

with dnscrypt we can also pick the dns server
openNIC is recomended?
systemd -r openturtles?

SYSTEMD:
/etc/dhcpcd.conf
'''
nohook resolv.conf
'''

systemctl edit dnscrypt-proxy.socket
or
lib/systemd/system/dnscrypt-proxy.socket
'''
ListenStream=127.0.0.1#1992
ListenDatagram=127.0.0.1#1992
'''
sudo systemctl enable dnscrypt-proxy.service

add name server (google example below) to
/etc/dnsmasq.conf
''' nameserver 8.8.8.8'''
/etc/resolv.conf
'''
proxy-dnssec
resolv-file=/etc/resolv.dnsmasq.conf #or no-resolv
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

