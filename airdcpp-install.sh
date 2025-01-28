#!/usr/bin/env bash

msg_info "Actualizando LXC"
$STD apt-get update
$STD apt-get upgrade -y

msg_info "Instalando Dependencias"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing AirdcPP"
mkdir -p /var/lib/airdcpp/
chmod 775 /var/lib/airdcpp/
$STD wget --content-disposition 'https://web-builds.airdcpp.net/stable/airdcpp_latest_master_64-bit_portable.tar.gz'
$STD tar -xvzf airdcpp_latest_master.*.tar.gz
mv Airdcpp /opt
chmod 775 /opt/Airdcpp
msg_ok "Instalado Airdcpp"

msg_info "Creando Servicio"
cat </etc/systemd/system/airdcpp.service
[Unit]
Description=Airdcpp Daemon
After=syslog.target network.target
[Service]
UMask=0002
Type=simple
ExecStart=/opt/Airdcpp/Airdcpp -nobrowser -data=/var/lib/airdcpp/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl -q daemon-reload
systemctl enable --now -q airdcpp
msg_ok "Servicio Creado"

motd_ssh
customize

msg_info "Limpiando"
rm -rf airdcpp_latest_master.*.tar.gz
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Limpiado"
