{
  config,
  pkgs,
  ...
}: {
  # Display drivers
  services.xserver.videoDrivers = ["nvidia"];

  # NVIDIA — PRIME offload, Quadro P2000 Mobile
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    cudaSupport = true;
    nvidiaSettings = true;
    open = false;

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
      finegrained = true;
    };
  };

  # Graphics — Intel iGPU, VAAPI, OpenCL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      intel-ocl
      vulkan-loader
      vulkan-validation-layers
      libva
      libva-utils
      libvdpau-va-gl
      libva-vdpau-driver
      ocl-icd
    ];
  };

  # Environment — Intel/Mesa as default GL
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };

  # Kernel modules
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];

  # Kernel params
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_guc=2"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # Packages — tools + wrappers
  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
    clinfo
    libva-utils
    cudatoolkit

    (writeShellScriptBin "nvidia-run" ''
      #!/bin/sh
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')

    (writeShellScriptBin "gpu-check" ''
      #!/bin/sh
      PASS="✓"
      FAIL="✗"
      WARN="!"
      ok=0
      fail=0

      check() {
        label="$1"
        expected="$2"
        actual="$3"
        if echo "$actual" | grep -qi "$expected"; then
          echo "  $PASS $label"
          ok=$((ok+1))
        else
          echo "  $FAIL $label"
          echo "      got: $actual"
          fail=$((fail+1))
        fi
      }

      echo ""
      echo "=== GPU PRIME OFFLOAD DIAGNOSTIC ==="
      echo ""

      echo "[ 1 ] Default renderer (should be Intel)"
      R=$(glxinfo -B 2>/dev/null | grep "OpenGL renderer")
      check "Intel drives display" "Intel" "$R"

      echo ""
      echo "[ 2 ] NVIDIA offload renderer (should be Quadro)"
      R=$(nvidia-run glxinfo -B 2>/dev/null | grep "OpenGL renderer")
      check "NVIDIA takes over via nvidia-run" "Quadro\|NVIDIA\|P2000" "$R"

      echo ""
      echo "[ 3 ] VAAPI hardware decode (should be iHD / Intel)"
      R=$(vainfo 2>/dev/null | grep "iHD\|i965\|Intel")
      check "VAAPI using Intel driver" "iHD\|Intel\|i965" "$R"

      echo ""
      echo "[ 4 ] NVIDIA power state (should be D3cold when idle)"
      STATE=$(cat /proc/driver/nvidia/gpus/*/information 2>/dev/null | grep "Bus Location\|Video Memory\|Power")
      if [ -z "$STATE" ]; then
        echo "  $WARN nvidia proc entry not found (GPU may be powered off — that is good)"
        echo "      trigger it: nvidia-run glxgears & sleep 2 && cat /proc/driver/nvidia/gpus/*/information"
      else
        echo "  $PASS NVIDIA driver proc entry found:"
        echo "$STATE" | sed 's/^/      /'
      fi

      echo ""
      echo "[ 5 ] Kernel modules loaded"
      for mod in nvidia nvidia_modeset nvidia_uvm nvidia_drm i915; do
        if lsmod | grep -q "^$mod"; then
          echo "  $PASS $mod loaded"
          ok=$((ok+1))
        else
          echo "  $FAIL $mod NOT loaded"
          fail=$((fail+1))
        fi
      done

      echo ""
      echo "[ 6 ] nouveau is blacklisted (should NOT be loaded)"
      if lsmod | grep -q "^nouveau"; then
        echo "  $FAIL nouveau is loaded — conflict risk"
        fail=$((fail+1))
      else
        echo "  $PASS nouveau not loaded"
        ok=$((ok+1))
      fi

      echo ""
      echo "[ 7 ] Intel OpenCL (intel-compute-runtime)"
      R=$(clinfo 2>/dev/null | grep -i "intel\|platform")
      if [ -z "$R" ]; then
        echo "  $WARN clinfo not found — add clinfo to systemPackages"
      else
        check "Intel OpenCL platform present" "Intel" "$R"
      fi

      echo ""
      echo "[ 8 ] Vulkan — default adapter (should be Intel)"
      R=$(vulkaninfo --summary 2>/dev/null | grep "deviceName" | head -1)
      check "Intel is default Vulkan device" "Intel" "$R"

      echo ""
      echo "[ 9 ] Vulkan via nvidia-run (should be NVIDIA)"
      R=$(nvidia-run vulkaninfo --summary 2>/dev/null | grep "deviceName" | head -1)
      check "NVIDIA Vulkan via nvidia-run" "Quadro\|NVIDIA\|P2000" "$R"

      echo ""
      echo "======================================"
      echo "  PASSED: $ok   FAILED: $fail"
      echo "======================================"
      echo ""
    '')
  ];
}
