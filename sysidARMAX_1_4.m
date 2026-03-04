%% Load Data
train_data = readtable('ex_1.csv');
test_data = readtable('ex_4.csv');

u_train = [train_data.time, train_data.input_voltage];
y_train = train_data.el_power;

u_test = [test_data.time, test_data.input_voltage];
y_test = test_data.el_power;

Ts = 1;  % Sampling time
data_train = iddata(y_train, u_train, Ts);
data_test = iddata(y_test, u_test, Ts);

%% Define Model Orders
na = 2;
nb = [2 2];
nk = [1 1];
nc = 2;
nd = 2;
nf = [2 2];

%% Train ARX Model
model_arx = arx(data_train, [na nb nk]);
y_arx = sim(model_arx, data_test.InputData);

%% Train ARMAX Model
model_armax = armax(data_train, [na nb(1) nb(2) nc nk(1) nk(2)]);
y_armax = sim(model_armax, data_test.InputData);

%% Train BJ Model (Corrected Format)
model_bj = bj(data_train, [nb nc nd nf nk]);
y_bj = sim(model_bj, data_test.InputData);

%% Train OE Model
model_oe = oe(data_train, [nf nb nk]);
y_oe = sim(model_oe, data_test.InputData);

%% Compute Time Domain Fit Percentages
fit_arx = 100 * (1 - norm(y_test - y_arx) / norm(y_test));
fit_armax = 100 * (1 - norm(y_test - y_armax) / norm(y_test));
fit_bj = 100 * (1 - norm(y_test - y_bj) / norm(y_test));
fit_oe = 100 * (1 - norm(y_test - y_oe) / norm(y_test));

fprintf('\nModel Fit Percentages on Test Data:\n');
fprintf('ARX   : %.2f%%\n', fit_arx);
fprintf('ARMAX : %.2f%%\n', fit_armax);
fprintf('BJ    : %.2f%%\n', fit_bj);
fprintf('OE    : %.2f%%\n', fit_oe);

%% Plot Output Comparison (Time Domain)
figure;
compare(data_test, model_arx, model_armax, model_bj, model_oe);
legend('Actual','ARX','ARMAX','BJ','OE');
title('Model Comparison - Output vs Actual');

%% Residual Analysis (All Models)
figure;
subplot(2,2,1); resid(data_test, model_arx); title('ARX Residual');
subplot(2,2,2); resid(data_test, model_armax); title('ARMAX Residual');
subplot(2,2,3); resid(data_test, model_bj); title('BJ Residual');
subplot(2,2,4); resid(data_test, model_oe); title('OE Residual');

%% Power Spectral Density of Residuals (Example: ARX)
e_arx = y_test - y_arx;
figure;
pwelch(e_arx); % Power spectral density
title('PSD of ARX Residuals');

%% One-Step Ahead Prediction (Example: ARX)
figure;
compare(data_test, model_arx, 1);  % 1 = OSA
title('ARX One-Step Ahead Prediction');



