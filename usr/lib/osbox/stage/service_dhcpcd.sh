#!/bin/bash


service_dhcpcd(){
  echo "service_dhcpcd $1"
  if [ "$1" == "start" ]; then
      service_dhcpcd_start
      #exit 0
  fi
  if [ "$1" == "stop" ]; then
      service_dhcpcd_stop
      #exit 0
  fi
  if [ "$1" == "enable" ]; then
      service_dhcpcd_enable
      #exit 0
  fi
  if [ "$1" == "disable" ]; then
      service_dhcpcd_disable
      #exit 0
  fi

  #echo "Usage: service_dhcpcd start/stop/enable/disable"

}


service_dhcpcd_start(){
  sudo service dhcpcd start
}
service_dhcpcd_stop(){
  sudo service dhcpcd stop
}

service_dhcpcd_enable(){
  sudo update-rc.d dhcpcd enable
}
service_dhcpcd_disable(){
  sudo update-rc.d dhcpcd disable
}
