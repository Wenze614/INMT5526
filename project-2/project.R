audi = read.csv("./audi.csv")
install.packages('randomForest')
install.packages('pacman')
install.packages('gsubfn')
pacman::p_load(pacman, tidyverse, gmodels,ROCR, rpart, rpart.plot,caret)
library(randomForest)
library(gsubfn)
summary(audi)

audi$model <- as.factor(sapply(audi$model,str_trim)) #remove whitespace in model name
audi$year <- as.factor(audi$year)
audi$transmission <- as.factor(audi$transmission)
audi$fuelType <- as.factor(audi$fuelType)
audi$engineSize <- as.factor(audi$fuelType)
normalise_func <- function(x) { (x - min(x)) / (max(x) - min(x))}
audi_rf_model <- function(dataset, modelname,partition,seed){
  dataset <- dataset %>% mutate(across(where(is.numeric), 
                                       normalise_func))
  set.seed(seed)
  selected_data <- dataset %>% filter(model==modelname)
  train <- createDataPartition(y=selected_data$price, p=partition, list=F)
  selected_data_train <- selected_data[train,]
  selected_data_test <- selected_data[-train,]
  rf <- randomForest(price~., data=selected_data_train,importance=T)
  result <- list(rf,selected_data_train,selected_data_test,selected_data)
  print(result)
  return(result)
}
audi_ann_model <- function(dataset, modelname,partition,seed){
  dataset <- dataset %>% mutate(across(where(is.numeric), 
                                                normalise_func))
  set.seed(seed)
  selected_data <- dataset %>% filter(model==modelname)
  train <- createDataPartition(y=selected_data$price, p=partition, list=F)
  selected_data_train <- selected_data[train,]
  selected_data_test <- selected_data[-train,]
  net <- train(price ~ .,selected_data_train, method = 'nnet', linout = TRUE, 
                            trace = FALSE)
  result <- list(net, selected_data_train, selected_data_test,selected_data)
  return(result)
}
#----------------------A3 rf Model----------------------------------------
list[audi_A3_rf,audi_A3_train,audi_A3_test,audi_A3] <- audi_rf_model(audi,'A3',0.8,42)
audi_A3_rf
plot(audi_A3_rf)
varImpPlot(audi_A3_rf)
audiA3_trainpred <- predict(audi_A3_rf, newdata=audi_A3_train)
audiA3_testpred <- predict(audi_A3_rf, newdata=audi_A3_test)
defaultSummary(data.frame(obs=audi_A3_train$price, pred=audiA3_trainpred))
defaultSummary(data.frame(obs=audi_A3_test$price, pred=audiA3_testpred))

predresult_A3 <- data.frame(obs = c(audi_A3_train$price,audi_A3_test$price),
                         pred = c(audiA3_trainpred,audiA3_testpred),
                         group = c(rep("Train", length(audiA3_trainpred)),
                                   rep("Test",length(audiA3_testpred))))
ggplot(predresult_A3, 
       aes(x = obs, y = pred, fill=group, color=group))+
  geom_point(shape=21,size=1)+
  geom_smooth(method='lm', se=F, size=1)+
  geom_abline(intercept=0, slope=1, size=1)
#----------------------A3 rf Model----------------------------------------

#----------------------A3 ANN Model---------------------------------------
list[audi_A3_net,audi_A3_train_net,audi_A3_test_net,audi_A3_net_data] <- audi_ann_model(audi,'A3',0.8,42)
audi_A3_net
plot(audi_A3_net)
audiA3_trainpred_net <- predict(audi_A3_net, newdata=audi_A3_train_net)
audiA3_testpred_net <- predict(audi_A3_net, newdata=audi_A3_test_net)
defaultSummary(data.frame(obs=audi_A3_train_net$price, pred=audiA3_trainpred_net))
defaultSummary(data.frame(obs=audi_A3_test_net$price, pred=audiA3_testpred_net))

predresult_A3_net <- data.frame(obs = c(audi_A3_train_net$price,audi_A3_test_net$price),
                            pred = c(audiA3_trainpred_net,audiA3_testpred_net),
                            group = c(rep("Train", length(audiA3_trainpred_net)),
                                      rep("Test",length(audiA3_testpred_net))))
ggplot(predresult_A3_net, 
       aes(x = obs, y = pred, fill=group, color=group))+
  geom_point(shape=21,size=1)+
  geom_smooth(method='lm', se=F, size=1)+
  geom_abline(intercept=0, slope=1, size=1)
#----------------------A3 ANN Model---------------------------------------


#----------------------Q3 Model-----------------------------------------

list[audi_Q3_rf,audi_Q3_train,audi_Q3_test,audi_Q3] <- audi_rf_model(audi,'Q3',0.8,42)
audi_Q3_rf
plot(audi_Q3_rf)
varImpPlot(audi_Q3_rf)
audiQ3_trainpred <- predict(audi_Q3_rf, newdata=audi_Q3_train)
audiQ3_testpred <- predict(audi_Q3_rf, newdata=audi_Q3_test)
defaultSummary(data.frame(obs=audi_Q3_train$price, pred=audiQ3_trainpred))
defaultSummary(data.frame(obs=audi_Q3_test$price, pred=audiQ3_testpred))

predresult_Q3 <- data.frame(obs = c(audi_Q3_train$price,audi_Q3_test$price),
                            pred = c(audiQ3_trainpred,audiQ3_testpred),
                            group = c(rep("Train", length(audiQ3_trainpred)),
                                      rep("Test",length(audiQ3_testpred))))
ggplot(predresult_Q3, 
       aes(x = obs, y = pred, fill=group, color=group))+
  geom_point(shape=21,size=1)+
  geom_smooth(method='lm', se=F, size=1)+
  geom_abline(intercept=0, slope=1, size=1)
#----------------------Q3 Model-----------------------------------------
#----------------------Q3 ANN Model---------------------------------------
list[audi_Q3_net,audi_Q3_train_net,audi_Q3_test_net,audi_Q3_net_data] <- audi_ann_model(audi,'Q3',0.8,42)
audi_Q3_net
plot(audi_Q3_net)
audiQ3_trainpred_net <- predict(audi_Q3_net, newdata=audi_Q3_train_net)
audiQ3_testpred_net <- predict(audi_Q3_net, newdata=audi_Q3_test_net)
defaultSummary(data.frame(obs=audi_Q3_train_net$price, pred=audiQ3_trainpred_net))
defaultSummary(data.frame(obs=audi_Q3_test_net$price, pred=audiQ3_testpred_net))

predresult_Q3_net <- data.frame(obs = c(audi_Q3_train_net$price,audi_Q3_test_net$price),
                                pred = c(audiQ3_trainpred_net,audiQ3_testpred_net),
                                group = c(rep("Train", length(audiQ3_trainpred_net)),
                                          rep("Test",length(audiQ3_testpred_net))))
ggplot(predresult_Q3_net, 
       aes(x = obs, y = pred, fill=group, color=group))+
  geom_point(shape=21,size=1)+
  geom_smooth(method='lm', se=F, size=1)+
  geom_abline(intercept=0, slope=1, size=1)
#----------------------Q3 ANN Model---------------------------------------

#----------------------RF based on all car models-----------------------------
hist(audi$price, breaks=50)

##-------------------data partition-------------------------
set.seed(42)
train <- createDataPartition(y=audi$price, p=0.8, list=F)
audi_train <- audi[train,]
audi_test <- audi[-train,]

##-------------------model training-------------------------
rf <- randomForest(price~., data=audi_train, importance=T)
rf
plot(rf)
importance(rf) #importance of features(independent variables)
varImpPlot(rf) #importance with plot
partialPlot(x = rf, pred.data = audi_train, x.var=mileage) #correlation between dependent variabl and independent variable

##-------------------prediction based on training data-------------
trainpred <- predict(rf, newdata = audi_train)
defaultSummary(data.frame(obs=audi_train$price, pred=trainpred))
plot(x=audi_train$price,y=trainpred,xlab='actual', ylab='prediction')
##-------------------compare with diagonal-------------------------
trainlinmod <- lm(trainpred ~ audi_train$price)
abline(trainlinmod,col='blue',lwd=2.5, lty='solid')
abline(a=0,b=1, col='red',lwd=2.5, lty='dashed')
legend('topleft',legend=c("Model","Base"), col=c('blue','red'), lwd=2.5, lty=c('solid','dashed'))

##-------------------prediction based on testing data-------------
testpred <- predict(rf, newdata = audi_test)
defaultSummary(data.frame(obs=audi_test$price, pred=testpred))
##-------------------compare with diagonal-------------------------
plot(x=audi_test$price, y=testpred, xlab='actual',ylab='prediction')
testlinmod <- lm(testpred ~ audi_test$price)
abline(testlinmod, col='blue',lwd=2.5, lty='solid')
abline(a=0,b=1, col='red',lwd=2.5, lty='dashed')

##-------------------full prediction result----------------------
predresult <- data.frame(obs = c(audi_train$price,audi_test$price),
                         pred = c(trainpred,testpred),
                         group = c(rep("Train", length(trainpred)),
                                   rep("Test",length(testpred))))
ggplot(predresult, 
       aes(x = obs, y = pred, fill=group, color=group))+
  geom_point(shape=21,size=1)+
  geom_smooth(method='lm', se=F, size=1)+
  geom_abline(intercept=0, slope=1, size=1)