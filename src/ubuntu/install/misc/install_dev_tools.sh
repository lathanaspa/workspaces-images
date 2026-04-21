#!/usr/bin/env bash
set -ex

if [ "$DISTRO" = centos ]; then
  yum install -y build-essential
else
  apt-get update
  apt-get install -y build-essential
fi