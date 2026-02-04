#!/usr/bin/env bash
set -Eeuo pipefail
set -o errtrace

# ================== USER ============================
user=${SUDO_USER:-$USER}
user_home=$(getent passwd "$user" | cut -d: -f6)

# ================== LOG FILE ========================
logfile="$user_home/.var/logs/arch_nvidia_gaming.log"
mkdir -p "$(dirname "$logfile")"
touch "$logfile"

# Log script output normally (INFO/OK/WARN still visible)
exec > >(tee -a "$logfile") 2>&1

# ================== COLORS ==========================
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
NC=$'\033[0m'

trap 'echo -e "\n${RED}[ERROR] Failed on line $LINENO${NC}"' ERR

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

info "Logs stored at $logfile"

# ================== SUDO KEEPALIVE ==================
sudo -v
( while true; do sudo -n true; sleep 60; done ) &
KEEPALIVE_PID=$!
trap 'kill $KEEPALIVE_PID 2>/dev/null || true' EXIT

# ================== HELPERS =========================
FAILED_PKGS=()

# stdout → logfile, stderr → terminal
run_logged() {
    "$@" >>"$logfile"
}

pkg_installed() {
    pacman -Qi "$1" &>/dev/null
}

install_pkgs() {
    for pkg in "$@"; do
        if pkg_installed "$pkg"; then
            success "$pkg already installed"
        else
            info "Installing $pkg"
            if ! run_logged sudo pacman -S --needed --noconfirm "$pkg"; then
                warn "Failed to install $pkg"
                FAILED_PKGS+=("$pkg")
            fi
        fi
    done
}

# ================== GPU DETECTION ===================
command -v lspci >/dev/null || install_pkgs pciutils

if ! lspci | grep -iq nvidia; then
    warn "No NVIDIA GPU detected — exiting."
    exit 0
fi

success "NVIDIA GPU detected"

# ================== MULTILIB ========================
pacman_conf="/etc/pacman.conf"

if ! grep -qE '^\[multilib\]' "$pacman_conf"; then
    info "Enabling multilib repository"
    sudo sed -i \
        -e '/^\s*#\s*\[multilib\]/,/^\s*#\s*Include/ s/^\s*#\s*//' \
        "$pacman_conf"
    run_logged sudo pacman -Syu --noconfirm
    success "multilib enabled"
else
    success "multilib already enabled"
fi

# ================== KERNEL ==========================
CURRENT_KERNEL=$(pacman -Qoq /usr/lib/modules/$(uname -r) | head -n1)

if [[ "$CURRENT_KERNEL" != "linux-zen" ]]; then
    info "Installing linux-zen kernel"
    install_pkgs linux-zen linux-zen-headers
else
    success "linux-zen already running"
fi

# ================== NVIDIA CONFIG ===================
info "Configuring NVIDIA module options"

sudo mkdir -p /etc/modprobe.d
sudo tee /etc/modprobe.d/nvidia.conf >/dev/null <<EOF
options nvidia NVreg_PreserveVideoMemoryAllocations=1
options nvidia NVreg_TemporaryFilePath=/var/tmp
EOF

success "NVIDIA modprobe configuration written"

# ================== SYSCTL TWEAKS ===================
SYSCTL_FILE="/etc/sysctl.d/99-laptop.conf"

info "Applying laptop-friendly sysctl tweaks"

declare -A SYSCTL_TWEAKS=(
    ["vm.swappiness"]="10"
    ["vm.vfs_cache_pressure"]="50"
    ["fs.inotify.max_user_watches"]="524288"
)

sudo touch "$SYSCTL_FILE"

for key in "${!SYSCTL_TWEAKS[@]}"; do
    value="${SYSCTL_TWEAKS[$key]}"
    if grep -qE "^\s*$key\s*=" "$SYSCTL_FILE"; then
        success "$key already set"
    else
        info "Setting $key = $value"
        echo "$key = $value" | sudo tee -a "$SYSCTL_FILE" >/dev/null
    fi
done

run_logged sudo sysctl --system
success "sysctl tweaks applied"

# ================== NVIDIA DRIVERS ==================
info "Installing NVIDIA drivers"

install_pkgs \
    dkms \
    nvidia-open-dkms \
    nvidia-utils \
    nvidia-settings \
    nvidia-prime

# ================== NVIDIA POWER ====================
info "Setting up NVIDIA power management (laptop)"

install_pkgs nvidia-powerd

if systemctl list-unit-files | grep -q "^nvidia-powerd.service"; then
    sudo systemctl enable --now nvidia-powerd.service
    success "nvidia-powerd service enabled"
else
    warn "nvidia-powerd service not available on this GPU"
fi

# ================== GAMING STACK ====================
info "Installing gaming stack"

install_pkgs \
    steam \
    wine-staging \
    wine-mono \
    winetricks \
    gamemode \
    mangohud \
    vulkan-icd-loader \
    vulkan-tools \
    flatpak

# ================== FLATPAK =========================
if command -v flatpak >/dev/null; then
    info "Configuring Flatpak"
    run_logged flatpak remote-add --user --if-not-exists flathub \
        https://flathub.org/repo/flathub.flatpakrepo

    run_logged flatpak install --user -y --noninteractive \
        net.davidotek.pupgui2 \
        com.heroicgameslauncher.hgl \
        com.github.tchx84.Flatseal
fi

# ================== VERIFICATION ====================
info "Verifying setup"

uname -r
run_logged vulkaninfo | head -n 15 || warn "Vulkan check failed"

# ================== NVIDIA DRM ======================
if [[ -f /sys/module/nvidia_drm/parameters/modeset ]]; then
    if [[ "$(cat /sys/module/nvidia_drm/parameters/modeset)" == "Y" ]]; then
        success "nvidia_drm.modeset enabled"
    else
        warn "nvidia_drm.modeset not enabled (bootloader config needed)"
    fi
fi

# ================== SUMMARY =========================
if (( ${#FAILED_PKGS[@]} == 0 )); then
    success "All packages installed successfully"
else
    warn "Failed packages:"
    printf '  - %s\n' "${FAILED_PKGS[@]}"
fi

success "Arch NVIDIA gaming setup complete"
echo -e "${GREEN}Reboot required to finish setup.${NC}"
echo -e "${BLUE}After reboot:${NC}"
echo "• Enable Proton in Steam"
echo "• Install GE-Proton via ProtonUp-Qt"
echo "• Launch games with: prime-run %command%"
echo "• Enjoy Arch Linux gaming 🎮"
