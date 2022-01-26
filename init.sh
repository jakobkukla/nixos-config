#!/usr/bin/env bash

MACHINE=`hostname`
if [[ ! -z "$1" ]]; then
	MACHINE=$1
fi

if [[ ! -e "machines/$MACHINE/configuration.nix" ]] || [[ ! -e "machines/$MACHINE/hardware-configuration.nix" ]]; then
	echo "missing $MACHINE.nix or $MACHINE-hardware.nix" >&2
	exit 1
fi

ln -sf $PWD/machines/$MACHINE/configuration.nix /etc/nixos/configuration.nix
ln -sf $PWD/machines/$MACHINE/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
