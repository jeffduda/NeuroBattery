#!/bin/bash

if [ ! -d ../data/input/PEDS012 ]; then
  curl -o ../data/input/PEDS012_20131101.zip http://files.figshare.com/1701182/PEDS012_20131101.zip
  unzip -d ../data/input/ ../data/input/PEDS012_20131101.zip
fi

if [ ! -d ../data/templates/PTBP ]; then
  curl -o ../data/template/PTBP.zip  http://files.figshare.com/1510696/PTBP.zip
  unzip -d ../data/template/ ../data/template/PTBP.zip
fi

./process_t1.sh
./process_modalities.sh
./run_comparison.R PEDS012 20131101


