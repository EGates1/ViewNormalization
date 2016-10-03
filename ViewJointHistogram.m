%% ViewJointHistogram( OutputPNG, RegExpFiles) 
%  RegExpFiles - input regular expression
%  OutputPNG   - joint histogram name

function ViewJointHistogram( OutputPNG, RegExpFiles)

%% Load paths.
if ~isdeployed
  addpath('./nifti');
end

dirInfo=dir(RegExpFiles);
filelist={dirInfo.name};

%% TODO @EGates1 read each of these nifti files 
images = cell(1, length(filelist) );
maxdata=0;

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

%% Plot
figure(24601);
plot(bins(2:end), binned_data(2:end,:)); %2:end excludes 0 bin, gives correct vertical scale
title('Intensity Histograms (excludes 0)');
xlabel('Intensity value')
ylabel('Number of pixels')
legend( strrep(filelist,'_','\_') ); %need to escape underscore characters

saveas(gcf,OutputPNG, 'png'); %set to save current figure
