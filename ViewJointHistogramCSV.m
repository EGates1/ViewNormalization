%% ViewJointHistogram( OutputPNG, csvfile, image, mask) 
%  csvfile - list of images and masks to plot
%  image - column name in csv file for pixel intensity data
%  mask - column name with masks, each label is plotted separately.
%  OutputPNG   - Joint Histogram name


function ViewJointHistogramCSV( OutputPNG, csvfile, image, mask)

if ~isdeployed
  addpath('./nifti');
end

%% Load data files
% %get image data files
% listfiles = ['ls ' RegExpFiles];
% disp(listfiles ); 
% [~,sysresult] = system(listfiles );
% 
% sysresult= strrep(sysresult,char(10),'');   %might not be needed, sysresult already space delimited?
% filelist = strsplit(sysresult,' ');
% 
% %get classification masks
% listmaskfiles = ['ls ' RegExpMasks];
% disp(listmaskfiles ); 
% [~,sysresult] = system(listmaskfiles );
% 
% sysresult= strrep(sysresult,char(10),'');   %might not be needed, sysresult already space delimited?
% maskfilelist = strsplit(sysresult,' ');

% for kk=1:31
% ViewJointHistogramCSV(sprintf('/rsrch1/ip/JSLin1_Lab/Jonathan_Project/RadPath/Script01_T1_T2_SWAN/01_Masks/CLARA/hists/%d_T2mask',kk),...
%     sprintf('/rsrch1/ip/JSLin1_Lab/Jonathan_Project/RadPath/Script01_T1_T2_SWAN/01_Masks/CLARA/T2masks/ORP%d_T2masks.csv',kk),'T2_raw','mask')
% end

csvdata = readtable(csvfile,'Delimiter',',');
filelist = csvdata{:,image};
maskfilelist = csvdata{:,mask};

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
   classes = int16(unique(niifile.img )); %list sorted class numbers
   classlist = union(classlist, classes); %add classes to class list
end

% TODO: check if image/mask exists with: exist(filename, 'file') == 2


%% Histogram datasets, plot and save
nbins = 100;            %SET NUMBER OF HISTOGRAM BINS
bins = linspace(double(mindata), double(maxdata), nbins); %start at 1 so 0 gets its own bin

% compute statistics for mean, mode, modebin
nclass = length(classlist);
nfile = length(filelist);
stat_names = {'Class','mean','mode','modeRound10'};
hist_stats = zeros(nfile*nclass,length(stat_names));
hist_stats(:,1) = repelem(classlist,nfile); % first col is class list

for kkk=1:nclass%classlist'
  binned_data = zeros(nbins, nfile );
    for lll=1:length(filelist)
      class_data = images{lll}(masks{lll}==classlist(kkk)); %get only data from that class
      binned_data(:,lll) = hist(class_data, bins);
      hist_stats(lll+nfile*(kkk-1),2:end) = [mean(class_data), mode(class_data), mode(10*floor(class_data/10))];
    end

  figure(2);
  set(gcf, 'Position', [10 10 800 600]);
  plot(bins, binned_data); %2:end excludes 0 bin, gives correct vertical scale
  title(['Intensity Histograms: Class ' num2str(classlist(kkk))] );
  xlabel('Intensity value')
  ylabel('Number of pixels')
  [~,imglegvals,~]  = cellfun(@fileparts,filelist,'UniformOutput',0);
  [~,masklegvals,~] = cellfun(@fileparts,maskfilelist,'UniformOutput',0);
  legend(strcat(strrep(strrep(imglegvals,'_','\_'),'.nii',''),'---',...
                strrep(strrep(masklegvals,'_','\_'),'.nii','')),...
         'Location','southoutside' ); %need to escape underscore characters


  saveas(gcf,[OutputPNG '_Class_' num2str(classlist(kkk))], 'png'); %set to save current figure



end

% Save summary statistics
stat_table = array2table(hist_stats,'VariableNames',stat_names);
stat_table.image = repmat(filelist,nclass,1);
stat_table.mask = repmat(maskfilelist,nclass,1);
writetable(stat_table,[OutputPNG '_StatTable.csv'])
