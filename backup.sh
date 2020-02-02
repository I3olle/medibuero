#!/usr/bin/env bash

set -e

notify_of_errors() {
    dunstify -u critical "Backup went wrong"
}

trap "notify_of_errors" ERR

convert() {
    libreoffice --convert-to fods *.ods
    dunstify --icon pallet "Converted sucessfully"
}

git_backup() {
    git commit -am "update at $(date +\\'%Y-%m-%d-%H-%M\\')"
    # git push origin
    # git push gitlab
    dunstify --icon cloud "Updates were committed and pushed"
}

convert
git_backup
dunstify -a backup "Nothing to commit and push"
