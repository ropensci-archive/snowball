#INSTALL CLOUDYR

#if(!require("drat")) install.packages("drat")
#drat::addRepo("cloudyr")
#install.packages("aws.s3")

library("aws.s3")


Sys.setenv("AWS_ACCESS_KEY_ID" = "[ACCESSKEY]",
           "AWS_SECRET_ACCESS_KEY" = "[SECRETKEY]",
           "AWS_DEFAULT_REGION" = "eu-west-1")

bucketlist()
#Generate data to test push to and from S3
nRows<-100;nCols<-10
x<-matrix(rnorm(nRows*nCols),nrow=nRows,ncol=nCols)
write.csv(x,'testX.csv')

#Find data on S3
bucketlist()

#trying to get data to S3
s3save(x, bucket = "mjktestbucketmsf", object = "x.Rdata")
get_object('testX.csv' , bucket = "mjktestbucketmsf")
put_object(file='testX.csv', bucket = "mjktestbucketmsf", object = "x.Rdata")



##############EXAMPLES FROM  Cloudyr documentation
#https://github.com/cloudyr/aws.s3
# save an in-memory R object into S3
s3save(mtcars, bucket = "my_bucket", object = "mtcars.Rdata")

# `load()` R objects from the file
s3load("mtcars.Rdata", bucket = "my_bucket")

# get file as raw vector
get_object("mtcars.Rdata", bucket = "my_bucket")

# save file locally
save_object("mtcars.Rdata", file = "mtcars.Rdata", bucket = "my_bucket")

# put local file into S3
put_object(file = "mtcars.Rdata", object = "mtcars2.Rdata", bucket = "my_bucket")




