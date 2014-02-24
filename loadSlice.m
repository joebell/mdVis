%function loadSlice(dataIn,dataOut)


    axLabels = {'amp1','freq1','amp2','freq2','phase'};

    nDesc = size(dataIn,2);
    nObs  = size(dataIn,1);
    
    % Get the descriptor range for each.
    for descN = 1:nDesc    
        descs{descN} = unique(dataIn(:,descN));
        dataIX(:,descN) = dsearchn(descs{descN},dataIn(:,descN));
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
    
    semilogx(descs{2},dataOutSensIX(1,:,1,1,1),'b'); hold on;
    semilogx(descs{2},dataOutSensIX(1,:,2,1,1),'g'); hold on;
    semilogx(descs{2},dataOutSensIX(1,:,3,1,1),'r'); hold on;