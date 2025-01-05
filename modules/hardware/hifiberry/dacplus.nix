{
  lib,
  config,
  ...
}: let
  cfg = config.hardware.hifiberry.dacplus;
in {
  options.hardware.hifiberry.dacplus = with lib; {
    enable = mkEnableOption "HiFiBerry Dac+ hardware support";
  };

  config = lib.mkIf cfg.enable {
    # FIXME: these options are rpi4 specific. make this model agnostic.
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

    hardware.deviceTree.enable = true;
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";

    hardware.deviceTree = {
      overlays = [
        # Equivalent to: https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/hifiberry-dacplus-overlay.dts
        # but compatible changed from bcm2835 to bcm2711
        {
          name = "hifiberry-dacplus";
          dtsText = ''
            // Definitions for HiFiBerry DAC+
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target-path = "/";
                __overlay__ {
                  dacpro_osc: dacpro_osc {
                    compatible = "hifiberry,dacpro-clk";
                    #clock-cells = <0>;
                  };
                };
              };

              fragment@1 {
                target = <&i2s>;
                __overlay__ {
                  status = "okay";
                };
              };

              fragment@2 {
                target = <&i2c1>;
                __overlay__ {
                  #address-cells = <1>;
                  #size-cells = <0>;
                  status = "okay";

                  pcm5122@4d {
                    #sound-dai-cells = <0>;
                    compatible = "ti,pcm5122";
                    reg = <0x4d>;
                    clocks = <&dacpro_osc>;
                    AVDD-supply = <&vdd_3v3_reg>;
                    DVDD-supply = <&vdd_3v3_reg>;
                    CPVDD-supply = <&vdd_3v3_reg>;
                    status = "okay";
                  };
                  hpamp: hpamp@60 {
                    compatible = "ti,tpa6130a2";
                    reg = <0x60>;
                    status = "disabled";
                  };
                };
              };

              fragment@3 {
                target = <&sound>;
                hifiberry_dacplus: __overlay__ {
                  compatible = "hifiberry,hifiberry-dacplus";
                  i2s-controller = <&i2s>;
                  status = "okay";
                };
              };

              __overrides__ {
                24db_digital_gain =
                  <&hifiberry_dacplus>,"hifiberry,24db_digital_gain?";
                slave = <&hifiberry_dacplus>,"hifiberry-dacplus,slave?";
                leds_off = <&hifiberry_dacplus>,"hifiberry-dacplus,leds_off?";
              };
            };
          '';
        }
      ];
    };
  };
}
