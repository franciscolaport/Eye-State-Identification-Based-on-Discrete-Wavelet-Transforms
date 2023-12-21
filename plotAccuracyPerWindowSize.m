function plotAccuracyPerWindowSize(accuracy_full, accuracy_O2, accuracy_closed, ...
    accuracy_open, accuracy_closed_O2, accuracy_open_O2, sd, sd_open, sd_closed, ...
    sd_O2, sd_open_O2, sd_closed_O2)

[nb_subjects, nb_windows, nb_wavelets] = size(accuracy_full);

figure(101);
figure(102);
for s = 1:nb_subjects
    figure(101);
    subplot(2,4, s);
    plot(accuracy_full(s, :), 'b-s'); hold on;
    plot(accuracy_O2(s, :), 'r-^');
    title(['Subject ' num2str(s) ]);
    legend('O1 and O2', 'O2', 'Location', 'SouthEast');
    xticks([1:10]);
    xlabel('Window size (s)');
    ylabel('Accuracy (%)');
    grid on;
    
    figure(s);
%     subplot(2,4, s);
    plot(accuracy_closed(s, :), 'b-s', 'LineWidth', 1); hold on;
    plot(accuracy_open(s, :), 'b-^', 'LineWidth', 1); hold on;
    plot(accuracy_closed_O2(s, :), 'r--s', 'LineWidth', 1); hold on;
    plot(accuracy_open_O2(s, :), 'r--^', 'LineWidth', 1); hold on;
%     title(['Subject ' num2str(s) ]);
    legend('O1 & O2 - Closed', 'O1 & O2 - Open', 'O2 - Closed','O2 - Open', 'Location', 'SouthEast');
    xticks([1:10]);
    xlabel('Window size (s)');
    ylabel('Accuracy (%)');
    grid on;
    xlim([1 10]);
    ylim([40 103]);
    yticks([40:10:100]);
    set(gca,'FontSize',12,'LineWidth',1, 'FontName', 'Times');
    saveas(gcf,['Figuras/1vs2-S' num2str(s) '.pdf'])
end

figure(101);
subplot(2,4, s+1);
plot(mean(accuracy_full), 'b-s'); hold on;
plot(mean(accuracy_O2), 'r-^');
title('Mean');
legend('O1 and O2', 'O2', 'Location', 'SouthEast');
xticks([1:10]);
xlabel('Window size (s)');
ylabel('Accuracy (%)');
grid on;

figure(s+1);
% subplot(2,4, s+1);
plot(mean(accuracy_closed), 'b-s', 'LineWidth', 1); hold on;
plot(mean(accuracy_open), 'b-^', 'LineWidth', 1); hold on;
plot(mean(accuracy_closed_O2), 'r--s', 'LineWidth', 1); hold on;
plot(mean(accuracy_open_O2), 'r--^', 'LineWidth', 1); hold on;
% title('Mean');
legend('O1 & O2 - Closed', 'O1 & O2 - Open', 'O2 - Closed','O2 - Open', 'Location', 'SouthEast');
xticks([1:10]);
xlabel('Window size (s)');
ylabel('Accuracy (%)');
grid on;
xlim([1 10]);
ylim([40 103]);
yticks([40:10:100]);
set(gca,'FontSize',12,'LineWidth',1, 'FontName', 'Times');
saveas(gcf,['Figuras/1vs2-Mean.pdf']);

x = 1:10;

% Plot mean + std.
for s = 1:nb_subjects
    figure(200+s);
%     subplot(2,4, s);
    plot(accuracy_closed(s, :), 'b-s', 'LineWidth', 1); hold on;
    lower_sd = accuracy_closed(s, :)-sd(s, :);
    upper_sd = accuracy_closed(s, :)+ sd(s, :);
    idx_100 = find(upper_sd > 100);
    idx_0 = find(lower_sd < 0);
    upper_sd(idx_100) = 100;
    lower_sd(idx_0) = 0;
    patch([x fliplr(x)], [lower_sd  fliplr(upper_sd)], 'blue', 'FaceAlpha', .1, 'EdgeColor', 'none', 'HandleVisibility','off');
    plot(accuracy_open(s, :), 'r-s', 'LineWidth', 1); hold on;
    lower_sd = accuracy_open(s, :)-sd(s, :);
    upper_sd = accuracy_open(s, :)+ sd(s, :);
    idx_100 = find(upper_sd > 100);
    idx_0 = find(lower_sd < 0);
    upper_sd(idx_100) = 100;
    lower_sd(idx_0) = 0;
    patch([x fliplr(x)], [lower_sd  fliplr(upper_sd)], 'red', 'FaceAlpha', .1, 'EdgeColor', 'none', 'HandleVisibility','off');
    title(['Subject ' num2str(s) ]);
    legend('Closed', 'Open', 'Location', 'SouthEast');
    xticks([1:10]);
    xlabel('Window size (s)');
    ylabel('Accuracy (%)');
    grid on;
    xlim([1 10]);
    ylim([60 103]);
    yticks([60:10:100]);
    set(gca,'FontSize',12,'LineWidth',1, 'FontName', 'Times');
%     saveas(gcf,['Figuras/ACC-STD-S' num2str(s) '.pdf'])
end

figure(200+s+1);
plot(mean(accuracy_closed), 'b-s', 'LineWidth', 1); hold on;
lower_sd = mean(accuracy_closed)-mean(sd_closed);
upper_sd = mean(accuracy_closed)+mean(sd_closed);
idx_100 = find(upper_sd > 100);
idx_0 = find(lower_sd < 0);
upper_sd(idx_100) = 100;
lower_sd(idx_0) = 0;
patch([x fliplr(x)], [lower_sd  fliplr(upper_sd)], 'blue', 'FaceAlpha', .1, 'EdgeColor', 'none', 'HandleVisibility','off');

plot(mean(accuracy_open), 'r-s', 'LineWidth', 1); hold on;
lower_sd = mean(accuracy_open)-mean(sd_open);
upper_sd = mean(accuracy_open)+mean(sd_open);
idx_100 = find(upper_sd > 100);
idx_0 = find(lower_sd < 0);
upper_sd(idx_100) = 100;
lower_sd(idx_0) = 0;
patch([x fliplr(x)], [lower_sd  fliplr(upper_sd)], 'red', 'FaceAlpha', .1, 'EdgeColor', 'none', 'HandleVisibility','off');
legend('Closed', 'Open', 'Location', 'SouthEast');
xticks([1:10]);
xlabel('Window size (s)');
ylabel('Accuracy (%)');
grid on;
xlim([1 10]);
ylim([60 103]);
yticks([60:10:100]);
set(gca,'FontSize',12,'LineWidth',1, 'FontName', 'Times');
