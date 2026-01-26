
{
  host,
  ...
}:
{
  environment.etc."xdg/dallinchi-sfx".source = ./sfx;
  # xdg.configFile = {
  #   "dallinchi-sfx/" = {
  #     source = ./sfx;
  #     recursive = true;
  #   };
  # };
}
