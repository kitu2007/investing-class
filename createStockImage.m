function img  = createStockImage(back_years,win_size)
% this creates the stock image
%
% --------------------------------
% Kshitiz

if(nargin<1)
    back_years = 15;
end
if(nargin<2)
    win_size = 30;
end

retail = {'Amazon','Walmart','Walgreen','Costco'}; retail_tag={'AMZN','WMT','WAG','COS'};
groceries = {'WholeFoods','Krogers'}; groceries_tagset = {'WFC','KR'};
housing = {'HomeDepot'};
internetAds = {'Google','Microsoft','Yahoo'};
electornics = {'Apple','Samsung','LG','Sony'};
beverages = {'Starbucks','Cocacola','Pepsi'}; tag = {'SBUX','KO','PEP'};
FastFood = {'Panera','MacDonalds'}; tag = {'PNRA','MCD'};
Streaming = {'Netflix','Amazon'}; 
Fidelity = {'FidelityFund', 'FideBlueChip','FidLargeCap','Overseas','RealEstate','TotalBond','InvestBond','ShortBond'};
fidelity_tag = {'FFIDX','FBGRX','FLCSX','FOSFX','FRESX','FTBFX','FBNDX','FSHBX'}; 
socialMedia ={ 'Facebook','Twitter'};
Robotics  = {}; 


basedir = '/Users/kgarg/Coursera_hws/investing/data/';
filenames = getfnames(basedir,'*.csv');


%% create the image to display (getImage())
% if data is not available for later time just put zero in time

nfiles = length(filenames);
nyears = 250*back_years;
img = .00001*ones(nfiles,nyears);
fixedPoint = 1.5;  
for i = 1:nfiles
    fullname = [basedir filenames{i}];
    tmp = csvread(fullname,1,6);
    M{i} = tmp;
    nlen = length(M{i});
    img(i,1:min(nlen,nyears)) = M{i}(1:min(nlen,nyears))/M{i}(round(fixedPoint*250));
    nlenArray{i} = nlen; 
end


% flip the image lr
img = fliplr(img);

% blur the image
% gblur = fspecial('gaussian',[1 5],0.5);

slidingWin = ones(1,win_size)/win_size;
newImg = 0;
img = imfilter(img, slidingWin,'same');

% take a gradient 
diffFilter = [-1 1];
diff = imfilter( log(img), diffFilter,'same');
diff = min(.05,diff); 
%img = diff; 

if 0
testImg = zeros(100,100);
testImg(:,45:50)=1;
testImg(45:50,:)=1;
diff_testImg = imfilter(log(testImg), diffFilter,'same');
end


end