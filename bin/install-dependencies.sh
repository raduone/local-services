#!/bin/bash

CAGE_VERSION=0.2.4
COMPOSE_VERSION=1.18.0

function install_docker {
  echo "Install docker by following https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/ "
  exit
}

function install_gcloud {
  echo "installing google cloud sdk"

  curl https://sdk.cloud.google.com | bash
}

function install_docker_compose {
  echo "installing docker-commpose $COMPOSE_VERSION"

  sudo curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

function install_cage {
  echo "installing cage $CAGE_VERSION"

  wget https://github.com/faradayio/cage/releases/download/v$CAGE_VERSION/cage-v$CAGE_VERSION-linux.zip
  unzip cage-*.zip
  sudo cp cage /usr/local/bin/
  rm cage-*.zip cage
}

function add_user_to_docker_group {
  echo "Adding ${whoami} to group docker"

  ln -sf /usr/bin/gpasswd workaround_for_stupid_centrify
  sudo ./workaround_for_stupid_centrify -a `whoami` docker
  rm -rf workaround_for_stupid_centrify

  echo
  echo "You need to logout before you can use docker"
  echo
}

if [ "$EUID" -eq 0 ]
then
  echo "Don't run this script as root"
  exit
fi

if ! type docker 2>/dev/null
then
  install_docker
fi

if ! groups | grep docker &>/dev/null
then
  add_user_to_docker_group
fi

if ! type gcloud 2>/dev/null
then
  install_gcloud
fi

if ! type docker-compose 2>/dev/null
then
  install_docker_compose
fi

if ! type cage 2>/dev/null
then
  install_cage
fi


echo
echo "DONE"
echo
