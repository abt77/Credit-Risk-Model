# Credit-Risk-Model

##Summary##

Developed a decision tree classification model on the UCI German Credit dataset to predict the likelihood of credit default. The model incorporated financial and demographic factors such as account status, credit history, age, and housing. Both in-sample and out-of-sample performance were evaluated using misclassification error, cost-sensitive metrics, and AUC.

##Tools Used##
R (rpart, ROCR, dplyr, rpart.plot)
Data Preparation: Factor encoding, train-test split (80/20)
Modeling: Decision Trees with cost-sensitive learning
Evaluation: Misclassification error, weighted cost functions, ROC curve, AUC

##Key Findings##
Built a decision tree model incorporating class weights to penalize false negatives (predicting “low risk” when borrower is actually “high risk”).
Achieved reasonable predictive performance:
Train Misclassification Error: ~ 0.34125
Test Misclassification Error: ~ 0.38
AUC: ~ 0.7628667
Cost-sensitive evaluation showed the model performed better at avoiding risky approvals when false negatives were penalized more heavily.
Model outputs and plots provided interpretability for credit decisioning.Developed a decision tree classification model on the UCI German Credit dataset to predict the likelihood of credit default.
