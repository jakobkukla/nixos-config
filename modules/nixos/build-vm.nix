{
  # nixos-rebuild build-vm support
  virtualisation.vmVariant = {
    virtualisation = {
      # make ssh host keys available in build-vm for agenix to work
      sharedDirectories = {
        etc_ssh = {
          source = "/etc/ssh";
          target = "/persist/etc/ssh";
        };
      };

      # Fix hyprland: see https://github.com/hyprwm/Hyprland/issues/1056
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=off"
      ];
    };
  };
}
