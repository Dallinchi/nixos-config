#!/usr/bin/env bash

# Получаем список подключённых устройств
connected=$(bluetoothctl devices Connected | awk '{$1=""; $2=""; print substr($0,3)}')

if [[ -z "$connected" ]]; then
  echo " Disconnected"
  exit 0
fi

# Если подключено несколько — выводим через запятую
names=$(echo "$connected" | tr '\n' ',' | sed 's/,$//')

echo " ${names}"

