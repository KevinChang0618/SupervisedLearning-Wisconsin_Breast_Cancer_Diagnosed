# Project Goal  
In this project, I would demonstrate Random Forest model to classify Cancer is Malignant(=1) or Benign (=0). After I build the preliminary random forest, I will tune my 
model and built the best random forest model. Last, I show the variables important plot to understand which variables are important.  

# Method  
1. At first, I train my first model and get 4.84% error rate and testing error rate is 4% which means our model is correct non-overfitting. And our train model's number of 
trees is 500, number of variables tried to split in each nodes is 5.  
- Where 5 come from? There is a rule of thumb. Usually, model use square root on number of variables, 30 in here, to get number of variables tried to split in each nodes. (sqrt(30) ~= 5)  
2. Later, I try bagging (use all number of variables tried to split in each nodes) on our model. I use 30 variables to split and build 100 trees. My testing error rate for new model is 7% which is worse than my original model.  

3. Tune the model. I build random forest from 1 variables to split in each nodes to 11 variables. Moreover, in every variables selection, I use lowest error rate to get optimal trees. Last, I get the best model with 3 variables tried to split in each nodes and 559 trees.  

4. Use best parameters to build best random forest model to get 4.4% error rate.  

5. Plot with variables important can help us to know top 5 variables seems more important than the others.  
![3](https://user-images.githubusercontent.com/67025904/134789107-8aee9877-3018-4d95-b1a3-8b62f2c47d23.jpg)

# Conclusion  
Random Forest model can build a robust model because Random Forest, unlike BAGGING, are trees de-correlated and prune the trees. On the other hand, Bagging trees uses the entire feature so numbers of trees may be strongly correlated.  In this project, after tuning, I have the best model with 3 variables tried to split in each nodes and 559 trees. Moreover, I find 'concave points worst' is the most important feature in the model. And 'concave points mean', 'radius worst', 'perimeter_worst', and 'area worst' are also important than remain variables.  

# Resource
Kaggle-Random Forest in Python(https://www.kaggle.com/raviolli77/random-forest-in-python)
