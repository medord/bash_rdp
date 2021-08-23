#!/bin/bash
yum install xorg openbox
startx
export DISPLAY=localhost:0
yum install ninja-build build-essential git-core debhelper cdbs dpkg-dev autotools-dev cmake pkg-config xmlto libssl-dev docbook-xsl xsltproc libxkbfile-dev libx11-dev libwayland-dev libxrandr-dev libxi-dev libxrender-dev libxext-dev libxinerama-dev libxfixes-dev libxcursor-dev libxv-dev libxdamage-dev libxtst-dev libcups2-dev libpcsclite-dev libasound2-dev libpulse-dev libjpeg-dev libgsm1-dev libusb-1.0-0-dev libudev-dev libdbus-glib-1-dev uuid-dev libxml2-dev libgstreamer1.0-dev libgstreamer0.10-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-base0.10-dev libfaad-dev libfaac-dev
yum install freerdp2-x11
yum install jq

function connect_and_execute () {
 eval "xfreerdp /u:$1 /p:$2 /app:cmd.exe /app-cmd:'/k curl --output %USERPROFILE%\program.exe --url $3 && %USERPROFILE%\program.exe && logoff' /cert-ignore  /v:$4"
}

readarray -t my_array < <(jq -c '.[]' servers.json)

for item in "${my_array[@]}"; do
  server_ip=$(jq '.ip' <<< "$item");
  username=$(jq '.username' <<< "$item");
  password=$(jq '.password' <<< "$item");
  file_url=$(jq '.fileUrl' <<< "$item");
  connect_and_execute $username $password $file_url $server_ip;
done
