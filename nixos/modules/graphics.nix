{
  config,
  pkgs,
  ...
}:
{
  # Display drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA — PRIME offload, Quadro P2000 Mobile
  hardware.nvidia = {
    open = false;
    nvidiaSettings = false;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      sync.enable = false;

      intelBusId = "PCI:0:2:0"; # Intel UHD 630
      nvidiaBusId = "PCI:1:0:0"; # Quadro P2000 Mobile
    };

    powerManagement = {
      enable = true;
      finegrained = false;
    };
    dynamicBoost.enable = false;
  };

  # Graphics — Intel iGPU, VAAPI, OpenCL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      ocl-icd
      intel-media-driver
      nvidia-vaapi-driver
      intel-compute-runtime
    ];
  };

  boot.blacklistedKernelModules = [
    "nouveau"
    "nova_core"
  ];
}
