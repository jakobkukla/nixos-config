{
  # nixos-rebuild build-vm support
  virtualisation.vmVariant = {
    # FIXME: remove this once https://github.com/nix-community/impermanence/issues/121 is fixed
    boot.initrd.systemd.enable = true;

    # make ssh host keys available in build-vm for agenix to work
    virtualisation = {
      # This is a workaround: /etc/ssh isn't marked anymore as neededForBoot, since
      # it's bind mount is overwritten by the vm support implementation in
      # https://github.com/nix-community/impermanence/pull/83/files
      # TODO: fix this in impermanence?
      fileSystems."/etc/ssh".neededForBoot = true;

      sharedDirectories = {
        etc_ssh = {
          source = "/etc/ssh";
          target = "/persist/etc/ssh";
        };
      };
    };

    # Fix hyprland: see https://github.com/hyprwm/Hyprland/issues/1056
    # and https://github.com/donovanglover/nix-config/blob/10ccd698facdc9306c7b15291ada968b4b9cf8c6/modules/virtualization.nix#L17-L25
    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
    ];
    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
