#!/bin/bash

if [ ! -e "${ANTSPATH}/antsRegistration" ]; then
  echo "ANTSPATH envirnment variable needs to points to ANTs exectutable/scripts directory"
  exit 1
fi

if [ ! -e "${ANTSPATH}/antsCorticalThickness.sh" ]; then
  echo "ANTSPATH envirnment variable needs to points to ANTs exectutable/scripts directory"
  exit 1
fi

if [ ! -d "${PIPEDREAMPATH}/config" ]; then
  echo "PIPEDREAMPATH envirnment variable needs to points to Pipedream base directory"
  exit 1
fi

if [ ! -e "${PIPEDREAMPATH}/config/pipedream_config.sh" ]; then
  echo "pipedream_config.h needs to be initialized for dependencies"
  exit 1
fi

source ${PIPEDREAMPATH}/config/pipedream_config.sh

if [ ! -e "${CAMINOPATH}/wdtfit" ]; then
  echo "CAMINOPATH is not set correctly" 
  exit 1
fi

if [ ! -e "${DCM2NIIPATH}/dcm2nii" ]; then
  echo "could not find dcm2nii"
  exit 1
fi

if [ ! -e "${GDCMPATH}/gdcmdump" ]; then
  echo "could not find gdcmdump"
  exit 1;
fi

if [ ! -d ../data/input/PEDS012 ]; then
  curl -o ../data/input/PEDS012_20131101.zip http://files.figshare.com/1701182/PEDS012_20131101.zip
  unzip -d ../data/input/ ../data/input/PEDS012_20131101.zip
fi

if [ ! -d ../data/template/PTBP ]; then
  curl -o ../data/template/PTBP.zip  http://files.figshare.com/1510696/PTBP.zip
  unzip -d ../data/template/ ../data/template/PTBP.zip
fi

./process_t1.sh
./process_modalities.sh
./warp_labels.h PEDS012 20131101
./run_comparison.R PEDS012 20131101


