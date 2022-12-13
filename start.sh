#!/bin/sh

if [ -z "$VPNADDR" -o -z "$VPNUSER" -o -z "$VPNPASS" ]; then
  echo "Variables VPNADDR, VPNUSER and VPNPASS must be set."; exit;
fi

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

sysctl -w net.ipv4.ip_forward=1

exec openfortivpn $VPNADDR -u $VPNUSER -p $VPNPASS ${VPNCERT:+--trusted-cert $VPNCERT}

