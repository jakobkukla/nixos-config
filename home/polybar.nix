{ pkgs, ... }:

### FIXME bluetooth script

{
  home-manager.users.jakob = {
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {pulseSupport = true;};
      script = ''
        polybar topbar &
      '';
      extraConfig = ''
[colors]
background = ''${xrdb:color0:#222}
background-alt = ''${xrdb:color0:#222}
foreground = ''${xrdb:color7:#222}
foreground-alt = ''${xrdb:color7:#222}
primary = ''${xrdb:color1:#222}
secondary = ''${xrdb:color2:#222}
alert = ''${xrdb:color3:#222}

[bar/topbar]
;monitor = ''${env:MONITOR:HDMI-1}
width = 100%
height = 55
;offset-x = 1%
;offset-y = 1%
;radius = 6.0
fixed-center = true
dpi = 192

background = ''${colors.background}
foreground = ''${colors.foreground}

line-size = 4

padding-left = 0
padding-right = 2

margin-top = 0
margin-bottom = 0

module-margin-left = 1
module-margin-right = 2

font-0 = SourceCodePro:pixelsize=10;1
font-1 = Font Awesome 6 Brands:style=regular:size=10
font-2 = Font Awesome 6 Free:style=regular:size=10
font-3 = Font Awesome 6 Free:style=solid:size=10

modules-left = bspwm
modules-center = date
modules-right = pulseaudio wlan eth system-bluetooth-bluetoothctl backlight battery

tray-position = right
tray-padding = 2
;tray-background = #0063ff

wm-restack = bspwm

;override-redirect = true

;scroll-up = bspwm-desknext
;scroll-down = bspwm-deskprev

;scroll-up = i3wm-wsnext
;scroll-down = i3wm-wsprev

cursor-click = pointer
cursor-scroll = ns-resize

[module/backlight]
type = internal/backlight
card = intel_backlight
enable-scroll = true

format = <label> 

[module/bspwm]
type = internal/bspwm

label-focused = %index%
label-focused-background = ''${colors.background-alt}
label-focused-underline= ''${colors.primary}
label-focused-padding = 2

label-occupied = %index%
label-occupied-padding = 2

label-urgent = %index%!
label-urgent-background = ''${colors.alert}
label-urgent-padding = 2

label-empty =
label-empty-foreground = ''${colors.foreground-alt}
label-empty-padding = 2

; Separator in between workspaces
; label-separator = |

[module/wlan]
type = internal/network
interface = wlp0s20f3
interval = 3.0

format-connected = <label-connected> 
label-connected = %essid%

format-disconnected =
;format-disconnected = <label-disconnected>
;format-disconnected-underline = ''${self.format-connected-underline}
;label-disconnected = %ifname% disconnected
;label-disconnected-foreground = ''${colors.foreground-alt}

[module/eth]
type = internal/network
;interface = net0
interval = 3.0

format-connected = <label-connected> 
format-connected-foreground = ''${colors.foreground-alt}
label-connected = %local_ip%

format-disconnected =
;format-disconnected = <label-disconnected>
;format-disconnected-underline = ''${self.format-connected-underline}
;label-disconnected = %ifname% disconnected
;label-disconnected-foreground = ''${colors.foreground-alt}

[module/date]
type = internal/date
interval = 5

date = "%d.%m.%Y  |"
date-alt = "%d.%m.%Y  |"

time = " %H:%M"
time-alt = " %H:%M:%S"

label = %date% %time%

[module/pulseaudio]
type = internal/pulseaudio

;format-volume = <label-volume> <bar-volume>
format-volume = <label-volume> <ramp-volume>
label-volume = %percentage%%
label-volume-foreground = ''${root.foreground}

ramp-volume-0 = 
ramp-volume-1 = 
ramp-volume-2 = 
label-muted = muted 

click-right = pavucontrol

bar-volume-width = 10
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-indicator-font = 2
bar-volume-fill = ─
bar-volume-fill-font = 2
bar-volume-empty = ─
bar-volume-empty-font = 2
bar-volume-empty-foreground = ''${colors.foreground-alt}

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC0
full-at = 98

format-charging = <label-charging> <animation-charging>
format-discharging = <label-discharging> <ramp-capacity>

format-full-suffix = " "
format-full-suffix-foreground = ''${colors.foreground-alt}

ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-foreground = ''${colors.foreground-alt}

animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-foreground = ''${colors.foreground-alt}
animation-charging-framerate = 600

[module/powermenu]
type = custom/menu

expand-right = true

format-spacing = 1

label-open = 
label-open-foreground = ''${colors.secondary}
label-close =  cancel
label-close-foreground = ''${colors.secondary}
label-separator = |
label-separator-foreground = ''${colors.foreground-alt}

menu-0-0 = reboot
menu-0-0-exec = menu-open-1
menu-0-1 = power off
menu-0-1-exec = menu-open-2

menu-1-0 = cancel
menu-1-0-exec = menu-open-0
menu-1-1 = reboot
menu-1-1-exec = sudo reboot

menu-2-0 = power off
menu-2-0-exec = sudo poweroff
menu-2-1 = cancel
menu-2-1-exec = menu-open-0

;[module/system-bluetooth-bluetoothctl]
;type = custom/script
;exec = ~/.bin/polybar/system-bluetooth-bluetoothctl.sh
;tail = true
;click-left = ~/.bin/polybar/system-bluetooth-bluetoothctl.sh --toggle &

;;label = 

[settings]
screenchange-reload = true
;compositing-background = xor
;compositing-background = screen
;compositing-foreground = source
;compositing-border = over
;pseudo-transparency = false

[global/wm]
margin-top = 5
margin-bottom = 5

; vim:ft=dosini
      '';
    };
  };
}
