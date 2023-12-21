function features = extractNewFeatures(eeg, tam_ventana, desp, wavelet)
N = size(eeg,1);
N_ch = size(eeg,2);

% Por cada canal de la señal
for ch = 1:N_ch
    idx = 1;
    for ii = 1:desp:N-tam_ventana+1
        signal = eeg(ii:ii+tam_ventana-1, ch);
        plot(signal); ylim([-140, 140]);
        [c, l] = wavedec(signal, 4, wavelet);
        [cd2, cd3, cd4] = detcoef(c, l, [2,3,4]);
        approx = appcoef(c, l, wavelet);
        
        %Mean
        avg10(idx, ch) = mean(cd4);
        avg15(idx, ch) = mean(cd3);
        
        %Max
        max10(idx,ch) = max(cd4);
        
        % Power
        pow5(idx,ch) = mean(approx.^2); 
        pow10(idx,ch) = mean(cd4.^2);
        pow15(idx,ch) = mean(cd3.^2);
        pow20(idx,ch) = mean(cd2.^2);
        
        % STD
        std10(idx,ch) = std(cd4);
        std15(idx,ch) = std(cd3);
        
        idx = idx+1;
    end
end
ratio = pow15./pow10;
array = [pow10, ratio, std10, avg10, max10];

feature_names = {'pow10_O1', 'pow10_O2', 'ratio_O1', 'ratio_O2', 'std10_O1', ...
    'std10_O2', 'avg10_O1', 'avg10_O2', 'max10_O1', 'max10_O2'};
    
features = array2table(array, 'VariableNames', feature_names);
end