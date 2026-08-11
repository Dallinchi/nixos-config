{
  flake.modules.nixos.pipewire = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire = {
        "92-audio-properties" = {
          "context.properties" = {
            # Базовая частота дискретизации
            "default.clock.rate" = 48000;
            # Разрешаем переключение на 44.1kHz без ресэмплинга, если трек этого требует
            "default.clock.allowed-rates" = [ 44100 48000 ];
            
            # Настройки буфера (квантования)
            "default.clock.quantum" = 1024;      # Размер буфера по умолчанию
            "default.clock.min-quantum" = 32;     # Позволяет снижать задержку, если нужно приложению
            "default.clock.max-quantum" = 2048;   # Порог для предотвращения заиканий при высокой нагрузке
          };
        };
      };
    };
  };
}
