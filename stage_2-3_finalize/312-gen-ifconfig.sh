#!/bin/bash
# sysv gen-ifconfig init script
cat > /etc/rc.d/init.d/gen-ifconfig << "GENEOF"
### BEGIN INIT INFO
# Provides:            gen-ifconfig
# Required-Start:      $network
# Required-Stop:       $network
# Default-Start:       S
# Default-Stop:
# Short-Description:   generates dyanmic ifconfig
# Description:         generates dynamic ifconfig on load from iface
### END INIT INFO
CONFIG_DIR="/etc/sysconfig"
mkdir -p $CONFIG_DIR

echo "Generating dyanmic interface config..."

for iface in $(ls /sys/class/net); do
    [ "$iface" = "lo" ] && continue
    FILE="$CONFIG_DIR/ifconfig.$iface"
    if [ ! -f "$FILE" ]; then
        echo "Creating $FILE"
        cat > "$FILE" <<EOF
ONBOOT="yes"
IFACE="$iface"
SERVICE="dhcpcd"
DHCP_START="-b -q -h $HOSTNAME"
DHCP_STOP="-k"
EOF
    fi
done

# End of gen-ifconfig
GENEOF
chmod -v 755 /etc/rc.d/init.d/gen-ifconfig
ln -sv ../init.d/gen-ifconfig /etc/rc.d/rcS.d/S60gen-ifconfig
