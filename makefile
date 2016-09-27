# file : Makefile (UNIX)
#
# You can invoke this Makefile using
#  make -f Makefile MATLABROOT=[directory where MATLAB is installed]
#
# If you do not want to specify the MATLABROOT at the gmake command line
# every single time, you can define it by uncommenting the line below
# and assigning the correct root of MATLAB (with no trailing '/') on
# the right hand side.
#
MATLABROOT      := /opt/apps/matlab/2015a/
#

#
# Defaults
#

MEX=$(MATLABROOT)/bin/mex
MCC=$(MATLABROOT)/bin/mcc


# The following are the definitions for each target individually.

ViewJointHistogram: ViewJointHistogram.m
	$(MCC) -d './' -R -nodisplay -R '-logfile,./matlab.log' -S -v -m $^ $(CTF_ARCHIVE) -o $@

tags: 
	ctags -R *

CTF_ARCHIVE=$(addprefix -a ,$(SOURCE_FILES))


SOURCE_FILES  = ./nifti/make_nii.m                                              \
                ./nifti/load_untouch_nii.m                                      \
                ./nifti/save_nii.m                                              

#                ./nifti/load_nii.m                                              \
#                ./nifti/rri_xhair.m                                             \
#                ./nifti/expand_nii_scan.m                                       \
#                ./nifti/save_nii_hdr.m                                          \
#                ./nifti/load_untouch_nii_img.m                                  \
#                ./nifti/load_untouch0_nii_hdr.m                                 \
#                ./nifti/load_nii_ext.m                                          \
#                ./nifti/extra_nii_hdr.m                                         \
#                ./nifti/verify_nii_ext.m                                        \
#                ./nifti/load_nii_hdr.m                                          \
#                ./nifti/pad_nii.m                                               \
#                ./nifti/save_untouch_nii_hdr.m                                  \
#                ./nifti/reslice_nii.m                                           \
#                ./nifti/collapse_nii_scan.m                                     \
#                ./nifti/flip_lr.m                                               \
#                ./nifti/save_untouch_nii.m                                      \
#                ./nifti/rri_orient.m                                            \
#                ./nifti/bresenham_line3d.m                                      \
#                ./nifti/mat_into_hdr.m                                          \
#                ./nifti/load_untouch_nii.m                                      \
#                ./nifti/unxform_nii.m                                           \
#                ./nifti/rri_orient_ui.m                                         \
#                ./nifti/xform_nii.m                                             \
#                ./nifti/view_nii.m                                              \
#                ./nifti/save_nii_ext.m                                          \
#                ./nifti/rri_select_file.m                                       \
#                ./nifti/bipolar.m                                               \
#                ./nifti/save_untouch_slice.m                                    \
#                ./nifti/save_untouch0_nii_hdr.m                                 \
#                ./nifti/clip_nii.m                                              \
#                ./nifti/view_nii_menu.m                                         \
#                ./nifti/rri_zoom_menu.m                                         \
#                ./nifti/save_untouch_header_only.m                              \
#                ./nifti/affine.m                                                \
#                ./nifti/load_untouch_header_only.m                              \
#                ./nifti/load_untouch_nii_hdr.m                                  \
#                ./nifti/make_ana.m                                              \
#                ./nifti/get_nii_frame.m                                         \
#                ./nifti/rri_file_menu.m                                         \
#                ./nifti/load_nii_img.m                                          \

