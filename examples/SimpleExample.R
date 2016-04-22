# Run a quick Support Vector Machine to predict the iris species.
# depends: (caret)


SimpleExample<-function(data){

ctrl <- caret::trainControl(method = "cv", savePred=T, classProb=T)

mod  <- caret::train(Species~., data=data_location, method = "svmLinear", trControl = ctrl)

return(mod)
}
