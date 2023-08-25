data = dlmread('startups.txt', ',', 0, 0);

New_York = strcmp(data(:, 4), "New York");
California = strcmp(data(:, 4), "California");
Florida = strcmp(data(:, 4), "Florida");
data(New_York, 4) = 1;
data(California, 4) = 2;
data(Florida, 4) = 3;

function norm_data = normalize_features(data)
  mu = mean(data);
  sigma = std(data);
  norm_data = (data - mu) ./ sigma;
end

normalized_data = data;
normalized_data(:, [1, 2, 3, 5]) = normalize_features(data(:, [1, 2, 3, 5]));

csvwrite('preprocessed_startups.csv', normalized_data);


plot(normalized_data(:, 1), normalized_data(:, 5), 'o-');
xlabel('R&D Spend');
ylabel('Profit');
title('2D Line plot of R&D Spend vs Profit');

disp(normalized_data);
