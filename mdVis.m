function mdVis(data,dataOut)

    f = figure('KeyPressFcn',{@keyPress});
    
    dataOut = log10(dataOut);

    axesList = {'i','j','k','l','m','n','o','p'};
    
    axLabels = {'amp1','freq1','amp2','freq2','phase'};

    nDesc = size(data,2);
    nObs  = size(data,1);
    
    % Get the descriptor range for each.
    for descN = 1:nDesc    
        descs{descN} = unique(data(:,descN));
        dataIX(:,descN) = dsearchn(descs{descN},data(:,descN));
    end
    
    % Place the data in a shaped matrix
    dataOutIX = [];
    for n = 1:size(dataOut,1)
        IXs = ones(8,1);
        for descN = 1:nDesc
            IXs(descN) = dataIX(n,descN);
        end
        dataOutSensIX(IXs(1),IXs(2),IXs(3),IXs(4),IXs(5),IXs(6),IXs(7),IXs(8)) = ...
            dataOut(n,1);
        dataOutAmpIX(IXs(1),IXs(2),IXs(3),IXs(4),IXs(5),IXs(6),IXs(7),IXs(8)) = ...
            dataOut(n,2);
    end
    
    % Replace zeros
    ix = find(dataOutSensIX == 0);
    dataOutSensIX(ix) = NaN;
    ix = find(dataOutAmpIX == 0);
    dataOutAmpIX(ix) = NaN;
    
    % Initialize Location 
    axLow = ones(8,1);
    axHigh = ones(8,1);
    xAxis = 1; axHigh(xAxis) = length(descs{xAxis});
    yAxis = 2; axHigh(yAxis) = length(descs{yAxis});

    % Initialize labels
    subplot(4,2,7:8);  
    for descN = 1:nDesc     
        plot([0 1],-descN*[1 1],'k'); hold on;
        
        nDiv = length(descs{descN}) + 1;
        for nTic = 1:length(descs{descN})
            line(nTic/nDiv*[1 1],[-.1 .1]-descN,'Color','k');
        end
        
        text(-.1,-descN,[axesList{descN},' - ',axLabels{descN}]);
    end
    axis off;
    xlim([-.1 1.1]);
    locLabels = [];
    
    refreshView();
    
    
    function keyPress(callingFig,E)

        shiftOn = false; controlOn = false; altOn = false;
        % Read in key modifiers
        if length(E.Modifier) > 0
            if strcmp(E.Modifier{1},'shift')
                shiftOn = true;
            elseif strcmp(E.Modifier{1},'control')
                controlOn = true;
            elseif strcmp(E.Modifier{1},'alt')
                altOn = true;
            end
        end
        
        switch E.Key

            case 'i'
                axN = 1;
            case 'j'
                axN = 2;
            case 'k'
                axN = 3;
            case 'l'
                axN = 4;
            case 'm'
                axN = 5;
            case 'n'
                axN = 6;
            case 'o'
                axN = 7;
            case 'p'
                axN = 8;
            otherwise
                    return;
        end
        
        if (axN ~= xAxis) && (axN ~= yAxis) 
            if ~shiftOn && ~controlOn && ~altOn && axHigh(axN) < length(descs{axN})
                axLow(axN) = axLow(axN) + 1;
                axHigh(axN) = axHigh(axN) + 1;
            elseif shiftOn && ~controlOn && ~altOn && axLow(axN) > 1
                axLow(axN) = axLow(axN) - 1;
                axHigh(axN) = axHigh(axN) - 1;
            elseif ~shiftOn && controlOn && ~altOn && (axN ~= yAxis)
                axLow(xAxis) = 1; axHigh(xAxis) = 1;
                xAxis = axN;
                axLow(xAxis) = 1; axHigh(xAxis) = length(descs{xAxis});
            elseif ~shiftOn && ~controlOn && altOn && (axN ~= xAxis)
                axLow(yAxis) = 1; axHigh(yAxis) = 1;
                yAxis = axN;
                axLow(yAxis) = 1; axHigh(yAxis) = length(descs{yAxis});    
            end
        end
        refreshView();     
        
    end
               
    
    function refreshView()
        
        subplot(4,2,[1,3,5]);  
        
        colormap(jet);
        subArray = squeeze(dataOutSensIX( axLow(1):axHigh(1),...
                                  axLow(2):axHigh(2),...
                                  axLow(3):axHigh(3),...
                                  axLow(4):axHigh(4),...
                                  axLow(5):axHigh(5),...
                                  axLow(6):axHigh(6),...
                                  axLow(7):axHigh(7),...
                                  axLow(8):axHigh(8)));
        % Reflect for correct x and y                      
        if (xAxis < yAxis)        
            subArray = subArray';
        end
        imHandle = image(subArray,'CDataMapping','scaled');
        set(gca,'YDir','normal');
        caxis([min((dataOutSensIX(:))) max((dataOutSensIX(:)))]);
        
        xlabel(['\color{blue}',axesList{xAxis},' - ',axLabels{xAxis}]);
        ylabel(['\color{magenta}',axesList{yAxis},' - ',axLabels{yAxis}]);
        xDesc = descs{xAxis}; yDesc = descs{yAxis};
        set(gca,'XTick',[1 length(xDesc)],'XTickLabel',{xDesc(1) xDesc(end)});
        set(gca,'YTick',[1 length(yDesc)],'YTickLabel',{yDesc(1) yDesc(end)},'TickDir','out');
        title('Log Sensitivity'); 
        
        subplot(4,2,[2,4,6]);  
        
        colormap(jet);
        subArray = squeeze(dataOutAmpIX( axLow(1):axHigh(1),...
                                  axLow(2):axHigh(2),...
                                  axLow(3):axHigh(3),...
                                  axLow(4):axHigh(4),...
                                  axLow(5):axHigh(5),...
                                  axLow(6):axHigh(6),...
                                  axLow(7):axHigh(7),...
                                  axLow(8):axHigh(8)));
        % Reflect for correct x and y                      
        if (xAxis < yAxis)        
            subArray = subArray';
        end
        imHandle = image(subArray,'CDataMapping','scaled');
        set(gca,'YDir','normal');
        caxis([min((dataOutAmpIX(:))) max((dataOutAmpIX(:)))]);
        
        xlabel(['\color{blue}',axesList{xAxis},' - ',axLabels{xAxis}]);
        ylabel(['\color{magenta}',axesList{yAxis},' - ',axLabels{yAxis}]);
        xDesc = descs{xAxis}; yDesc = descs{yAxis};
        set(gca,'XTick',[1 length(xDesc)],'XTickLabel',{xDesc(1) xDesc(end)});
        set(gca,'YTick',[1 length(yDesc)],'YTickLabel',{yDesc(1) yDesc(end)},'TickDir','out');
        title('Log Amplitude'); 
        
        subplot(4,2,7:8);  
        delete(locLabels); locLabels = [];
        ticList = 1:nDesc;
        ticList([xAxis,yAxis]) = []; 
        for descN = ticList
            nDiv = length(descs{descN}) + 1;
            locLabels(end+1) = scatter( axLow(descN)/nDiv, -descN, 'ro'); hold on;
            locLabels(end+1) = scatter(axHigh(descN)/nDiv, -descN, 'ro'); hold on;
        end
        locLabels(end+1) = scatter(axHigh(xAxis)/nDiv, -xAxis, 'bo'); hold on;
        locLabels(end+1) = scatter(axHigh(yAxis)/nDiv, -yAxis, 'mo'); hold on;
        locLabels(end+1) = scatter(axLow(xAxis)/nDiv, -xAxis, 'bo'); hold on;
        locLabels(end+1) = scatter(axLow(yAxis)/nDiv, -yAxis, 'mo'); hold on;
    end
end
    
    
        