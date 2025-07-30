#!/usr/bin/env bash

# List of dependencies for dnf/dnf5 and apt
yum_dependencies="hadolint helm trivy crun crun-wasm ShellCheck ripgrep fzf stow neovim luarocks fd-find python3 python3-pip"
apt_dependencies="crun shellcheck ripgrep fzf stow neovim luarocks fd python3 python3-pip" # kubeadm hadolint helm trivy - not availble with default repos
brew_dependencies="shellcheck ripgrep fzf stow neovim luarocks fd"
# Function to check if a package is installed for dnf/dnf5 (using rpm)
function is_rpm_installed() {
	rpm -q "$1" &>/dev/null
}

# Function to check if a package is installed for apt (using dpkg)
function is_dpkg_installed() {
	dpkg -l "$1" &>/dev/null
}

# Install dependencies using dnf5, dnf, or apt
if command -v dnf5 &>/dev/null; then
	echo "dnf5 found, checking and installing missing dependencies..."
	for package in ${yum_dependencies}; do
		if ! is_rpm_installed "${package}"; then
			echo "Installing ${package}..."
			dnf5 install -y "${package}"
		fi
	done
elif command -v dnf &>/dev/null; then
	echo "dnf found, checking and installing missing dependencies..."
	for package in ${yum_dependencies}; do
		if ! is_rpm_installed "${package}"; then
			echo "Installing ${package}..."
			dnf install -y "${package}"
		fi
	done
elif command -v apt &>/dev/null; then
	echo "apt found, checking and installing missing dependencies..."
	sudo apt update
	for package in ${apt_dependencies}; do
		if ! is_dpkg_installed "${package}"; then
			echo "Installing ${package}..."
			sudo apt install -y "${package}"
		fi
	done
elif command -v brew &>/dev/null; then
	echo "brew found, checking and installing missing dependencies..."
	for package in ${brew_dependencies}; do
		if ! is_dpkg_installed "${package}"; then
			echo "Installing ${package}..."
			sudo apt install -y "${package}"
		fi
	done
else
	echo "No supported package manager found."
	exit 1
fi
if command -v aqua &>/dev/null; then
	echo "aquaproj/aqua found"
	aqua i
else
	AQUA_VERSION=$(curl -s "https://api.github.com/repos/aquaproj/aqua/tags" | jq -r '.[0].name')
	wget https://github.com/aquaproj/aqua/releases/download/${AQUA_VERSION}/aqua_linux_amd64.tar.gz -o
fi
