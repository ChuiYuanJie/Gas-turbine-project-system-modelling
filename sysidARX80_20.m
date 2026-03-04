% Read both CSV files
%data1 = readtable('ex_1.csv');
%data2 = readtable('ex_4.csv');

% Combine them vertically (assuming same column structure)
%combined_data = [data1; data2];

% Optional: shuffle the combined data randomly
%combined_data = combined_data(randperm(height(combined_data)), :);

% Save to a new file
%writetable(combined_data, 'combined_dataset.csv');

% Step 1: Load Combined Dataset
data = readtable('combined_dataset.csv'); % Make sure this has time, input_voltage, el_power

%% Step 2: Determine Split Index
total_len = height(data);
split_idx = round(0.8 * total_len); % 80% for training

%% Step 3: Split Data Based on Time Order
train_data = data(1:split_idx, :);
test_data = data(split_idx+1:end, :);

%% Step 4: Extract Inputs and Output
u_train = [train_data.time, train_data.input_voltage];
y_train = train_data.el_power;

u_test = [test_data.time, test_data.input_voltage];
y_test = test_data.el_power;

Ts = 1; % Sampling time (adjust if different)

%% Step 5: Create iddata Objects
data_train = iddata(y_train, u_train, Ts);
data_test = iddata(y_test, u_test, Ts);

%% Step 6: Model Estimation (ARX)
na = 2; 
nb = [2 2]; 
nk = [1 1]; 

model_arx = arx(data_train, [na nb nk]);
present(model_arx);

%% Step 7: Model Validation
figure;
compare(data_test, model_arx);
title('ARX Model Fit on Test Data (Time-Based 80/20)');

resid(data_test, model_arx);

%% Optional: Compute Fit %
y_pred_test = sim(model_arx, data_test.InputData);
fit_percent = 100 * (1 - norm(data_test.OutputData - y_pred_test)/norm(data_test.OutputData));
fprintf('Fit on test data (time-based split): %.2f%%\n', fit_percent);
