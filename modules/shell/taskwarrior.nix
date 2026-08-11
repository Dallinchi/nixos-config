{
  flake.modules.home.shell = { pkgs, lib, ... }: {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      colorTheme = "dark-blue-256";
      config = {
        color.active = "rgb045";
      };
    };

    programs.fish = {
      
      # Create and start task
      functions.task = ''
        if test "$argv[1]" = "add-active"
            if test (count $argv) -lt 2
                echo "Additional text must be provided."
                return 1
            end
            
            set -l task_args $argv[2..-1]
            
            set -l task_id (command task add $task_args | string match -r 'Created task \K\d+')
            if test -n "$task_id"
                command task $task_id start
            end

        else
            command task $argv
        end
      '';

    };
    
    xdg.configFile."fish/completions/task.fish".text = ''
      complete -c task -n "__fish_use_subcommand" -a add-active -d "operation:Create and immediately start a task"
      '';

  };
}
