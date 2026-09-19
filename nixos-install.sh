#!/usr/bin/env bash
set -euo pipefail

# NOTE: All pre-packaged apps in minimal iso can be found here
# https://raw.githubusercontent.com/NixOS/nixpkgs/c27cdad491a991b11ed731760aa2ef8db0cb0410/nixos/modules/installer/cd-dvd/installation-cd-base.nix
# https://raw.githubusercontent.com/NixOS/nixpkgs/c27cdad491a991b11ed731760aa2ef8db0cb0410/nixos/modules/profiles/base.nix

HOSTNAME="${HOSTNAME:-workstation}"
USER="${USER:-aristide}"
DEVICE="${DEVICE:-/dev/nvme0n1}"
HOMEPART="${DEVICE}p4"
STATE_FILE="/tmp/nixos-install.state"

# ------------------------------------------------------------------
# Step registry — order matters. Add/remove steps here only.
# ------------------------------------------------------------------
STEPS=(
  preflight
  partition
  verify_home
  format
  mount_all
  hwconfig
  stage_flake
  install
  set_password
  copy_dotfiles
  stow_configs
)

# ------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------
log() { echo ">>> $*"; }

save_state() { echo "$1" > "$STATE_FILE"; }

step_index() {
  local name="$1"
  for i in "${!STEPS[@]}"; do
    [ "${STEPS[$i]}" = "$name" ] && { echo "$i"; return 0; }
  done
  echo "Unknown step: $name" >&2
  exit 1
}

usage() {
  cat <<EOF
Usage: $0 [--start-from=STEP] [--list]

Steps (in order):
$(printf '  - %s\n' "${STEPS[@]}")

Examples:
  $0                          # run everything from the beginning
  $0 --start-from=format      # resume from the "format" step
  $0 --list                   # print the step names and exit
EOF
}

# ------------------------------------------------------------------
# Step implementations
# ------------------------------------------------------------------

step_preflight() {
  log "Recording pre-flight size of ${HOMEPART}..."
  HOME_SIZE_BEFORE=$(lsblk -b -no SIZE "${HOMEPART}")
  echo "$HOME_SIZE_BEFORE" > /tmp/home_size_before
  echo "  -> ${HOMEPART} size: ${HOME_SIZE_BEFORE} bytes"
}

step_partition() {
  log "Repartitioning boot/swap/root via sfdisk (p4 is never referenced below)..."
  sudo sfdisk --delete "$DEVICE" 1
  sudo sfdisk --delete "$DEVICE" 2
  sudo sfdisk --delete "$DEVICE" 3

  sudo sfdisk "$DEVICE" <<EOF
label: gpt
${DEVICE}p1 : size=1G, type=uefi
${DEVICE}p2 : size=5G, type=swap
${DEVICE}p3 : size=230G, type=linux
EOF
}

# This step replaces the manual "boot testdisk, write the table" fix.
# Deleting/recreating partitions 1-3 with sfdisk rewrites the GPT primary
# header and entry array; if the on-disk backup header (at the end of the
# disk) is stale or misaligned, the kernel can lose track of p4 even though
# its entry is technically still there. sgdisk -e relocates/rebuilds that
# backup header to match the current table, which is what testdisk's
# "write" was actually fixing for you by hand.
step_verify_home() {
  log "Verifying ${HOMEPART} was not altered, and repairing GPT if needed..."

  local before
  before=$(cat /tmp/home_size_before)

  log "Re-reading partition table..."
  sudo partprobe "$DEVICE" || true
  sudo udevadm settle

  if [ ! -b "$HOMEPART" ]; then
    log "  -> ${HOMEPART} not visible yet, attempting automatic GPT repair (sgdisk -e)..."
    # The NixOS minimal ISO doesn't ship gptfdisk, but it does have nix,
    # so pull sgdisk on demand rather than requiring it pre-installed.
    sudo sgdisk -e "${DEVICE}"
    sudo partprobe "${DEVICE}" || true
    sudo udevadm settle
  fi

  if [ ! -b "$HOMEPART" ]; then
    log "  -> Still not visible. sgdisk -e only fixes a stale backup GPT header;"
    log "     falling back to testdisk's scripted search+write, same as the manual fix."
    # Likewise, testdisk isn't on the minimal ISO — pull it via nix-shell too.
    # partition_gpt: skip auto-detection: analyze: enter analyse menu:
    # search: deeper signature search for lost partitions: noconfirm,write:
    # commit the recovered table without an interactive prompt.
    sudo testdisk /log /cmd "${DEVICE}" partition_gpt,analyze,search,noconfirm,write
    sudo partprobe "$DEVICE" || true
    sudo udevadm settle
  fi

  if [ ! -b "$HOMEPART" ]; then
    echo "ABORT: ${HOMEPART} still not discoverable after automatic sgdisk/testdisk repair." >&2
    echo "Check ~/testdisk.log, or run testdisk interactively as a last resort." >&2
    exit 1
  fi

  local after
  after=$(lsblk -b -no SIZE "${HOMEPART}")
  if [ "$before" != "$after" ]; then
    echo "ABORT: ${HOMEPART} size changed (${before} -> ${after})." >&2
    echo "Refusing to continue — home partition may have been altered." >&2
    exit 1
  fi
  echo "  -> OK, ${HOMEPART} unchanged and discoverable."
}

step_format() {
  log "Formatting new partitions (p4 is never touched)..."
  sudo mkfs.vfat -F32 "${DEVICE}p1"
  sudo mkswap "${DEVICE}p2"
  sudo mkfs.ext4 "${DEVICE}p3"
}

step_mount_all() {
  log "Mounting everything, including the untouched home partition..."
  sudo mount "${DEVICE}p3" /mnt
  sudo mkdir -p /mnt/boot /mnt/home
  sudo mount "${DEVICE}p1" /mnt/boot
  sudo mount "${HOMEPART}" /mnt/home
  sudo swapon "${DEVICE}p2"
}

step_hwconfig() {
  log "Generating hardware-configuration.nix from mounted filesystems..."
  sudo mkdir -p /tmp/generated-config
  sudo nixos-generate-config --root /mnt --dir /tmp/generated-config
}

step_stage_flake() {
  log "Staging NixOS Flake repository files..."
  sudo mkdir -p /mnt/etc/nixos
  sudo cp -r ./dotfiles/nixos/* /mnt/etc/nixos/

  log "Replacing stale hardware-configuration.nix with freshly generated one..."
  sudo cp /tmp/generated-config/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix
}

step_install() {
  log "Executing Flake system installation..."
  sudo nixos-install \
    --flake "/mnt/etc/nixos#${HOSTNAME}" \
    --no-root-passwd
}

step_set_password() {
  log "Setting a login password for ${USER}..."
  sudo nixos-enter --root /mnt -c "passwd ${USER}"
}

step_copy_dotfiles() {
  log "Copying dotfiles under Projects/..."
  if [ ! -d /mnt/home/"${USER}"/Projects/personal/dotfiles ]; then
    mkdir -p /mnt/home/"${USER}"/Projects/personal
    cp -r ./dotfiles /mnt/home/"${USER}"/Projects/personal
  fi
}

step_stow_configs() {
  log "Stowing configs (best-effort)..."
  stow --dir /mnt/home/"${USER}"/Projects/personal --target /mnt/home/"${USER}"/ &> /dev/null || true
}

# ------------------------------------------------------------------
# Main
# ------------------------------------------------------------------
START_FROM="${STEPS[0]}"

for arg in "$@"; do
  case "$arg" in
    --start-from=*) START_FROM="${arg#--start-from=}" ;;
    --list) usage; exit 0 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $arg" >&2; usage; exit 1 ;;
  esac
done

START_INDEX=$(step_index "$START_FROM")

echo "=========================================="
echo " NixOS Flake Installation (sfdisk-based)  "
echo " Starting from step: ${STEPS[$START_INDEX]} (${START_INDEX}/${#STEPS[@]})"
echo "=========================================="

for i in "${!STEPS[@]}"; do
  if [ "$i" -lt "$START_INDEX" ]; then
    continue
  fi
  step_name="${STEPS[$i]}"
  save_state "$step_name"
  echo "------------------------------------------"
  echo "Step $((i+1))/${#STEPS[@]}: ${step_name}"
  echo "------------------------------------------"
  "step_${step_name}"
done

echo "=========================================="
echo " Done! Remove installation media & reboot."
echo "=========================================="
