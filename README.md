This project focuses on the mathematical modeling of a Micro Gas Turbine (MGT) system to predict electrical power output based on multi-variable inputs. It demonstrates the application of **System Identification** techniques using MATLAB.

### Full Technical Presentation & Results
👉 [**View on Canva**](https://www.canva.com/design/DAGqmsMVPaA/1AHGY_kep3kPd9AFVA-mxw/edit?utm_content=DAGqmsMVPaA&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton)

### 1. Project Overview
The goal was to develop a high-accuracy dynamic model for a gas turbine system. Using the UCI Machine Learning Repository dataset, I performed a comparative analysis of different linear model structures to find the best fit for predicting power generation under varying environmental conditions.

### 2. Technical Stack
* **Software:** MATLAB (System Identification Toolbox)
* **Dataset:** Micro Gas Turbine Operational Data (Ambient Temp, Pressure, Humidity, Exhaust Vacuum)
* **Model Structures:** ARX, **ARMAX**, Box-Jenkins (BJ), and Output-Error (OE).

### 3. Implementation & Methodology
I implemented a **MIMO (Multi-Input Multi-Output)** approach to model the system dynamics. My primary focus was on the **ARMAX** (AutoRegressive Moving Average with eXogenous inputs) structure:

* **Model Order Selection:** Defined optimal orders ($n_a=2, n_b=[2, 2], n_c=2$) to balance model complexity and predictive accuracy.
* **Estimation:** Used the `armax()` function in MATLAB to train the model on 70% of the dataset, with 30% reserved for validation.
* **Comparison:** Evaluated models based on **Best Fit Percentage**, Mean Squared Error (MSE), and Residual Analysis (whiteness test).

### 4. Key Engineering Insights
* **Dynamic Response:** Identified that the ARMAX model provided a superior fit compared to simple ARX models because it accounted for the colored noise in the turbine's sensor data.
* **System Stability:** Verified the poles and zeros of the estimated transfer functions to ensure the model accurately represented a stable physical system.
