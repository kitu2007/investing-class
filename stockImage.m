function out = stockImage(back_years,win_size)
% this file look for the historical data of stocks that are in the data
% folder and shows them as an image (x axis is the time) and y axis is
% simply the companies. 
% back_years tell how many years are we looking back in time. 
% TODO: group the visualization in terms of similarity in companies. 
% need more data there. 
% ------------------------------------------------
% Kshitiz 

if nargin < 1
    back_years = 15; 
end

if nargin < 2
    win_size = 30; 
end
%% create the GUI
% plots them as an image
backgroundColor = .2*ones(1,3);

% create the figure.
%'KeyPressFcn', @keyCatch, 'KeyReleaseFcn', @keyRelease, ...

h_fig = figure(...
    'Menu', 'none', 'Toolbar', 'none', 'HandleVisibility', 'off', ...
    'DefaultUipanelBackgroundColor', backgroundColor, ...
    'DefaultUipanelForegroundColor', 'w', ...
    'DefaultUipanelHighlightColor', .6*ones(1,3), ...
    'DefaultUipanelShadowColor', zeros(1,3), ...
    'DefaultUipanelBorderType', 'etchedout', ...
    'DefaultUIControlUnits', 'norm', ...
    'DefaultUIControlBackgroundColor', backgroundColor, ...
    'DefaultUIControlForegroundColor', 'w');

% create an image/result panel.
h_resultPanel = uipanel('Parent', h_fig, 'Pos', [0 0 .8 1], 'BorderWidth', 0);
makePanelResizable(h_resultPanel, 'R');

panelSettings = {'FontName', 'Gill Sans', 'FontSize', 16, ...
    'TitlePos', 'lefttop'};

h_imgPanel = uipanel('Parent', h_resultPanel, 'Pos', [0 0 1 1], ...
    'Title', 'Image', panelSettings{:});

h_imgAxes = axes('Pos', [0 0 1 1], 'Parent', h_imgPanel);

% create the control panel
h_controlPanel = uipanel('Parent', h_fig, 'Pos', [.8 0 .2 1], 'BorderWidth', 0);
pos = get(h_controlPanel, 'Pos');
set(h_controlPanel, 'Pos', [pos(1:3) pos(4)-.05]);


basedir = '/Users/kgarg/Coursera_hws/investing/data/';
filenames = getfnames(basedir,'*.csv');

% create the company names for the listbox
str = '';
for i=1:length(filenames)
    str = sprintf('%s|%s',str,filenames{i}(1:end-4));
end
% create a list of all the companys
h_videoCheckbox = uicontrol('Parent', h_controlPanel, 'Style', 'listbox', ...
    'String', str(2:end), 'Max',5, 'Min', 0, 'Value',[ ], 'Pos', [0 0 1 1], ...
    'Callback', @showStock);


%% create the image to display (getImage())

img = createStockImage(back_years,win_size); 

% if data is not available for later time just put zero in time
if 0
nfiles = length(filenames);
nyears = 250*back_years; 
img = zeros(nfiles,nyears);

for i = 1:nfiles
    fullname = [basedir filenames{i}];
    tmp = csvread(fullname,1,6);
    
    M{i} = tmp;
    nlen = length(M{i});
    img(i,1:min(nlen,nyears)) = M{i}(1:min(nlen,nyears))/M{i}(1);
end

% flip the image lr 
img = fliplr(img); 

% blur the image 
% gblur = fspecial('gaussian',[1 5],0.5); 

slidingWin = ones(1,win_size)/win_size; 
newImg = 0; 
img = imfilter(img, slidingWin,'same');
end

%% end of the function 

% display the image 
h_img = imagesc( 0.5*img([1:end],:),'Parent', h_imgAxes); %impixelinfo; colormap(gray);
set(h_img,'ButtonDownFcn',@showData);

% common variables that are used. x-axis
year = @(x) (2014 - back_years + x/250);
x_axis = year([1:size(img,2)]);
h_fig2 = figure(201); plot_axes = gca;
h_point =[];


%% helper function for the gui
    % shows the stock value for the point clicked by the user. 
    function out = showData(~,~)
        % get the point a user clicks
        [X Y] = getpts(h_imgAxes);
                
        % draws a mark to visualize the point clicked.
        if(~isempty(h_point))
            delete(h_point); 
        end
        hold(h_imgAxes); 
        h_point = plot(h_imgAxes,X,Y,'+','color','r');
        hold(h_imgAxes);

        % get the company index
        companyInd = floor(Y+0.5); 
        companyName = filenames{companyInd};
        drawFixedGraph();
        drawCompanyGraph(companyInd);        
    end

    % this show the graph for stocks selected from the list box.  
    function out = showStock(src,~)
        stocks_sel = get(src,'Value');
        drawFixedGraph();
        drawCompanyGraph(stocks_sel);
    end

    % this draws the graph for SP 500 (benchmark)
    function out = drawFixedGraph()
        cla(plot_axes); % clear previous  data
        sp500 = find(strcmp(filenames,'GSPC.csv'));        
        plot(plot_axes,x_axis,img(sp500,:),'k-');
        hold on;
        
        %tsx = find(strcmp(filenames,'TYX.csv'));
        %plot(plot_axes, x_axis,img(tsx,:),'g-');
    end

    % this draws the graph for the company
    function out = drawCompanyGraph(values)
    
        companyNames = '';
        colorstr = {'r','g','b','m','c'};
        assert(length(filenames) == size(img,1));
        
        for i=1:length(values)
            ind = values(i);
            companyNames = sprintf('%s-%s',companyNames,filenames{ind});
            plot(plot_axes, x_axis,img(ind,:),colorstr{i});
        end
        
        title(companyNames);
        hold off; 
        %legend({'GSPC','TYX',filenames{values}})
    end


end


