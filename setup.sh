#!/usr/bin/env bash

set -e

libreoffice --convert-to fods *.ods
git init
git add .gitignore
git add medibuero.fods
git add backup.sh
git add README.md
