%% ViewJointHistogramCSV( OutputPNG, CSV_path, mask_column_number, image_column_numbers)
% CSV_path - Needs to be a full file path so that xlsread(CSV_path) works properly
% mask_column_number - each image here should have values 1,2,... to designate class numbers
% image_column_number - images to construct histograms from, for now only takes ONE column input.

%OutputPNG is a filename that will be used to start each saved histogram.
   %Include file path or corrent matlab path will be used.


function ViewJointHistogramCSV( OutputPNG, CSV_path, mask_column_number, image_column_number)

%if ~isdeployed
%  addpath('./nifti');
%end

%% Load data files
[~,~,raw] = xlsread(CSV_path);

if ~exist(raw{1,mask_column_number}, 'file')
    disp('Removing Headers')
    raw = raw(2:end,:);
end


filelist     =  raw(:, image_column_number);
maskfilelist =  raw(:, mask_column_number);

%% Store image and mask data

images = cell(1, length(filelist) );
masks  = cell(1, length(maskfilelist) );
maxdata=0; %maximum intensity accros all images, used to construct histogram bins
mindata=0;
classlist = []; %construct list of all classes across all files

if length(filelist) ~= length(maskfilelist)
    disp('NUMBER OF MASKS NOT EQUAL TO NUMBER OF IMAGES')
end

for iii=1 :length(filelist)
   disp(['niifile = load_untouch_nii(''',filelist{iii} ,''');']);
   niifile = load_untouch_nii(filelist{iii});
   images{iii} = niifile.img;
   maxdata = max(maxdata, max(niifile.img(:)) );
   mindata = min(mindata, min(niifile.img(:)) );
end

for jjj=1 :length(maskfilelist)
   disp(['niifile = load_untouch_nii(''',maskfilelist{jjj} ,''');']);
   niifile = load_untouch_nii(maskfilelist{jjj});
   masks{jjj} = niifile.img;
   classes = unique(niifile.img ); %list sorted class numbers
   classlist = union(classlist, classes); %add classes to class list
end


%% Histogram datasets, plot and save
nbins = 100;            %SET NUMBER OF HISTOGRAM BINS
bins = linspace(mindata, maxdata, nbins); %start at 1 so 0 gets its own bin


for kkk= classlist'
  binned_data = zeros(nbins, length(filelist) );

    for lll =1 :length(filelist)
      class_data = images{lll}(masks{lll}==kkk); %get only data from that class
      binned_data(:,lll) = hist(class_data, bins);
    end

  figure(2);
  plot(bins, binned_data); %2:end excludes 0 bin, gives correct vertical scale
  title(['Intensity Histograms: Class ' num2str(kkk)] );
  xlabel('Intensity value')
  ylabel('Number of pixels')
  legend( strrep(filelist,'_','\_') ); %need to escape underscore characters


  saveas(gcf,[OutputPNG ' Class ' num2str(kkk)], 'png'); %set to save current figure
  close(gcf)

end
