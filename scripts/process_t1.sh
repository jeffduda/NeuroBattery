#!/bin/bash
sh  ${ANTSPATH}/antsCorticalThickness.sh -d 3 \
   -a ../data/input/PEDS012/20131101/Anatomy/PEDS012_20131101_mprage_t1.nii.gz \
   -e ../data/template/PTBP/PTBP_T1_Defaced.nii.gz \
   -m ../data/template/PTBP/PTBP_T1_BrainCerebellumProbabilityMask.nii.gz \
   -f ../data/template/PTBP/PTBP_T1_ExtractionMask.nii.gz \
   -p ../data/template/PTBP/Priors/priors%d.nii.gz \
   -t ../data/template/PTBP/PTBP_T1_BrainCerebellum.nii.gz \
   -k 1 \
   -n 3 \
   -w 0.25 \
   -q 1 \
   -o ../data/output/PEDS012/20131101/PEDS012_20131101_
   
