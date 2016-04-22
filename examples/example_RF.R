
# Example of using Random Forests in Snowball

RF_snowball <- function(paramList)
{
  s3BucketName = paramList[[1]]
  s3FileName = paramList[[2]]
  s3OutputPrefix = paramList[[3]]
  outputFileIndex = paramList[[4]]
  outputFileExtension = paramList[[5]]
  responseName = paramList[[5]]
  featureNames = paramList[[6]]
  ntree =
  mtry =
  replace =
  sampsize =
  nodesize =
  maxnodes =

  list.of.packages <- c("randomForest")
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)

  bucketlist()
  get_object('testX.csv' , bucket = "mjktestbucketmsf")

  thisForest = randomForest()
  outputFileName = paste0(s3OutputPrefix, "_", outputFileIndex, ".", outputFileExtension)
  s3save(thisForest, bucket = s3BucketName, object = outputFileName)
}
