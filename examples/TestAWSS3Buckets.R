#INSTALL CLOUDYR

#if(!require("drat")) install.packages("drat")
#drat::addRepo("cloudyr")
#install.packages("aws.s3")

# library("aws.s3")

#
# bucketlist()
# #Generate data to test push to and from S3
# nRows<-100;
# nCols<-10
# x<-matrix(rnorm(nRows*nCols),nrow=nRows,ncol=nCols)
# write.csv(x,'testX.csv')
#
# #Find data on S3
# bucketlist()
#
# #trying to get data to S3
# # s3save(x, bucket = "mjktestbucketmsf", object = "x.Rdata")

## THIS WORKS

my_bucket <- get_bucket("jcarroll1")

s3save(x, object="x", bucket=my_bucket)

y <- get_object("x", bucket=my_bucket)

load(rawConnection(y))


# save_object(bucket=my_bucket, object="x", file="myX.RData")

# get_object('testX.csv' , bucket = "mjktestbucketmsf")
# put_object(file='testX.csv', bucket = "mjktestbucketmsf", object = "x.Rdata")
#
#
#
# ##############EXAMPLES FROM  Cloudyr documentation
# #https://github.com/cloudyr/aws.s3
# # save an in-memory R object into S3
# s3save(mtcars, bucket = "my_bucket", object = "mtcars.Rdata")
#
# # `load()` R objects from the file
# s3load("mtcars.Rdata", bucket = "my_bucket")
#
# # get file as raw vector
# get_object("mtcars.Rdata", bucket = "my_bucket")
#
# # save file locally
# save_object("mtcars.Rdata", file = "mtcars.Rdata", bucket = "my_bucket")
#
# # put local file into S3
# put_object(file = "mtcars.Rdata", object = "mtcars2.Rdata", bucket = "my_bucket")
#
#
#
#
