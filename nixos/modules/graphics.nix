{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa # Open-source OpenGL and Vulkan graphics drivers
      mesa-demos # OpenGL and Vulkan demo and test utilities
      vulkan-loader # Vulkan runtime loader for applications
      vulkan-tools # Vulkan diagnostic and utility tools (vkcube, etc.)
      vulkan-validation-layers # Vulkan API validation and debugging layers
      vulkan-extension-layer # Additional Vulkan extension support layers
      libvdpau-va-gl # VDPAU to VA-API translation layer
      intel-media-driver # Intel GPU media driver for VA-API (iHD)
      libva # Video Acceleration API library
      libva-utils # VA-API command-line test utilities
      nvidia-vaapi-driver # VA-API support layer for NVIDIA GPUs
    ];
  };

  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "nvidia-run" ''
      #!/bin/sh
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];
}
