%% Eye State Claassification using Wavelets.
% Main file for eye state classification.
% According to the parameters selected in the variables wavelets and
% ventanas, you can compare different mother wavelets and window sizes for
% the feature extraction step.
% For more information check the paper: Eye state identification based on
% discrete wavelet transforms and linear discriminant analysis.

clear;
close all;

% Common variables.
sujeto = {'s1', 's2', 's3', 's4', 's5', 's6', 's7'};

placa = 'PP';
desp = 0.2;
ventanas = 10;
rng('default') % For reproducibility

% Wavelets used for feature extraction.
wavelet = {'db8'};
% wavelet = {'db2', 'db4', 'db8', 'coif1', 'coif4', 'haar', 'sym2', 'sym4', 'sym10'};

% Device selection
if strcmp(placa, 'PP')
    fs = 200;
elseif strcmp(placa,'OPB')
    fs = 250;
end

% Preallocate variables.
accuracy = zeros(length(sujeto), length(ventanas), length(wavelet));
open_accuracy = zeros(size(accuracy));
closed_accuracy = zeros(size(accuracy));
accuracy_O2 = zeros(size(accuracy));
open_accuracy_O2 = zeros(size(accuracy));
closed_accuracy_O2 = zeros(size(accuracy));

sd = zeros(size(accuracy));
closed_sd = zeros(size(accuracy));
open_sd = zeros(size(accuracy));
sd_O2 = zeros(size(accuracy));
closed_sd_O2 = zeros(size(accuracy));
open_sd_O2 = zeros(size(accuracy));

for s = 1:length(sujeto)
    % Read files.
    [open, closed] = readFiles(sujeto{s}, placa);
    
    for ventana = 1 %1:length(ventanas)
        tam_ventana = ventanas(ventana);
        for wv = 1:length(wavelet)
            fprintf('Subject %d, WV = %s , tam_ventana =  %d \n', s, wavelet{wv}, tam_ventana);
            
            % CV partition to select minutes for training/testing.
            cv_mins = cvpartition(size(open,1), 'KFold', 5);

            % Classification for both channels.
%             [accuracy(s,ventana, wv), open_accuracy(s,ventana, wv), ...
%                 closed_accuracy(s,ventana, wv), sd(s,ventana, wv),...
%                 open_sd(s,ventana, wv), closed_sd(s,ventana, wv)] = ...
%                 ldaClassifyByMinutes( cv_mins, open, closed, ...
%                 fs*tam_ventana, fs*tam_ventana*desp, wavelet{wv}, 2, 2);
            
            % Classification for O2.
            [accuracy_O2(s,ventana, wv), open_accuracy_O2(s,ventana, wv), ...
                closed_accuracy_O2(s,ventana, wv), sd_O2(s,ventana, wv),...
                open_sd_O2(s,ventana, wv), closed_sd_O2(s,ventana, wv)] = ...
                ldaClassifyByMinutes( cv_mins, open, closed, ...
                fs*tam_ventana, fs*tam_ventana*desp, wavelet{wv}, 1, 2);
        end
    end
end

%% Example how to plot the results.

% plotAccuracyPerWindowSize(accuracy(:,:,3), accuracy_O2(:,:,3), closed_accuracy(:,:,3), ...
%     open_accuracy(:,:,3), closed_accuracy_O2(:,:,3), open_accuracy_O2(:,:,3), sd(:,:,3), open_sd(:,:,3), ...
%     closed_sd(:,:,3), sd_O2(:,:,3), open_sd_O2(:,:,3), closed_sd_O2(:,:,3));

