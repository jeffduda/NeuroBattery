# Convert DWI to DTI

if [ ! -d "../data/input/DTI" ]; then
  sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh --dwi ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.nii.gz   ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.nii.gz --bvals ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0019_DTI_1_1x0_30x1000.bval ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0019_DTI_1_1x0_30x1000.bval --bvecs ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.bvec ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0019_DTI_1_1x0_30x1000.bvec --outroot PEDS012_20131101_DTI_ --outdir ../data/input/PEDS012/20131101/DTI
else
  echo "DTI has already been reconstructed, skipping this step. Delete NeuroBattary/data/input/PEDS012/2013110/DTI to rerun the reconstruction"
fi

${ANTSPATH}/antsNeuroimagingBattery -input-directory ../data/input/PEDS012/20131101/ --output-directory ../data/output/PEDS012/20131101/ --output-name PEDS012_20131101_ --anatomical ../data/output/PEDS012/20131101/PEDS012_20131101_BrainExtractionBrain.nii.gz --anatomical-mask ../data/output/PEDS012/20131101/PEDS012_20131101_BrainExtractionMask.nii.gz --template ../data/template/PTBP/PTBP_T1_Defaced.nii.gz --rsbold-flag BOLD/bold_fc_1.nii.gz/BOLD_ --pcasl-flag PCASL/pcasl_1.nii.gz/PCASL_ --dti-flag DTI/dt.nii.gz/DTI_ --template-transform-name PEDS012_20131101_SubjectToTemplate
