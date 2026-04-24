#! /bin/sh
# encoding: utf-8
# created by AkytharPandaaa

cwd=$(pwd)
start_timestamp=$(date "+%Y%m%d-%H%M%S")
log_file="/var/log/updates_$start_timestamp.log"

sudo touch "$log_file"

# check for macos
if [ "$(uname)" = "Darwin" ]; then

  # check if ggrep is available
  if ! command -v "ggrep" >/dev/null; then
    echo "install 'grep' with 'brew install grep'"
    exit 1
  fi

  # check for state on macos
  git_state="$(git fetch --dry-run --verbose 2>&1 | ggrep -Po "[a-z0-9 ]+(?=\]\s+main)")"

  # fix for language issues
  if [ "$git_state" = "up to date" ]; then
    git_state="aktuell"
  fi

else

  # check for state on linux
  git_state="$(git fetch --dry-run --verbose 2>&1 | grep -Po "[a-z0-9]+(?=\]\s+main)")"

fi

echo "$git_state"

if ! [ "$git_state" = "aktuell" ]; then

  echo "--- updating repo" | sudo tee -a "$log_file"
  cd "$(echo "$0" | grep -o ".*/")" || exit 1
  git pull >/dev/null

  ./PandaUpdater.sh

  cd "$cwd" || exit 1

else

  if command -v "pacman" >/dev/null; then

    echo "--- update via pacman" | sudo tee -a "$log_file"
    sudo pacman -Syy
    pacman -Qu | sudo tee -a "$log_file"
    sudo pacman --noconfirm -Syyu
    echo "" | sudo tee -a "$log_file"

    unneeded_packages="$(sudo pacman -Qdtq)"
    if not test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via pacman" | sudo tee -a "$log_file"
      echo "$unneeded_packages" | sudo tee -a "$log_file"
      echo "$unneeded_packages" | sudo pacman --noconfirm -Rsu -
      echo "" | sudo tee -a "$log_file"

      echo "--- cleaning downloaded packages via pacman" | sudo tee -a "$log_file"
      sudo pacman -Qdtq | sudo pacman --noconfirm -Sc -
      echo "" | sudo tee -a "$log_file"
    fi

    echo "--- pruning cached packages via paccache" | sudo tee -a "$log_file"
    sudo paccache -k 2 --dryrun | sudo tee -a "$log_file"
    sudo paccache -rk 2
  fi

  if command -v "yay" >/dev/null; then

    echo "--- update via yay" | sudo tee -a "$log_file"
    yay --sudoloop -Syya
    yay --sudoloop -Qua | sudo tee -a "$log_file"
    yay --sudoloop --noconfirm -Syua --cleanafter
    echo "" | sudo tee -a "$log_file"

    unneeded_packages="$(yay -Qdtqa)"
    if ! test -z "$unneeded_packages"; then
      echo "--- removing unneeded packages via yay" | sudo tee -a "$log_file"
      echo "$unneeded_packages" | sudo tee -a "$log_file"
      yay --sudoloop --noconfirm -Yc
      echo "" | sudo tee -a "$log_file"
    fi
  fi

  if command -v "apt" >/dev/null; then

    echo "--- update via APT" | sudo tee -a "$log_file"
    sudo apt-get update | sudo tee -a "$log_file"
    sudo apt-get upgrade -y | sudo tee -a "$log_file"
    sudo apt-get autoremove -y | sudo tee -a "$log_file"
    sudo apt-get autoclean | sudo tee -a "$log_file"
    echo "" | sudo tee -a "$log_file"

  fi

  if command -v "apk" >/dev/null; then

    echo "--- update via apk"
    apk update | sudo tee -a "$log_file"
    apk upgrade --no-self-upgrade --available --simulate | sudo tee -a "$log_file"
    apk upgrade --available | sudo tee -a "$log_file"
    echo "" | sudo tee -a "$log_file"

  fi

  if command -v "flatpak" >/dev/null; then

    echo "--- update via flatpak" | sudo tee -a "$log_file"
    sudo flatpak remote-ls --updates | sudo tee -a "$log_file"
    sudo flatpak update --assumeyes --noninteractive
    echo "" | sudo tee -a "$log_file"

  fi

  if command -v "brew" >/dev/null; then

    echo "--- update via Homebrew"
    brew update
    brew upgrade
    echo ""

    echo "--- removing unneeded packages via Homebrew"
    brew autoremove
    brew cleanup
    echo ""
  fi

  cd "$cwd" || exit 1
  echo "--- updating finished ---" | sudo tee -a "$log_file"
  echo "" | sudo tee -a "$log_file"

fi
