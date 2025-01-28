#!/usr/bin/env bash

# Actualización e instalación de paquetes básicos
apt-get update
apt-get upgrade -y
apt-get install -y curl sudo mc

# Crear directorios necesarios
mkdir -p /var/lib/airdcpp/
chmod 775 /var/lib/airdcpp/

# Limpiar archivos duplicados previos
rm -f airdcpp_latest_master_64-bit_portable.tar.gz*

# Descargar el archivo
wget --content-disposition 'https://web-builds.airdcpp.net/stable/airdcpp_latest_master_64-bit_portable.tar.gz'

# Extraer el archivo y manejar errores
if [ -f "airdcpp_latest_master_64-bit_portable.tar.gz" ]; then
  tar -xvzf airdcpp_latest_master_64-bit_portable.tar.gz
else
  echo "Error: No se pudo descargar el archivo correctamente."
  exit 1
fi

# Verificar si el directorio existe
if [ ! -d "airdcpp-webclient" ]; then
  echo "Error: El directorio airdcpp-webclient no se creó correctamente."
  exit 1
fi

# Mover y configurar Airdcpp
mv airdcpp-webclient /opt
chmod 775 /opt/airdcpp-webclient

# Crear el archivo del servicio systemd
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

# Recargar systemd y habilitar el servicio
systemctl daemon-reload
systemctl enable --now airdcpp

# Limpieza final
rm -rf airdcpp_latest_master_64-bit_portable.tar.gz
apt-get -y autoremove
apt-get -y autoclean
