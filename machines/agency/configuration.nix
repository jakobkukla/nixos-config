{...}: {
  device = {
    role = "workstation";

    hardware = {
      battery = true;
      bluetooth = true;
      touchpad = true;
      internalDisplay = true;
      wifi = true;
    };
  };

  networking.hostName = "agency";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
