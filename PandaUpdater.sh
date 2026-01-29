#! /bin/sh
# encoding: utf-8
# created by IndiePandaaaaa

if command -v "pacman" >/dev/null; then
  echo "--- update via pacman"
  sudo pacman --noconfirm --needed -Syyu
  echo ""

  unneeded_packages="$(sudo pacman -Qdtq)"
  if not test -z "$unneeded_packages"; then
    echo "--- removing unneeded packages via pacman"
    sudo pacman -Qdtq | sudo pacman --noconfirm -Rsu -
    echo ""

    echo "--- cleaning downloaded packages via pacman"
    sudo pacman -Qdtq | sudo pacman --noconfirm -Sc -
    echo ""
  fi

  sudo paccache -rk 2
fi

if command -v "yay" >/dev/null; then
  echo "--- update via yay"
  yay --sudoloop --noconfirm --needed -Syua --cleanafter
  echo ""

  unneeded_packages="$(sudo pacman -Qdtq)"
  if ! test -z "$unneeded_packages"; then
    echo "--- removing unneeded packages via yay"
    yay --sudoloop --noconfirm -Ycc
    echo ""
  fi
fi

if command -v "apt" >/dev/null; then
  echo "--- update via APT"
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt autoclean
fi

if command -v "apk" >/dev/null; then
  echo "--- update via apk"
  apk update
  apk upgrade --no-self-upgrade --available --simulate
  apk upgrade --available
fi

if command -v "flatpak" >/dev/null; then
  echo "--- update via flatpak"
  sudo flatpak update --system --assumeyes --noninteractive
  echo ""
fi
