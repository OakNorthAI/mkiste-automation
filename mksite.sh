#!/bin/bash

shopt -s extglob
set -e
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
  exit 1
fi

PID=$(ps aux | grep '/opt/tljh/user/bin/python3.6 /opt/tljh/user/bin/mkdocs' | awk '{print $2}')

if [ ! -z "$PID" ]
  then
    sudo kill $PID
fi

cd /srv/mksite

if [ ! -d "$1" ]
  then
    sudo git clone /srv/repo/$1.git
fi
                                                                                                                                                                                                 1,1           Top
cd $1

sudo git checkout develop
sudo git pull origin develop

if [ -d ./serve/docs ]; then
   sudo rm -r ./serve/docs
fi

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
