%% RegExpFiles - input regular expression
%% OutputPNG   - Joint Histogram

function ViewJointHistogram( OutputPNG, RegExpFiles)

%% Load paths.
if ~isdeployed
  addpath('./nifti');
end

listfiles = ['ls ' RegExpFiles];
disp(listfiles ); 
[sysstatus,sysresult] = system(listfiles );

%% TODO @EGates1 read each of these nifti files 
%% TODO @EGates1 build joint histogram
sysresult= strrep(sysresult,'\n','');
filelist = strsplit(sysresult,' ');

for iii =1 :length(filelist)
   disp(['niifile = load_untouch_nii(''',filelist{iii} ,''');']);
   %niifile = load_untouch_nii(filelist{iii});
end
