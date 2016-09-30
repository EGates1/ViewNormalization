%% RegExpFiles - input regular expression
%% OutputPNG   - Joint Histogram

%%Current issue: getting file names leaves the last file name with an unknown character on the end that makes it not read properly.


function ViewJointHistogram( OutputPNG, RegExpFiles)

%% Load paths.
if ~isdeployed
  addpath('./nifti');
end


%In Terminal
listfiles = ['ls ' RegExpFiles];
disp(listfiles ); 
[sysstatus,sysresult] = system(listfiles ); %last file has a strange character on the end

%% TODO @EGates1 read each of these nifti files 

sysresult= strrep(sysresult,'\n','');   %might not be needed, sysresult already space delimited?
filelist = strsplit(sysresult,' ');

images = cell(1, length(filelist) );
maxdata=0; %maximum intensity accros all images, used to construct histogram bins

for iii =1 :length(filelist)
   disp(['niifile = load_untouch_nii(''',filelist{iii} ,''');']);
   niifile = load_untouch_nii(filelist{iii});
   images{iii} = niifile.img;
   maxdata = max(maxdata, max(niifile.img(:)) );
end

%% TODO @EGates1 build joint histogram

%Histogram datasets
nbins = 100;
bins = linspace(0, maxdata, nbins); %start at 1 so 0 gets its own bin
binned_data = zeros(nbins, length(filelist) );

for iii =1 :length(filelist)
    binned_data(:,iii) = hist(images{iii}(:), bins);
end

%% Plot (bar chart hard to read)
figure(24601);
plot(bins(2:end), binned_data(2:end,:)); %2:end excludes 0 bin, gives correct vertical scale
title('Intensity Histograms');
legend(filelist);

saveas(gcf,OutputPNG); %set to save current figure



