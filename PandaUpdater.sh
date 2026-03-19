#! /bin/sh
# encoding: utf-8
# created by AkytharPandaaa

cwd=$(pwd)
start_timestamp=$(date "+%Y%m%d-%H%M%S")
log_file="/var/log/updates_$start_timestamp.log"

sudo touch "$log_file"

if ! [ "$(git fetch --dry-run --verbose 2>&1 | grep -Po "[a-z0-9]+(?=\]\s+main)")" = "aktuell" ]; then

  echo "--- updating repo" | tee -a "$log_file"
  cd "$(echo "$0" | grep -o ".*/")" || exit 1
  git pull >/dev/null

  ./PandaUpdater.sh

  cd "$cwd" || exit 1

else

  if command -v "pacman" >/dev/null; then

    echo "--- update via pacman" | tee -a "$log_file"
    sudo pacman --noconfirm -Syyu | tee -a "$log_file"
    echo "" | tee -a "$log_file"

    unneeded_packages="$(sudo pacman -Qdtq)"
    if not test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via pacman" | tee -a "$log_file"
      sudo pacman -Qdtq | sudo pacman --noconfirm -Rsu - | tee -a "$log_file"
      echo "" | tee -a "$log_file"

      echo "--- cleaning downloaded packages via pacman" | tee -a "$log_file"
      sudo pacman -Qdtq | sudo pacman --noconfirm -Sc - | tee -a "$log_file"
      echo "" | tee -a "$log_file"

    fi

    sudo paccache -rk 2 | tee -a "$log_file"
  fi

  if command -v "yay" >/dev/null; then

    echo "--- update via yay" | tee -a "$log_file"
    yay --sudoloop --noconfirm -Syua --cleanafter | tee -a "$log_file"
    echo "" | tee -a "$log_file"

    unneeded_packages="$(sudo pacman -Qdtq)"
    if ! test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via yay" | tee -a "$log_file"
      yay --sudoloop --noconfirm -Yc | tee -a "$log_file"
      echo "" | tee -a "$log_file"
    fi
  fi

  if command -v "apt" >/dev/null; then

    echo "--- update via APT" | tee -a "$log_file"
    sudo apt update | tee -a "$log_file"
    sudo apt upgrade -y | tee -a "$log_file"
    sudo apt autoremove -y | tee -a "$log_file"
    sudo apt autoclean | tee -a "$log_file"
    echo "" | tee -a "$log_file"

  fi

  if command -v "apk" >/dev/null; then

    echo "--- update via apk"
    apk update | tee -a "$log_file"
    apk upgrade --no-self-upgrade --available --simulate | tee -a "$log_file"
    apk upgrade --available | tee -a "$log_file"
    echo "" | tee -a "$log_file"

  fi

  if command -v "flatpak" >/dev/null; then

    echo "--- update via flatpak" | tee -a "$log_file"
    sudo flatpak remote-ls --updates | tee -a "$log_file"
    sudo flatpak update --assumeyes --noninteractive | tee -a "$log_file"
    echo "" | tee -a "$log_file"

  fi

  cd "$cwd" || exit 1
  echo "--- updating finished ---" | tee -a "$log_file"
  echo "" | tee -a "$log_file"

fi
