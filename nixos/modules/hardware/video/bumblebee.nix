{ config, pkgs, ... }:

let kernel = config.boot.kernelPackages; in
with pkgs.lib;

{

  options = {
    hardware.bumblebee.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable the bumblebee daemon.
        Only nvidia driver is supported so far.
      '';
    };
  };

  config = mkIf config.hardware.bumblebee.enable {
    boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb"];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch kernel.nvidia_x11 ];

    environment.systemPackages = [ pkgs.bumblebee ];

    systemd.services.bumblebeed = {
      description = "Manages the Optimus video card";
      wantedBy = [ "display-manager.service" ];
      script = "bumblebeed --use-syslog";
      environment = { MODULE_DIR = "${config.system.modulesTree}/lib/modules"; };
      path = [ kernel.bbswitch pkgs.bumblebee ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 60;
      };
    };
  };
}
