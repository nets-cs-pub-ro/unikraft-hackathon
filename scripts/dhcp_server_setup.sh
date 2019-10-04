#!/bin/bash

SCRIPT_DIR="$(dirname $0)"
source "$SCRIPT_DIR/config.sh"

NETWORK=10.0.0.0
START_IP=10.0.0.5
END_IP=10.0.0.100
BCAST=10.0.0.255
NETMASK=255.255.255.0

INTERFACE_FILE="/etc/default/isc-dhcp-server"
CONFIG_FILE="/etc/dhcp/dhcpd.conf"

INTERFACE_CONFIG="
INTERFACESv4=\"$BRIDGE\"
INTERFACESv6=\"\"
"

CONFIG_APPEND="
subnet $NETWORK netmask $NETMASK {
  range $START_IP $END_IP;
  option routers $GATEWAY;
  option broadcast-address $BCAST;
}
"

echo -n "Installing $DHCP_SERVER..."
apt-get install $DHCP_SERVER -y &> /dev/null
echo "Done"

echo -n "Setting up config files..."
echo $INTERFACE_CONFIG > $INTERFACE_FILE
echo $CONFIG_APPEND >> $CONFIG_FILE
echo "Done"

echo "Starting DHCP server on interface $PIPE_END_HOST"
systemctl start $DHCP_SERVER
systemctl status $DHCP_SERVER

