%% Histogram_ROI( OutputPNG_name, OutputPNG_title, file_name, mask_file, ROI_file, labels)
%  OutputPNG_name - name for histogram to be saved as
%  file_name - image file to be analyzed (full or relative math)
%  mask_file - binary image used to histogram image
%  ROI_file  - Regions to extract mean information
%  labels    - class labels for ROI values, eg GM, WM, CSF, etc listed in
%  numerical order. Example GM=1 WM=3 CSF=4



function Histogram_ROI( OutputPNG_name, OutputPNG_title, file_name, mask_file, ROI_file, labels)
%% Load ROI files + find classes
disp(['ROI_nii = load_untouch_nii(''',ROI_file ,''');']);
ROI_nii = load_untouch_nii(ROI_file);
ROI_data = ROI_nii.img;
classes = unique(ROI_nii.img ); %list sorted class numbers
 classes=classes(classes~=0); %exclude zero as a class
 
ROI_means = zeros(length(classes),1);
 

%% Load image + histogram
disp(['image_nii = load_untouch_nii(''',file_name ,''');']);
image_nii = load_untouch_nii(file_name);
img_data = image_nii.img;

if size(ROI_data)~=size(img_data)
    disp('ROI DATA AND IMAGE DATA ARE NOT THE SAME SIZE')
end

maxdata = double(max(img_data(:)));
mindata = double(min(img_data(:)));

for kkk=classes'
  ROI_means(kkk) = mean(img_data(ROI_data==kkk) ); %fill means table 
end

disp(labels)
disp(ROI_means)
%% Get image mask, use all non-zero pixels if file not found

if exist(mask_file,'file')==2
   disp(['mask_nii = load_untouch_nii(''',mask_file ,''');']);
   mask_nii = load_untouch_nii(mask_file);
   mask_data = mask_nii.img;
else
    mask_data = img_data~=0;
end

%% Histogram datasets, plot and save START HERE
nbins = 100;            %SET NUMBER OF HISTOGRAM BINS
bins = linspace(mindata, maxdata, nbins);
binned_data = hist( img_data(mask_data~=0), bins); %bin data using mask

%binned_data = binned_data/sum(binned_data); %make histogram total to 1
max_bin = max(binned_data);

  figure(24601);
  plot(bins, binned_data); %2:end excludes 0 bin, gives correct vertical scale
  hold on
  for jjj=1:length(classes)
      class_mean = ROI_means(jjj);
      plot([class_mean,class_mean],[0,max_bin],'LineWidth',1)
  end
  hold off
  
  title(['Density Histogram: ' OutputPNG_title] );
  xlabel('Intensity')
  ylabel('Number of values')
  legend(['Histogram',labels])

  saveas(gcf,OutputPNG_name, 'png'); %set to save current figure
end
