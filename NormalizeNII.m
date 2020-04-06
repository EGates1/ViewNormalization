%OutName    - name for output scaled nifti file
%File Path  - path to nifti dataset to transform
%Math Path  - path to corresponding classification mask to transform data
%zero_class - class in mask to be mapped to mean 0 (numeric value)
%one_class  - class in matk mapped to mean 1 (numeric value)
%
%Inputs a nifti file with a classification mask and linearly transforms the
%data to 0,1 based on two specified classes. Outputs a .nii file with the
%same header as the original file and the image replaced by the scaled
%image

function  NormalizeNII(OutName, FilePath, MaskPath, zero_class, one_class )

if ~isdeployed
  addpath('./nifti');
end

%% Load files
   disp('niifile = load_untouch_nii(FilePath);');
   niifile = load_untouch_nii(FilePath);
   
   disp('niifile = load_untouch_nii(FilePath);');
   niimaskfile = load_untouch_nii(MaskPath);
   
   
%% Data

zero_data = niifile.img(niimaskfile.img==zero_class);
zero_mean = sum(zero_data)/length(zero_data); %faster than mean function 

one_data = niifile.img(niimaskfile.img==one_class);
one_mean = sum(one_data)/length(one_data); %faster than mean function 

if one_mean < zero_mean
    disp('Image inversion: darker class set to lighter intensity')
end

scaled_image = (niifile.img-zero_mean)/ (one_mean-zero_mean);
scaled_nii = niifile;   %use same header etc, rewrite data
scaled_nii.img = scaled_image;

save_untouch_nii(scaled_nii,OutName);



end

