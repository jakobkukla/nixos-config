# vertigo (Hetzner VPS)

## Hetzner Cloud Setup

Use the [Hetzner Console](https://console.hetzner.com/) to setup a new server.
The following is required to continue with this guide.

- An x86_64 machine: This can be changed in the `configuration.nix` file.
- A linux distribution with kexec support.
- An IPv4 address: Otherwise `nixos-anywhere` can't pull the kexec image from GitHub.
- An added SSH key: Needed to connect to the machine.

Obtain the IPv4 address and set

```bash
ip_address="<ip_address>"
```

## NixOS installation

### Setup ramfs deploy directory

We use a ramfs so pregenerated secrets and files never touch the disk.

```bash
host="vertigo"
tmp_dir=$(mktemp -d)
root="${tmp_dir}/${host}"

cleanup() {
  sudo umount ${root}
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT

mkdir -p ${root}
sudo mount -t ramfs ramfs ${root}
# We chown the mountpoint so that we can create and access files without sudo.
sudo chown $USER:$(id -gn) ${root}
```

### Generate ssh host keys

```bash
install -d -m755 ${root}/etc/ssh
ssh-keygen -t ed25519 -f ${root}/etc/ssh/ssh_host_ed25519_key -N "" -C "root@${host}"
```

### Rekey agenix secrets

Add new public host key (ed25519) to `secrets.nix` and rekey.

``` bash
# Add new ed25519 public host key.
wl-copy < ${root}/etc/ssh/ssh_host_ed25519_key.pub
hx secrets/secrets.nix

# Rekey existing secrets.
cd secrets
agenix -r

# Commit and push the changes.
git ...
```

### Install

From the repository root run

```bash
nix run github:nix-community/nixos-anywhere -- \
  --extra-files "${root}" \
  --flake ".#${host}" \
  --target-host root@${ip_address}
```

### Cleanup

Exit the shell or reboot to clean up the secrets. You may be prompted for your
password as it needs to unmount the ramfs.

```bash
exit
```
