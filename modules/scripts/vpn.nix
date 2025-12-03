{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "start-vpn-namespace" ''
	# СКРИПТ ДЛЯ ЗАПУСКА VPN СОЕДИНЕНИЯ В ОТДЕЛЬНОМ NETWORK NAMESPACE

	
	# Название сетевого пространства
	NAMESPACE="vpn_ns"

	# Название виртуального интерфейса
	VETH0="veth0"
	VETH1="veth1"

	# Интерфейс для выхода в интернет
	# VPN_NAMESPACE_INTERFACE="enp4s0" # override in host settings
  echo "NETWORK INTERFACE: $VPN_NAMESPACE_INTERFACE"

	#echo "Удаляем существующее пространство имен, если оно есть"
	#ip netns del $NAMESPACE
	#ip link delete $VETH0

	echo "Создаем сетевое пространство"
	sudo ip netns add $NAMESPACE

	echo "Создаем виртуальный Ethernet интерфейс"
	sudo ip link add $VETH0 type veth peer name $VETH1

	echo Привязывем один конец интерфейса к пространству имен
	sudo ip link set $VETH1 netns $NAMESPACE

	echo Активируем интерфейсы
	sudo ip link set $VETH0 up
	sudo ip netns exec $NAMESPACE ip link set $VETH1 up

	echo Настраиваем IP-адреса
	sudo ip addr add 192.168.2.1/24 dev $VETH0
	sudo ip netns exec $NAMESPACE ip addr add 192.168.2.2/24 dev $VETH1

	echo Настраиваем маршрутизацию
	sudo ip netns exec $NAMESPACE ip route add default via 192.168.2.1

	echo Включаем IP forwarding
	sudo echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

	echo Настраиваем NAT для выхода в интернет
	sudo iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -o $VPN_NAMESPACE_INTERFACE -j MASQUERADE
	sudo iptables -A FORWARD -i $VPN_NAMESPACE_INTERFACE -o $VETH0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -A FORWARD -i $VETH0 -o $VPN_NAMESPACE_INTERFACE -j ACCEPT

	# Запускаем dhcpcd внутри пространства имен
	#sudo ip netns exec $NAMESPACE dhcpcd $VETH1

	echo "Настраиваем звук (и не только)"
	sudo ip netns exec export XDG_RUNTIME_DIR=/run/user/$(id -u)
	sudo mkdir -p /run/user/$(id -u)

	echo Запускаем VPN соединение
	sudo ip netns exec $NAMESPACE connect-in-namespace

	echo "Пингуем, что бы сеть не падала (хз почему это нужно, но мне нужно -_-)"
	echo "Проверяем соединение с интернетом из пространства имен $NAMESPACE..."
	sudo ip netns exec $NAMESPACE ping google.com

	exit 0
    '')
    (writeShellScriptBin "exec-in-namespace" ''

  sudo ip netns exec vpn_ns su - $USER -c "
	export DISPLAY=$DISPLAY;
	export WAYLAND_DISPLAY=$WAYLAND_DISPLAY;
	export XDG_RUNTIME_DIR=/run/user/$(id -u);
	export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS;
	screen -dmS ns_vpn_session_app $1 $2 $3 $4"    
    '')
    (writeShellScriptBin "connect-in-namespace" ''
        
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
  ];
}

