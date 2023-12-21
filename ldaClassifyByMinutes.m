function [mean_accuracy, open_accuracy, closed_accuracy, sd, open_sd, closed_sd] = ...
    ldaClassifyByMinutes(cv_partition, open, closed, tam_ventana, desp, wavelet, nb_channel, nb_features)

% Function for eye state classification.
% It applies the feature extraction and classification procedure.

use_svm = 0;

if nb_channel == 1
    if nb_features == 1
        features = {'pow10_O2'};
    else
        features = {'std10_O2', 'ratio_O2'};
    end
else
    if nb_features == 1
        features = {'pow10_O1', 'pow10_O2'};
    else
        features = {'std10_O1', 'std10_O2', 'ratio_O1', 'ratio_O2'};
    end
end

% Extract features for each minute independently.
for i = 1:size(open,1)
    op_feat{i} = extractNewFeatures(squeeze(open(i, :, :)), ...
        tam_ventana, desp, wavelet);
    
    cl_feat{i} = extractNewFeatures(squeeze(closed(i, :, :)), ...
        tam_ventana, desp, wavelet);
end

% Preallocate variables.
accuracy = zeros(1,cv_partition.NumTestSets);
acc_closed = zeros(size(accuracy));
acc_open = zeros(size(accuracy));

plot_confusion_matrix = 0;

% Cross-validation.
for fold = 1:cv_partition.NumTestSets
    train_mins = find(cv_partition.training(fold));
    test_mins = find(cv_partition.test(fold));
    
    % Training set.
    tr_op = [];
    tr_cl = [];
    for i = 1:length(train_mins)
        tr_op = [tr_op; op_feat{train_mins(i)}];
        tr_cl = [tr_cl; cl_feat{train_mins(i)}];
    end
    train_set = [tr_op(:, features); tr_cl(:, features)];
    train_labels = [ones(size(tr_op,1), 1); zeros(size(tr_cl,1), 1)];

    % Test set.
    tst_op = [];
    tst_cl = [];
    for i = 1:length(test_mins)
        tst_op = [tst_op; op_feat{test_mins(i)}];
        tst_cl = [tst_cl; cl_feat{test_mins(i)}];
    end
    test_set = [tst_op(:, features); tst_cl(:, features)];
    test_labels(fold, :) = [ones(size(tst_op,1), 1); zeros(size(tst_cl,1), 1)];
        
    % Train SVM or LDA.
    if use_svm == 1
        classification_model = fitcsvm(...
            train_set, ...
            train_labels, ...
            'Standardize', true, ...
            'KernelFunction', 'linear');
    else
        classification_model = fitcdiscr(...
            train_set, ...
            train_labels, ...
            'DiscrimType', 'linear');
        
%         plot_lda(classification_model, train_set, train_labels);
    end
        
    
    predictions(fold,:) = predict(classification_model, test_set);
    
    plot_lda(classification_model, test_set, test_labels(fold,:));
    
    C = confusionmat(test_labels(fold,:), predictions(fold,:));
    
    accuracy(fold) = sum(predictions(fold,:) == test_labels(fold,:))/length(test_labels(fold,:));
    acc_open(fold) = sum(predictions(fold, test_labels(fold,:) == 1) == 1)/sum(test_labels(fold,:) == 1);
    acc_closed(fold) = sum(predictions(fold, test_labels(fold,:) == 0) == 0)/sum(test_labels(fold,:) == 0);
     
end

mean_accuracy = mean(accuracy)*100;
open_accuracy = mean(acc_open)*100;
closed_accuracy = mean(acc_closed)*100;

sd = std(accuracy)*100;
open_sd = std(acc_open)*100;
closed_sd = std(acc_closed)*100;

if plot_confusion_matrix == 1
    pred_labels = reshape(predictions, [], 1);
    true_labels = reshape(test_labels, [], 1);

    [cm, order] = confusionmat(true_labels, pred_labels);
    cm_chart = confusionchart(cm, order);
    cm_chart.RowSummary = 'row-normalized';
    cm_chart.ColumnSummary = 'column-normalized';
    
    precision = cm(1,1)/sum(cm(1,:));
    sensitivity = cm(1,1)/sum(cm(:,1));     % also called recall. TPR
    specificity = cm(2,2)/sum(cm(:,2));      % TNR 
end