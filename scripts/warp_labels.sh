#!/bin/bash

SUBJECTID="${1}_${2}"
SUBJECTBOLDDIR="../data/output/$1/$2/BOLD/"
SUBJECTDTIDIR="../data/output/$1/$2/DTI/"
SUBJECTPCASLDIR="../data/output/$1/$2/PCASL/"
SUBJECTT1DIR="../data/output/$1/$2/"
TEMPLATEDIR="../data/template/"

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${TEMPLATEDIR}/PTBP/Labels/PTBP_T1_AAL.nii.gz \
-r ${SUBJECTT1DIR}${SUBJECTID}_BrainExtractionMask.nii.gz \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTT1DIR}${SUBJECTID}_aal.nii.gz -n MultiLabel -v 1

${ANTSPATH}/ImageMath 3 ${SUBJECTT1DIR}${SUBJECTID}_aal.nii.gz m \
${SUBJECTT1DIR}${SUBJECTID}_aal.nii.gz \
${SUBJECTT1DIR}${SUBJECTID}_BrainExtractionMask.nii.gz

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${TEMPLATEDIR}/PTBP/Labels/PTBP_T1_AAL.nii.gz \
-r ${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_brainmask.nii.gz \
-t [ ${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_0GenericAffine.mat, 1] \
-t ${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_aal.nii.gz -n MultiLabel -v 1

${ANTSPATH}/ImageMath 3 ${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_aal.nii.gz m \
${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_aal.nii.gz \
${SUBJECTBOLDDIR}${SUBJECTID}_BOLD_brainmask.nii.gz

${ANTSPATH}/antsApplyTransforms -d 3 \
-i ${TEMPLATEDIR}/PTBP/Labels/PTBP_T1_AAL.nii.gz \
-r ${SUBJECTDTIDIR}${SUBJECTID}_DTI_brainmask.nii.gz \
-t [ ${SUBJECTDTIDIR}${SUBJECTID}_DTI_0GenericAffine.mat,1 ] \
-t ${SUBJECTDTIDIR}${SUBJECTID}_DTI_1InverseWarp.nii.gz \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
-o ${SUBJECTDTIDIR}${SUBJECTID}_DTI_aal.nii.gz -n MultiLabel -v 1

${ANTSPATH}/ImageMath 3 ${SUBJECTDTIDIR}${SUBJECTID}_DTI_aal.nii.gz m \
${SUBJECTDTIDIR}${SUBJECTID}_DTI_aal.nii.gz \
${SUBJECTDTIDIR}${SUBJECTID}_DTI_brainmask.nii.gz

${ANTSPATH}/ThresholdImage 3 ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_SegmentationWarpedToASL.nii.gz ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_brainmask.nii.gz 1 inf

#${ANTSPATH}/antsApplyTransforms -d 3 \
#-i ${TEMPLATEDIR}/PTBP/Labels/PTBP_T1_AAL.nii.gz \
#-r ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_brainmask.nii.gz \
#-t [ ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_0GenericAffine.mat,1] \
#-t ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_1InverseWarp.nii.gz \
#-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject1GenericAffine.mat \
#-t ${SUBJECTT1DIR}${SUBJECTID}_TemplateToSubject0Warp.nii.gz \
#-o ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_aal.nii.gz -n MultiLabel -v 1

#${ANTSPATH}/ImageMath 3 ${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_aal.nii.gz m \
#${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_aal.nii.gz \
#${SUBJECTPCASLDIR}${SUBJECTID}_PCASL_brainmask.nii.gz
