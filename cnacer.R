## load data and drop last empty column
library(tidyverse)
breast_cancer = read.csv("data.csv")
breast_cancer$X <- NULL
breast_cancer$id <- NULL
head(breast_cancer)


## fix data columns name.
colnames(breast_cancer) <- c('diagnosis', 'radius_mean', 
                             'texture_mean', 'perimeter_mean', 'area_mean', 
                             'smoothness_mean', 'compactness_mean', 
                             'concavity_mean','concave_points_mean', 
                             'symmetry_mean', 'fractal_dimension_mean',
                             'radius_se', 'texture_se', 'perimeter_se', 
                             'area_se', 'smoothness_se', 'compactness_se', 
                             'concavity_se', 'concave_points_se', 
                             'symmetry_se', 'fractal_dimension_se', 
                             'radius_worst', 'texture_worst', 
                             'perimeter_worst', 'area_worst', 
                             'smoothness_worst', 'compactness_worst', 
                             'concavity_worst', 'concave_points_worst', 
                             'symmetry_worst', 'fractal_dimension_worst')

mutate(breast_cancer, diagnosis = recode(diagnosis,"M"="1",
                                         "B"="0")) -> breast_cancer

breast_cancer$diagnosis <- as.numeric(breast_cancer$diagnosis)
head(breast_cancer)

#Turn column "diagnosis" value from M/B to 1/0. It can help us to run the tree model.


# split train & test
set.seed(1)
n = nrow(breast_cancer) # 568
z = sample(n, 0.8*n) # 0.8 for train/ 0.2 for test

# rule of thumb : m ~= root(p)
p = ncol(breast_cancer) -1 # -diagnosis
p
sqrt(p) # No. of variables tried at each split: 5


library(randomForest)
set.seed(1)
train_RF = randomForest(as.factor(diagnosis)~., data= breast_cancer, subset= z) # -diagnosis
train_RF # error rate: 4.84%


# test model
yhat = predict(train_RF, newdata= breast_cancer[-z,], type="class")

table(yhat, breast_cancer$diagnosis[-z])
mean(yhat!= breast_cancer$diagnosis[-z]) # 4% error rate.


# adjust
set.seed(1)
train_RF = randomForest(as.factor(diagnosis)~., data= breast_cancer, subset= z, mtry= 30, ntree= 100)
train_RF # error rate: 4.62%


yhat = predict(train_RF, newdata= breast_cancer[-z,], type="class")

table(yhat, breast_cancer$diagnosis[-z])
mean(yhat!= breast_cancer$diagnosis[-z]) # 7% error rate. get worse than 5 variables,500 trees


# tune
set.seed(1)
n = nrow(breast_cancer)
z = sample(n, n*0.8)

ERRORRATE = rep(0,p) # p = 11 predictors. try every predictors to find the best random forest
optimaltrees = rep(0,p)

for(k in 1:p){
  train_RF = randomForest(as.factor(diagnosis)~., data= breast_cancer[z,], mtry= k)
  optimaltrees[k] = which.min(train_RF$err.rate) # In each variables selection, number with lowest mse = optimal trees.
  
  train_RF = randomForest(as.factor(diagnosis)~., data= breast_cancer[z,], mtry= k, ntree= optimaltrees[k])
  yhat = predict(train_RF, newdata = breast_cancer[-z,])
  
  ERRORRATE[k] = mean(yhat!= breast_cancer$diagnosis[-z])
  plot(train_RF$err.rate)
}



which.min(ERRORRATE) # 3
optimaltrees[3]
optimaltrees # HOW MANY TREE FOR EACH VARIABLE SPLIT


# fit best random forest trees
set.seed(1)
best_RF = randomForest(as.factor(diagnosis)~., data= breast_cancer[z,], mtry= 3, ntree= 559) 
best_RF # 4.4% error rate


yhat = predict(best_RF, newdata= breast_cancer[-z,], type="class")

table(yhat, breast_cancer$diagnosis[-z])
mean(yhat!= breast_cancer$diagnosis[-z]) 


importance(best_RF) 
varImpPlot(best_RF)