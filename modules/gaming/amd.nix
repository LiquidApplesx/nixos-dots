{ config, pkgs, lib, ... }:

{
  # AMD CPU optimizations
  boot = {
    # Enable AMD microcode updates
    kernelModules = [ "kvm-amd" ];
    initrd.kernelModules = [ "amdgpu" ];

    # Use latest kernel for best AMD support
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel parameters for better performance
    kernelParams = [
      # Enable AMD CPU features
      "amd_pstate=active"
      
      # Better power management
      "initcall_blacklist=acpi_cpufreq_init"
      
      # CPU and GPU optimizations
      "preempt=voluntary"
      "clearcpuid=304"
    ];
  };

  # Hardware acceleration and OpenGL
  hardware = {
    # OpenGL configuration
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;  # Needed for 32-bit games
      
      # Latest Mesa drivers
      extraPackages = with pkgs; [
        rocm-opencl-icd        # OpenCL support
        rocm-opencl-runtime    # OpenCL runtime
        amdvlk                 # Vulkan support
      ];
      
      # 32-bit support for Steam and Wine games
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        amdvlk
      ];

      # Enable Vulkan
      setLdLibraryPath = true;
    };
    
    # CPU optimizations
    cpu.amd.updateMicrocode = true;
  };

  # Enable ACO compiler for faster shader compilation
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
  };

  # Include essential packages for AMD
  environment.systemPackages = with pkgs; [
    vulkan-tools      # Vulkan utilities
    glxinfo           # For checking OpenGL status
    radeontop         # Monitor GPU usage
    corectrl          # AMD GPU/CPU control app (similar to Ryzen Master)
    lm_sensors        # Hardware monitoring
    pciutils          # PCI utilities for hardware info
  ];
  
  # For CoreCtrl to work properly
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
  '';
  
  # CoreCtrl rules
  services.udev.extraRules = ''
    # CoreCtrl
    KERNEL=="card*", SUBSYSTEM=="drm", DRIVERS=="amdgpu", TAG+="uaccess"
    KERNEL=="hwmon*", SUBSYSTEM=="hwmon", TAG+="uaccess"
  '';

  # Power management
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  
  # Make some services explicit
  services.hardware.openrgb.enable = true;  # RGB control if needed
}
