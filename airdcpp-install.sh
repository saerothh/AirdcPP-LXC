#!/usr/bin/env bash

apt-get update
apt-get upgrade -y

apt-get install -y curl sudo mc

mkdir -p /var/lib/airdcpp/
chmod 775 /var/lib/airdcpp/

rm -f airdcpp_latest_master_*
wget --content-disposition 'https://web-builds.airdcpp.net/stable/airdcpp_latest_master_64-bit_portable.tar.gz'
tar -xvzf airdcpp_latest_master_*.tar.gz
mv airdcpp-webclient /opt
chmod 775 /opt/airdcpp-webclient

cat <<EOF > /etc/systemd/system/airdcpp.service
[Unit]
Description=Airdcpp Daemon
After=syslog.target network.target

[Service]
UMask=0002
Type=simple
ExecStart=/opt/airdcpp-webclient/airdcppd
WorkingDirectory=/opt/airdcpp-webclient
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now airdcpp

# Limpieza final
rm -rf airdcpp_latest_master.*.tar.gz
apt-get -y autoremove
apt-get -y autoclean

