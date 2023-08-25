data = readtable('penguins.csv');


data = rmmissing(data);

data.species = grp2idx(data.species);
data.island = grp2idx(data.island);
data.sex = grp2idx(data.sex);

rng(1); 
cv = cvpartition(data.species, 'Holdout', 0.2);
train_data = data(training(cv), :);
temp_data = data(test(cv), :);

cv2 = cvpartition(temp_data.species, 'Holdout', 0.5);
validation_data = temp_data(training(cv2), :);
test_data = temp_data(test(cv2), :);


X_train = train_data{:, 2:end};
y_train = train_data.species;
X_val = validation_data{:, 2:end};
y_val = validation_data.species;
X_test = test_data{:, 2:end};
y_test = test_data.species;

lambda = 0.1;

mdl = mnrfit(X_train, y_train, 'model', 'binary', 'link', 'logit', 'options', statset('MaxIter', 1000), 'penalty', 'L2', 'lambda', lambda);


y_train_pred = mnrval(mdl, X_train);
y_val_pred = mnrval(mdl, X_val);
y_test_pred = mnrval(mdl, X_test);

[~, train_pred_class] = max(y_train_pred, [], 2);
[~, val_pred_class] = max(y_val_pred, [], 2);
[~, test_pred_class] = max(y_test_pred, [], 2);

train_acc = sum(train_pred_class == y_train) / numel(y_train);
val_acc = sum(val_pred_class == y_val) / numel(y_val);
test_acc = sum(test_pred_class == y_test) / numel(y_test);

fprintf('Train Accuracy: %.2f%%\n', train_acc * 100);
fprintf('Validation Accuracy: %.2f%%\n', val_acc * 100);
fprintf('Test Accuracy: %.2f%%\n', test_acc * 100);

figure;
gscatter(X_test(:, 1), X_test(:, 2), test_pred_class);
xlabel('Culmen Length');
ylabel('Culmen Depth');
title('Predicted Penguin Species');
