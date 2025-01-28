#!/usr/bin/env bash

$STD apt-get update
$STD apt-get upgrade -y

$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc

mkdir -p /var/lib/airdcpp/
chmod 775 /var/lib/airdcpp/
$STD wget --content-disposition 'https://web-builds.airdcpp.net/stable/airdcpp_latest_master_64-bit_portable.tar.gz'
$STD tar -xvzf airdcpp_latest_master.*.tar.gz
mv airdcpp-webclient /opt
chmod 775 /opt/airdcpp-webclient

cat </etc/systemd/system/airdcpp.service
[Unit]
Description=Airdcpp Daemon
After=syslog.target network.target
[Service]
UMask=0002
Type=simple
ExecStart=/opt/airdcpp-webclient/airdcppd
WorkingDirectory=/opt/airdcpp-webclien
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF

systemctl -q daemon-reload
systemctl enable --now -q airdcpp

motd_ssh
customize

rm -rf airdcpp_latest_master.*.tar.gz
$STD apt-get -y autoremove
$STD apt-get -y autoclean

