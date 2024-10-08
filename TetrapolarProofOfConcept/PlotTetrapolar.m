load("ConfigurationB/ExtractedTetrapolarResponses.mat");
load("ConfigurationB/GroundTruth.mat");

% Remove zeros at temp transitions
for i = 1:length(temps)
    if temps(i) == 0
        temps(i) = temps(i+1);
    end
end

subplot(3,1,1);
phi = [temps.' fliplr(temps.')];
gx = linspace(0, minutes(times(end)-times(1)), length(temps));
gx = [gx fliplr(gx)];
gy = [-0.07*ones([1, length(temps)]) 0.015*ones([1, length(temps)])];
patch(gx, gy, phi, 'facealpha', 0.3, 'edgecolor', 'none');
colormap(gray);
clim([0 70]);
hold on
for i = 1:3
    channel = (channels(:,i)-channels(1500,i))./channels(1,i);
    plot(minutes(channeltimes-times(1)), smooth(channel, 300), 'linewidth', 2);
    hold on
end
% ylim([-0.05 0.015]);
xlim([0 40]);
line([1.25 1.25], [-0.05 0.015], 'color', 'k', 'linewidth', 2);
ylabel("\DeltaV/V_0");
set(gca, 'fontsize', 15, 'linewidth', 2, 'layer', 'top');
box off
legend({""; "Top"; "Middle"; "Bottom"}, 'location', 'n', 'orientation', 'horizontal');
legend boxoff
title("Normalized Responses");

subplot(3,1,2);
plot(minutes(times-times(1)), temps, 'color', 'r', 'linewidth', 2);
hold on
line([1.25 1.25], [0 70], 'color', 'k', 'linewidth', 2);
ylim([0 70]);
set(gca, 'fontsize', 15, 'linewidth', 2);
ylabel("Temperature (^oC)");
box off
title("Ground Truth");
text(1.4, 60, "\itPressed with probe", 'FontSize', 13);

subplot(3,1,3);
gy = [0.2*ones([1, length(temps)]) 1.0*ones([1, length(temps)])];
patch(gx, gy, phi, 'facealpha', 0.3, 'edgecolor', 'none');
colormap(gray);
clim([0 70]);
hold on
for i = 1:3
    plot(minutes(channeltimes-times(1)), channels(:, i), 'linewidth', 2);
    hold on
end
% ylim([0.65 1.0]);
xlim([0 40]);
line([1.25 1.25], [0.65 1.0], 'color', 'k', 'linewidth', 2);
ylabel("Voltage (V)");
set(gca, 'fontsize', 15, 'linewidth', 2, 'layer', 'top');
box off
legend({""; "Top"; "Middle"; "Bottom"}, 'location', 'n', 'orientation', 'horizontal');
legend boxoff
xlabel("Time (minutes)");
title("Raw Responses");

set(gcf, 'color', 'w', 'position', [296    79   938   816]);