{lib, ...}: {
  # nixos-rebuild build-vm support
  virtualisation.vmVariant = {
    device.virtual = true;

    # Use the (host) user's ssh key to decrypt agenix secrets. This make it
    # possible to run the VM without root privileges.
    age.identityPaths = lib.mkForce ["/mnt/host-ssh/id_ed25519"];
    virtualisation.sharedDirectories = {
      host_ssh = {
        source = "$HOME/.ssh";
        target = "/mnt/host-ssh";
      };
    };

    virtualisation.qemu.options = [
      "-audio pa,model=hda"
      # Fix hyprland: see https://github.com/hyprwm/Hyprland/issues/1056
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
    ];
  };
}
