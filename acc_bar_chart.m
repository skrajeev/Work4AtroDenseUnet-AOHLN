X = [96.12	97.01	97.91	98.21	98.81
; 
     96.88	97.12	97.6	98.32	99.04
];
figure();
b = bar(X', 'BarWidth', 0.9); % Adjust BarWidth if needed
ylim([90 100]);

set(gca, 'fontweight', 'bold');
ylabel('Accuracy');
legend('BRATS 2019', 'BRATS 2020');
grid on;
grid minor;

% Adjust the spacing between the categories
set(gca, 'xtick', 1:size(X, 2)); % Set the x-tick positions
set(gca, 'xticklabel', {'CNN', 'LSTM', 'ResNet', 'DCN', 'Proposed'}); % Labels

% Compress the x-axis to reduce the spacing
xlim([0.3, size(X, 2) + 0.3]); % Tighten axis limits

% Annotate values on top of each bar
for i = 1:size(X, 2) % Loop over the groups
    for j = 1:size(X, 1) % Loop over the bars in each group
        xPos = b(j).XEndPoints(i); % Get the x-position of the bar
        yPos = X(j, i); % Get the y-value of the bar
        text(xPos, yPos, sprintf('%.2f', yPos), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom');
    end
end