#!/bin/bash

sudo apt-get install iptables # Will work on ubuntu and other apt systems

cat > /tmp/iptables.test.rules <<EOF
*filter

# Allow local traffic
-A INPUT -i lo -j ACCEPT
-A INPUT -i ! lo -d 127.0.0.0/8 -j REJECT

# Allow a connection if it has already been accepted
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow us to communicate out
-A OUTPUT -j ACCEPT

# Our rules for allowing traffic
iptables -A INPUT -p tcp --destination-port 80 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT
iptables -A INPUT -p tcp --destination-port 443 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT

# Enable ssh because we still want to get to the box
-A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT

# log denied calls so that you can monitor them
-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

-A INPUT -j REJECT
-A FORWARD -j REJECT
EOF

sudo iptables-restore < /tmp/iptables.test.rules
sudo iptables-save > /tmp/iptables.up.rules

