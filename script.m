 
amps = descs{1};
for n = 1:10
    subplot(5,2,n);
    
    pow1 = 3*n;
    semilogx(descs{2},dataOutSensIX(pow1,:,1,1,1),'b'); hold on;
    semilogx(descs{2},dataOutSensIX(pow1,:,2,1,1),'g'); hold on;
    semilogx(descs{2},dataOutSensIX(pow1,:,3,1,1),'r'); hold on;
    xlim([min(descs{2}) max(descs{2})]);
    ylabel('Sensitivity (m/N)');
    xlabel('Tone 1 (Hz)');
    title(['Tone 1 Amp: ',num2str(amps(n)),' N']);
    line([200 200],ylim(),'Color','k','LineStyle','--');
end