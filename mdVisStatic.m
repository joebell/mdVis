function mdVisStatic(data,dataOut)

    colormap(jet);
    caxis([min(dataOut) max(dataOut)]);
    
    axLabels = {'amp1','freq1','amp2','freq2','phase'};

    nDesc = size(data,2);
    nObs  = size(data,1);
    
    % Get the descriptor range for each.
    for descN = 1:nDesc    
        descs{descN} = unique(data(:,descN));
        dataIX(:,descN) = dsearchn(descs{descN},data(:,descN));
        descL(descN) = length(descs{descN});
    end
    
    xOffsetFactor = [16, 1, 0, 0, 1];
    yOffsetFactor = [0, 0, 16, 1, 0];
    
    for point = 1:length(dataOut)
    	locIX = dataIX(point,:);
        x = sum((locIX-1).*xOffsetFactor) + 1;
        y = sum((locIX-1).*yOffsetFactor) + 1;
        bigImage(y,x) = dataOut(point);
    end
    
    image((bigImage),'CDataMapping','scaled');
    set(gca,'YDir','normal');
    axis off; axis equal;

    
    
    