NeuroBattery
============

Here we provide a working example that illustrates the use of Advanced Normalization Tools ([ANTs](https://github.com/stnava/ANTs)) to process multiple MR image types for a single subject. We provide and example input data for a single subject for which a battery of 5 different images were acquired in a single scanning session: 

1. T1 (MPRAGE)
2. pseudo continuous arterial spin labeling (PCASL)
3. diffusion weighted/tensor
4. resting state BOLD

Additionally we provide a template and associated labels & priors that we use as an anatomical basis for processing as well as a set of verified output image to ensure that your version is working correctly. The general concept is to use the anatomical information in the T1 images as a spatial frame-of-reference. Accordingly we find a spatial mapping between each subject's T1 image and the T1 template. Later, for additional MR images, we will perform intra subject alignment to the T1 allowing for mapping to template space by composing multiple transforms and retaining the concept of relying on the T1 images for anatomical reference for both intra and inter subject exploration of the data. After aligning the T1 image to the template we generate various images relating to anatomical properties of the brain. 

Getting Started
----------------

0. clone this repository and make sure you have R and its ggplot2 and rmarkdown libraries installed

1. install [ANTs](http://stnava.github.io/ANTs/),  [ANTsR](http://stnava.github.io/ANTsR/) and [pipedream](https://github.com/cookpa/pipedream) as described on their respective pages

2. cd into Neurobattery/scripts/

3. type  bash ./run_test.sh  and then wait for the test to finish.

4. if the test succeeds, then great.  now you can inspect both scripts and results and see how to do this yourself.

Additional information below.

T1 (MPRAGE) image processing
------------------------
A template image along with associated tissue-type priors serves as the reference for a registration-based approach to processing of the T1 subject data. Below are some example illustrations of the included template (`data/template/PTBP/PTBP_T1_Defaced.nii.gz`).

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_coronal.png?raw=true)

An extraction mask of the template will help extract the brain from the input (`data/template/PTBP/PTBP_T1_ExtractionMask.nii.gz`). This is used to limit the area examined for an initial whole head registration between subject and template.

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_mask_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_mask_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_mask_coronal.png?raw=true)

A brain mask of the template is transformed to subject space for brain extration (`data/template/PTBP/PTBP_T1_BrainCerebellumProbabilityMask.nii.gz`)

Tissue priors in the template will help segment the input data. Red=CSF, Green=Cortex, Blue=White matter, and Yellow=Deep gray matter, X=Brain stem, Y=Cerebellum (`data/template/PTBP/Priors/priors%d.nii.gz`)

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_prior_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_prior_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/template_t1_prior_coronal.png?raw=true)

These images, along with subject T1 data are used to generate a number of useful outputs, including:

1. Bias corrected version of input image via N4
2. Brain extraction mask (cerebrum)
3. 6-tissue segmentation (CSF,white matter, cortex, deep gray matter, brainstem, and cerebellum)
4. Cortical thickness
5. Spatial transform to template space (and inverse transform)

In the script directory, `process_t1.sh` provides an example call to `antsCorticalThickness.sh` which is used to achieve the steps listed above. For this to work, the ANTSPATH environment variable must be set to point to ANTs executables and scripts. The full command is:

> sh  ${ANTSPATH}/antsCorticalThickness.sh -d 3 \
> -a ../data/input/PEDS012/20131101/Anatomy/PEDS012_20131101_mprage_t1.nii.gz \
> -e ../data/template/PTBP/PTBP_T1_Defaced.nii.gz \
> -m ../data/template/PTBP/PTBP_T1_BrainCerebellumProbabilityMask.nii.gz \
> -f ../data/template/PTBP/PTBP_T1_ExtractionMask \
> -p ../data/template/PTBP/Priors/priors%d.nii.gz \
> -t ../data/template/PTBP/PTBP_T1_BrainCerebellum.nii.gz \
> -k 1 \
> -n 3 \
> -w 0.25 \
> -o ../data/output/PEDS012/20131101/PEDS012_20131101_

Here are some sample slices from the provided T1 input data (`data/input/PEDS012/20121031/Anatomy/PEDS012_20121031_mprage_t1.nii.gz`) followed by the results provided by `antsCorticalThickness.sh`.

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1_coronal.png?raw=true)

The extracted cerebrum image:

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1brain_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1brain_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1brain_coronal.png?raw=true)

The 4-class segmentation:

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1seg_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1seg_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1seg_coronal.png?raw=true)

The cortical thickness, displayed as a heat-map overlay:

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1thick_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1thick_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1thick_coronal.png?raw=true)

For quality control, we can visualize the mean cortical thickness within brain regions. The values for this subject are represented by the thick black line, while the red and blue lines represent the values for other subjects (blue=male) from the same dataset. 

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/thickness_spider.png?raw=true)


Having processed the T1 image, we want to continue to use this data as our anatomical frame-of-reference. The processing of the additional data will all follow a similar pattern:

1. Initial preprocessing to obtain a derived scalar image with relevant anatomical detail
2. Alignment of the derived scalar to the T1 data
3. Propagation of relevant labels, such as the brain mask, etc.
4. Quantification of modality specific metrics of interest.

The output provided by antsCorticalThickness provides a brain extraction that extract cerebrum only. For inter-modality matching, we have found it useful to obtain a full-brain image, i.e. one that includes the cerebellum and brainstem. This image provides a reference for matching other modalities, such as diffusion weighted imaging, where there is signal throughout the brain, but little to no signal in the skull. A full-brain mask is included with the template (`data/template/T_templateFullBrainMask.nii.gz`). The same process used in `antsCorticalThickness.sh` is used to extract the brain, the only difference is that the cerebrum mask is replaced with the full brain mask.

Full-brain extraction

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1fullbrain_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1fullbrain_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_t1fullbrain_coronal.png?raw=true)

Diffusion weighted image processing
-------------------------------

The following steps are used to process diffusion tensor data. For the registration to T1, the T1 image is resample to 2mm isotropic voxels. Since the DWI is lower resolution than the T1, this provides a sufficient balance between accuracy, processing time, and disk space usage.

1. Motion correction of the diffusion weighted volumes
2. Calculation of the diffusion tensor
3. Calculation of the mean diffusion weighted image (mDWI)
4. Registration and mDWI and the subjects full brain T1

Here are slices from the subjects mDWI in it's original space

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwi_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwi_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwi_coronal.png?raw=true)

The mDWI aligned to T1 and masked to cerebrum only

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwit1_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwit1_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dwit1_coronal.png?raw=true)

The subjects DT image is warped into T1 space and used to calculate a variety of metrics

Fractional Anisotropy

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_fa_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_fa_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_fa_coronal.png?raw=true)

Primary direction of diffusion as overlay on T1

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dec_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dec_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dec_coronal.png?raw=true)

Mean Diffusion

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_md_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_md_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_md_coronal.png?raw=true)

Radial Diffusion

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_rd_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_rd_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_rd_coronal.png?raw=true)

The AAL labels may then be transformed from the template into the subject DTI space for use as targets in fiber tractography, here illustrated as an overlay on the mDWI

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dtiaal_axial.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dtiaal_sagittal.png?raw=true)
![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/input_dtiaal_coronal.png?raw=true)

Whole brain tractography is used to obtain the following set of streamlines

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/fibertracts.png?raw=true)

These streamlines are used along with the AAL labels to generate a graph where edges represent the level of connectivity between two labeled regions. 

![Full C](https://github.com/jeffduda/NeuroBattery/blob/master/figures/graph.png?raw=true)


Diffusion Tensor Reconstruction
--------------------------------
Diffusion tensor values are calculated from the DWI images using the nii2dt.sh script included with Pipedream. This script is essentially a wrapper that uses ANTs for motion correction and diffusion direction correction and Camino to perform the tensor estimation. This occurs in (`process_modalities.sh`) with the following command

> sh ${PIPEDREAMPATH}/nii2dt/nii2dt.sh \
> --dwi ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.nii.gz \
>       ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.nii.gz \
> --bvals ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.bval \
>         ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0019_DTI_1_1x0_30x1000.bval \
> --bvecs ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0013_DTI_1_1x0_30x1000.bvec \
>         ../data/input/PEDS012/20131101/DWI/PEDS012_20131101_0019_DTI_1_1x0_30x1000.bvec \
> --outroot PEDS012_20131101_DTI_ \
> --outdir ../data/input/PEDS012/20131101/DTI

Pseudo continuous arterial spin labeling (PCASL) image processing
----------------------------------

Resting BOLD fMRI processing
----------------------------


Dependencies
-------------
ANTs - https://github.com/stnava/ANTs - 5f9d157cd8afb332c632c6fc35341420c93d031c
Pipedream - https://github.com/cookpa/pipedream - 0125c2ab4dfecabfb7786c43056dc101c1e62af7
Camino - http://git.code.sf.net/p/camino/code - 1b0935692fdc324d1325fcdb073e65fe057980ed
gdcm - http://git.code.sf.net/p/gdcm/gdcm -  7b2f37e5e51ed7cab1fc74438cb00800af85a3db
dcm2nii -  http://www.nitrc.org/frs/shownotes.php?release_id=2291 - 6/2013
java 1.7.0_13
cmake 2.8.12.1

**Whipping up a fury, Dominating flurry**

**We create the Battery**

