%% ARX

% Step 1: Load Training and Testing Data
train_data = readtable('ex_1.csv');
test_data = readtable('ex_4.csv');

% Step 2: Extract Inputs and Output
% You can adjust inputs based on correlation and importance
% Normalize inputs and output
u_train = normalize([train_data.time, train_data.input_voltage]);
y_train = normalize(train_data.el_power);

u_test = normalize([test_data.time, test_data.input_voltage]);
y_test = normalize(test_data.el_power);


Ts = 1; % Sampling time (assumed 1 second)

% Step 3: Create iddata objects
data_train = iddata(y_train, u_train, Ts);
data_test = iddata(y_test, u_test, Ts);

%% Step 4: Plot Input-Output (Training Data)
t = (0:length(y_train)-1)*Ts;

figure;
subplot(4,1,1); plot(t, u_train(:,1)); title('time');
subplot(4,1,2); plot(t, u_train(:,2)); title('input voltage');
subplot(4,1,3); plot(t, y_train); title('electrical power');

%% Step 5: Model Selection and Estimation
na = 2; 
nb = [2 2 ]; % one nb value for each input
nk = [1 1 ]; % delay (adjust if needed)

model_arx = arx(data_train, [na nb nk]);

disp('ARX model parameters:');
present(model_arx);

%% Step 6: Model Validation on Training Data
figure;
compare(data_train, model_arx);
title('Model Fit on Training Data');

resid(data_train, model_arx);

%% Step 7: Model Validation on Test Data
figure;
compare(data_test, model_arx);
title('Model Fit on Test Data');

resid(data_test, model_arx);

% Optionally calculate goodness of fit manually
y_pred_test = sim(model_arx, data_test.InputData);
fit_percent = 100 * (1 - norm(data_test.OutputData - y_pred_test)/norm(data_test.OutputData));
fprintf('Fit on test data: %.2f%%\n', fit_percent);

%% Step 8: Save the Model
save('microgas_model_arx.mat', 'model_arx');
