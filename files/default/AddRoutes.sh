# Always accept loopback traffic
iptables -A INPUT -i lo -j ACCEPT
 
# We allow traffic from the HostMachine1 side
iptables -A INPUT -i enp0s9  -j ACCEPT
 
# We allow traffic from the HostMachine2 side
iptables -A INPUT -i enp0s10  -j ACCEPT

# Repeat same steps on reverse route
iptables -t nat -A POSTROUTING -o enp0s9   -j MASQUERADE
 
iptables -A FORWARD -i enp0s10 -o enp0s9  -m state --state RELATED,ESTABLISHED -j ACCEPT
 
iptables -A FORWARD -i enp0s10 -o enp0s9  -j ACCEPT