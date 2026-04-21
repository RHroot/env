{
  config,
  pkgs,
  ...
}:{
  programs.dwl.enable = true;
  environment.systemPackages = with pkgs:[
    wlr-protocols
    wlroots_0_19
    foot
    swaybg
  ];
}
