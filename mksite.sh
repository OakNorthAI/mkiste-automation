#!/bin/bash

shopt -s extglob
set -e
trap 'echo "Command filed with exit code $?."' EXIT

if [ $# -eq 0 ]
  then
          echo "Please provide the project name (and the port number).If no port number is given the default wll be used (8086).  ex: \"./mksite.sh elysium 8086\""
  exit 1
fi

PORT=8086

if [[ -n $2 ]]
  then
    PORT=$2
fi

sudo lsof -ti tcp:$PORT | xargs --no-run-if-empty sudo kill -9

cd /srv/mksite

if [ ! -d "$1" ]
  then
    sudo git clone /srv/repo/$1.git
fi

cd $1

sudo git checkout develop
sudo git pull origin develop

if [[ -d ./serve/docs ]]
  then
   sudo rm -rf ./serve/docs
fi

sudo mkdir -p ./serve/docs
sudo mkdir -p ./serve/docs/images
sudo mkdir -p ./serve/docs/stylesheets

sudo cp ../mkdocs.yml ./serve/
sudo cp !(__*).ipynb ./serve/docs/

sudo mkdir -p ./serve/docs
sudo mkdir -p ./serve/docs/images
sudo mkdir -p ./serve/docs/stylesheets

sudo cp ../mkdocs.yml ./serve/
sudo cp !(__*).ipynb ./serve/docs/

cd ./serve/docs
sudo jupyter nbconvert --to markdown --TemplateExporter.exclude_code_cell=False --TemplateExporter.exclude_input=True *.ipynb
sudo rm *.ipynb

cd ..
sudo cp /srv/tpl/images/logo.svg docs/images/
sudo cp /srv/tpl/images/favicon.ico docs/images/                                                                                                                                                                                                 43,1          88%
sudo cp /srv/tpl/oaknorth.css docs/stylesheets/

sudo mkdocs serve
