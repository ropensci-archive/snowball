# Run a quick Support Vector Machine to predict the iris species.
# depends: (caret)


SimpleExample<-function(Data){

ctrl <- caret::trainControl(method = "cv", savePred=T, classProb=T)

mod  <- caret::train(Data[,1]~., data=Data, method = "svmLinear", trControl = ctrl)

return(mod)
}
