# ipsec.conf - strongSwan IPsec configuration file

# basic configuration

config setup
        # strictcrlpolicy=yes
        # uniqueids = no


conn VPN_to_AAVN
        keyexchange=ikev2
        dpdaction=clear
        dpddelay=300s
        rekey=no
                left=%any
                leftid=52.220.21.183
                leftsubnet=10.123.0.0/16
                right=203.162.146.90
                rightid=203.162.146.90
                rightsubnet=192.168.70.0/24,192.168.73.0/24
                authby=secret
                type=tunnel
                ike=aes256-sha1-modp2048
                esp=aes256-sha1-modp2048
                auto=start
                leftfirewall=yes
                mobike=no

conn client2site
         dpdaction=clear
                 dpddelay=300s
                 rekey=no
                 left=%defaultroute
                 leftfirewall=yes
                 right=%any
                 ikelifetime=60m
                 keylife=20m
                 rekeymargin=3m
                 keyingtries=1
                 auto=add
                 type=transport
                 keyexchange=ikev1
                 authby=secret
                 leftprotoport=udp/l2tp
                 left=%any
                 right=%any
                 rekey=no
                 forceencaps=yes
                 ike=aes256-sha2_256


[global]
port = 1701
auth file = /etc/ppp/chap-secrets
debug avp = yes
debug network = yes
debug state = yes
debug tunnel = yes
[lns default]
ip range = 10.125.100.2-10.125.100.126
local ip = 10.125.100.1
refuse pap = yes
refuse chap = yes
;require chap = yes
refuse authentication = yes
;require authentication = yes
name = l2tpd
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes


option /etc/ppp/pptpd-options.conf
localip 10.125.100.1
remoteip 10.125.100.127-244



require-mschap-v2
ipcp-accept-local
ipcp-accept-remote
ms-dns 10.123.0.2
noccp
crtscts
idle 1800
mtu 1280
mru 1280
lock
lcp-echo-failure 10
lcp-echo-interval 60
connect-delay 5000
logfd 2
logfile /var/log/xl2tpd.log
plugin winbind.so
ntlm_auth-helper '/usr/bin/ntlm_auth --helper-protocol=ntlm-server-1 --require-membership-of="AAVN\\vpn-cloud"'




plugin winbind.so
ntlm_auth-helper '/usr/bin/ntlm_auth --helper-protocol=ntlm-server-1 --require-membership-of="AAVN\\vpn-cloud"'

name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 10.123.0.2
proxyarp
lock
nobsdcomp
novj
novjccomp
nologfd
nodefaultroute




[global]
security = ads
realm = DEV.LOCAL
# If the system doesn't find the domain controller automatically, you may need the following line
password server = xxx.xxx.xxx.xxx
# note that workgroup is the 'short' domain name
workgroup = DEV
# winbind separator = +
idmap uid = 10000-20000
idmap gid = 10000-20000
winbind enum users = yes
winbind enum groups = yes
template homedir = /home/%D/%U
template shell = /bin/bash
client use spnego = yes
client ntlmv2 auth = yes
encrypt passwords = yes
winbind use default domain = no
allow trusted domains = yes
restrict anonymous = 2
## Browsing/Identification ###

[libdefaults]

default_realm = DEV.LOCAL
# The following krb5.conf v

[realms]

  DEV.LOCAL = {
#       auth_to_local = RULE:[1:$0\$1](^AAVN\.LOCAL\\.*)s/^AAVN\.LOCAL/AAVN/
#       auth_to_local = DEFAULT
kdc = adv1.dev.local
admin_server = adv1.dev.local
  }










