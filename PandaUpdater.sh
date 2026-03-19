#! /bin/sh
# encoding: utf-8
# created by AkytharPandaaa

cwd=$(pwd)

if ! [ "$(git fetch --dry-run --verbose 2>&1 | grep -Po "aktuell(?=\]\s+main)")" = "aktuell" ]; then

  echo "--- updating repo" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
  cd "$(echo "$0" | grep -o ".*/")" || exit 1
  git pull >/dev/null

  ./PandaUpdater.sh

  cd "$cwd" || exit 1

else

  if command -v "pacman" >/dev/null; then

    echo "--- update via pacman" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo pacman --noconfirm -Syyu | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

    unneeded_packages="$(sudo pacman -Qdtq)"
    if not test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via pacman" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      sudo pacman -Qdtq | sudo pacman --noconfirm -Rsu - | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

      echo "--- cleaning downloaded packages via pacman" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      sudo pacman -Qdtq | sudo pacman --noconfirm -Sc - | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

    fi

    sudo paccache -rk 2 | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
  fi

  if command -v "yay" >/dev/null; then

    echo "--- update via yay" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    yay --sudoloop --noconfirm -Syua --cleanafter | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

    unneeded_packages="$(sudo pacman -Qdtq)"
    if ! test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via yay" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      yay --sudoloop --noconfirm -Yc | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
      echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    fi
  fi

  if command -v "apt" >/dev/null; then

    echo "--- update via APT" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo apt update | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo apt upgrade -y | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo apt autoremove -y | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo apt autoclean | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

  fi

  if command -v "apk" >/dev/null; then

    echo "--- update via apk"
    apk update | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    apk upgrade --no-self-upgrade --available --simulate | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    apk upgrade --available | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

  fi

  if command -v "flatpak" >/dev/null; then

    echo "--- update via flatpak" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    sudo flatpak update --system --assumeyes --noninteractive | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
    echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

  fi

  cd "$cwd" || exit 1
  echo "--- updating finished ---" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"
  echo "" | tee -a "/var/log/updates_$(date \"+%Y%m%d-%H%M%S\").log"

fi
