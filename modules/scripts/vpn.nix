{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "start-vpn-namespace" ''
      	#!/usr/bin/env bash

	# СКРИПТ ДЛЯ ЗАПУСКА VPN СОЕДИНЕНИЯ В ОТДЕЛЬНОМ NETWORK NAMESPACE

	
	# Название сетевого пространства
	NAMESPACE="vpn_ns"

	# Название виртуального интерфейса
	VETH0="veth0"
	VETH1="veth1"

	# Интерфейс для выхода в интернет
	INTERNET_IFACE="wlp2s0"

	#echo "Удаляем существующее пространство имен, если оно есть"
	#ip netns del $NAMESPACE
	#ip link delete $VETH0

	echo "Создаем сетевое пространство"
	ip netns add $NAMESPACE

	echo "Создаем виртуальный Ethernet интерфейс"
	ip link add $VETH0 type veth peer name $VETH1

	echo Привязывем один конец интерфейса к пространству имен
	ip link set $VETH1 netns $NAMESPACE

	echo Активируем интерфейсы
	ip link set $VETH0 up
	ip netns exec $NAMESPACE ip link set $VETH1 up

	echo Настраиваем IP-адреса
	ip addr add 192.168.2.1/24 dev $VETH0
	ip netns exec $NAMESPACE ip addr add 192.168.2.2/24 dev $VETH1

	echo Настраиваем маршрутизацию
	ip netns exec $NAMESPACE ip route add default via 192.168.2.1

	echo Включаем IP forwarding
	echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

	echo Настраиваем NAT для выхода в интернет
	iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o $INTERNET_IFACE -j MASQUERADE
	iptables -A FORWARD -i $INTERNET_IFACE -o $VETH0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -i $VETH0 -o $INTERNET_IFACE -j ACCEPT

	# Запускаем dhcpcd внутри пространства имен
	#sudo ip netns exec $NAMESPACE dhcpcd $VETH1

	echo "Настраиваем звук (и не только)"
	ip netns exec export XDG_RUNTIME_DIR=/run/user/$(id -u)
	mkdir -p /run/user/$(id -u)

	echo Запускаем VPN соединение
	ip netns exec $NAMESPACE connect-in-namespace

	echo "Пингуем, что бы сеть не падала (хз почему это нужно, но мне нужно -_-)"
	echo "Проверяем соединение с интернетом из пространства имен $NAMESPACE..."
	ip netns exec $NAMESPACE ping google.com

	exit 0
    '')
    (writeShellScriptBin "exec-in-namespace" ''
	#!/usr/bin/env bash

	sudo ip netns exec vpn_ns su - $USER -c "
	export DISPLAY=$DISPLAY;
	export WAYLAND_DISPLAY=$WAYLAND_DISPLAY;
	export XDG_RUNTIME_DIR=/run/user/$(id -u);
	export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS;
	screen -dmS ns_vpn_session_app $1 $2 $3 $4"    
    '')
    (writeShellScriptBin "connect-in-namespace" ''
	#!/usr/bin/env bash
        
	# Имя сеанса screen
	SESSION_NAME="vpn_session"

	echo Проверяем, запущен ли сеанс screen
	if screen -list | grep -q "$SESSION_NAME"; then
	    screen -S $SESSION_NAME -X quit
	    echo "Сеанс уже был, сносим его"
	fi
	#echo -e "\tПодключение к VPN сети"
	echo Запускаем openconnect в новом сеансе screen
	screen -S "$SESSION_NAME" -d -m bash -c 'echo "$(cat ${config.sops.secrets."openconnect/tlinmo/password".path})" | openconnect --user=$(cat ${config.sops.secrets."openconnect/tlinmo/username".path}) --passwd-on-stdin "$(cat ${config.sops.secrets."openconnect/tlinmo/server".path})"'
    '')

    (writeShellScriptBin "test-secrets" ''
    
	  echo "$(cat ${config.sops.secrets."openconnect/tlinmo/username".path})"
    echo "Test Secrets"

    '')

  ];
}

