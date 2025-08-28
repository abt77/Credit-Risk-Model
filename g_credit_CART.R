german_credit = read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data")
colnames(german_credit) = c("chk_acct", "duration", "credit_his", "purpose", "amount", "saving_acct", "present_emp", "
  installment_rate", "sex", "other_debtor", "present_resid", "property", "age", "other_install", "housing", "n_credits", "job", "n_people", "telephone", "foreign", 
  "response")
german_credit$response = german_credit$response - 1
str(german_credit)

##

german_credit$chk_acct<- as.factor(german_credit$chk_acct)
german_credit$credit_his<- as.factor(german_credit$credit_his)
german_credit$purpose<- as.factor(german_credit$purpose)
german_credit$saving_acct<- as.factor(german_credit$saving_acct)
german_credit$present_emp<- as.factor(german_credit$present_emp)
german_credit$other_debtor <- as.factor(german_credit$other_debtor)
german_credit$property <- as.factor(german_credit$property)
german_credit$other_install <- as.factor(german_credit$other_install)
german_credit$housing <- as.factor(german_credit$housing)
german_credit$job <- as.factor(german_credit$job)
german_credit$telephone <- as.factor(german_credit$telephone)
german_credit$foreign <- as.factor(german_credit$foreign)
german_credit$response <- as.factor(german_credit$response)
subset = sample(nrow(german_credit), nrow(german_credit) * 0.8)
german_train = german_credit[subset, ]
german_test = german_credit[-subset, ]
summary(german_train)

##

library(rpart)
library(rpart.plot)
library(dplyr)
german_rpart <- rpart(formula = response ~ chk_acct + duration + credit_his + sex + other_debtor + property + age + other_install + housing + n_credits + telephone + foreign, data = german_train, method ="class" , parms = list(loss=matrix(c(0,5,1,0), nrow = 2)))
german_rpart
summary(german_rpart)
prp(german_rpart, extra = 1)

## In-sample prediction

pred_grpart <- predict(german_rpart, german_train, type = "class")
pred_grpart
t1 <- table(german_train$response, pred_grpart, dnn = c("True", "Pred"))
t1

#Misclassification error

1-(sum(diag(t1))/sum(t1))

#Out of sample prediction
pred_grpart1 <- predict(german_rpart, german_test, type = "class")
pred_grpart1
t2 <- table(german_test$response, pred_grpart1, dnn = c("True", "Pred"))
t2

#Misclassification error

1-(sum(diag(t2))/sum(t2))

## In-sample misclassification cost

cost <- function(r, phat){
  weight1 <- 5
  weight0 <- 1
  pcut <- weight0/(weight1+weight0)
  c1 <- (r==1)&(phat<pcut)
  c0 <-(r==0)&(phat>pcut)
  return(mean(weight1*c1+weight0*c0))}
cost
cost(german_train$response, predict(german_rpart, german_train, type="prob"))

##
cost1 <- function(r, phat){
  weight1 <- 5
  weight0 <- 1
  pcut <- weight0/(weight1+weight0)
  c1 <- (r==1)&(phat<pcut)
  c0 <-(r==0)&(phat>pcut)
  return(mean(weight1*c1+weight0*c0))}
cost1
cost1(german_test$response, predict(german_rpart, german_test, type="prob"))
cost2 <- function(r, phat){
  weight1 <- 1
  weight0 <- 1
  pcut <- weight0/(weight1+weight0)
  c1 <- (r==1)&(phat<pcut)
  c0 <-(r==0)&(phat>pcut)
  return(mean(weight1*c1+weight0*c0))}
cost2(german_test$response, predict(german_rpart, german_test, type="prob"))

#AUC
library(ROCR)
pred_grpart2 <- predict(german_rpart, german_test, type = "prob")
pred_grpart2
pred = prediction(pred_grpart2[,2], german_test$response)
perf = performance(pred, "tpr", "fpr")
plot(perf, colorize = TRUE)
slot(performance(pred, "auc"), "y.values")[[1]]
