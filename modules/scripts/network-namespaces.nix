{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "start-vpn-namespace" ''
      set -eo pipefail

      # === Конфигурация ===
      NAMESPACE="ns_vpn"
      VETH0="veth0"
      VETH1="veth1"
      SUBNET="192.168.2.0/24"
      HOST_IP="192.168.2.1/24"
      NS_IP="192.168.2.2/24"
      COMMENT_TAG="vpn-ns"
      # TODO: Сюда бы хорошо встал интерейс из variables
      [[ -z "$VPN_NAMESPACE_INTERFACE" ]] && VPN_NAMESPACE_INTERFACE="enp4s0"

      echo "NETWORK INTERFACE: $VPN_NAMESPACE_INTERFACE"


      # === Проверка root ===
      if [[ $EUID -ne 0 ]]; then
          echo "Этот скрипт нужно запускать через sudo!"
          exit 1
      fi


      # === Функция очистки ===
      cleanup() {
          echo "[CLEANUP] Начинаю очистку..."

          echo "[CLEANUP] Удаляю iptables правила..."
          iptables -t nat -S | grep "$COMMENT_TAG" | sed 's/-A/iptables -t nat -D/' | bash || true
          iptables -S | grep "$COMMENT_TAG" | sed 's/-A/iptables -D/' | bash || true

          echo "[CLEANUP] Удаляю veth и namespace..."
          ip link del "$VETH0" 2>/dev/null || true

          echo "[CLEANUP] Удаляю route..."
          ip netns exec "$NAMESPACE" ip route del default 2>/dev/null || true

          echo "[CLEANUP] Готово."
      }
      trap cleanup EXIT INT TERM


      # === Проверяем, нет ли старого окружения ===
      ip link del "$VETH0" 2>/dev/null || true


      # === Создание namespace ===
      echo "Создаем сетевое пространство"
      if ! ip netns list | grep -q "^$NAMESPACE\b"; then
          ip netns add "$NAMESPACE"
          
          # Т.к я не удаляю namespace при перезапуске скрипта,
          # он может остаться в памяти, и при перезагрузке
          # могут быть ошибки с использованием namespace
          ip netns delete "$NAMESPACE"
          ip netns add "$NAMESPACE"

      fi

      echo "Создаем veth пару"
      ip link add "$VETH0" type veth peer name "$VETH1"
      ip link set "$VETH1" netns "$NAMESPACE"

      echo "Поднимаем интерфейсы"
      ip link set "$VETH0" up
      ip netns exec "$NAMESPACE" ip link set "$VETH1" up


      echo "Настраиваем IP"
      ip addr add "$HOST_IP" dev "$VETH0"
      ip netns exec "$NAMESPACE" ip addr add "$NS_IP" dev "$VETH1"

      echo "Настраиваем маршрут по умолчанию"
      ip netns exec "$NAMESPACE" ip route add default via 192.168.2.1


      echo "Включаем IP forwarding"
      echo 1 | tee /proc/sys/net/ipv4/ip_forward > /dev/null


      echo "Настраиваем NAT (iptables)"
      iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$VPN_NAMESPACE_INTERFACE" -j MASQUERADE -m comment --comment "$COMMENT_TAG"
      iptables -A FORWARD -i "$VPN_NAMESPACE_INTERFACE" -o "$VETH0" -m state --state RELATED,ESTABLISHED -j ACCEPT -m comment --comment "$COMMENT_TAG"
      iptables -A FORWARD -i "$VETH0" -o "$VPN_NAMESPACE_INTERFACE" -j ACCEPT -m comment --comment "$COMMENT_TAG"


      # === Запуск VPN внутри namespace ===
      echo "Запускаем VPN-соединение…"
      ip netns exec "$NAMESPACE" connect-in-namespace &


      # === Проверка сети ===
      echo "Проверяем интернет…"
      ip netns exec "$NAMESPACE" ping google.com
    '')

    (writeShellScriptBin "exec-in-namespace" ''
      IFACE="$1"
      shift

      sudo -E ip netns exec "$IFACE" \
        su -m - "$USER" -c "screen -dmS ns_vpn_session_app $*"
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
      echo "Запускаем openconnect в новом сеансе screen"
      screen -S "$SESSION_NAME" -d -m bash -c 'echo "$(cat ${config.sops.secrets."openconnect/tlinmo/password".path})" | openconnect --user=$(cat ${config.sops.secrets."openconnect/tlinmo/username".path}) --passwd-on-stdin "$(cat ${config.sops.secrets."openconnect/tlinmo/server".path})"'
    '')

    (writeShellScriptBin "iface-namespace" ''
      # Скрипт для передачи физического интерфейса в network namespace и обратно
      # Использование:
      #   ./iface-ns take <interface>   -> отдаёт интерфейс в namespace
      #   ./iface-ns give <interface>   -> возвращает интерфейс на хост
      #   ./iface-ns enter <interface>  -> заходит в namespace под текущим пользователем

      set -e

      if [ "$#" -ne 2 ]; then
          echo "Usage: $0 <take|give|enter> <interface>"
          exit 1
      fi

      ACTION="$1"
      IFACE="$2"
      NS_NAME="ns_$IFACE"

      case "$ACTION" in
          take)
              echo "Создаём namespace $NS_NAME и отдаём в него интерфейс $IFACE..."

              # Создаём namespace, если ещё нет
              sudo ip netns add "$NS_NAME" 2>/dev/null || true

              # Переносим интерфейс в namespace
              sudo ip link set "$IFACE" netns "$NS_NAME"

              # Поднимаем интерфейс в namespace
              # sudo ip netns exec "$NS_NAME" ip link set "$IFACE" up

              # Попытка получить IP через DHCP
              sudo ip netns exec "$NS_NAME" dhcpcd -K "$IFACE" || true


              echo "Интерфейс $IFACE теперь принадлежит namespace $NS_NAME."
              ;;

          give)
              echo "Возвращаем интерфейс $IFACE из namespace $NS_NAME обратно хосту..."

              # Проверяем, существует ли namespace
              if ! ip netns list | grep -q "^$NS_NAME"; then
                  echo "Namespace $NS_NAME не найден!"
                  exit 1
              fi

              # Переносим интерфейс обратно на хост
              sudo ip netns exec "$NS_NAME" ip link set "$IFACE" netns 1
              sudo ip link set "$IFACE" up

              # Удаляем namespace
              sudo ip netns del "$NS_NAME" 2>/dev/null || true

              echo "Интерфейс $IFACE возвращён на хост."
              ;;

          enter)
              # Проверяем, существует ли namespace
              if ! ip netns list | grep -q "^$NS_NAME"; then
                  echo "Namespace $NS_NAME не найден!"
                  exit 1
              fi

              echo "Заходим в namespace $NS_NAME..."
              sudo -E ip netns exec "$NS_NAME" su -m "$USER"
              ;;

          *)
              echo "Unknown action: $ACTION"
              echo "Use 'take', 'give' or 'enter'."
              exit 1
              ;;
      esac
    '')
  ];
}

