## this code will be sent as UserData to worker nodes.
## it checks the schedule and if this machine is scheduled,
## gathers the requisite parts of the snowball and melts them
## together, runs the code, and outputs

## get/load purrr for purrr::safely
## get/load cloudyr/aws.s3 for in/out on S3
# pacman::p_load(purrr, aws.s3)
library(purrr)
library(aws.s3)

## bucket name that the schedule will be in
bucket <- Sys.getenv("BUCKET")
cat(paste0("bucket = ",bucket))

## this worker's instance id
instanceID <- Sys.getenv("INSTANCEID")
cat(paste0("instanceID = ",instanceID))

## verify that the bucket is available
all_buckets <- bucketlist()
cat("all_buckets = ")
print(all_buckets)
if (length(all_buckets)==0) bucket_exists <- FALSE
if (length(all_buckets)==1) {
  bucket_exists <- bucket %in% all_buckets$Name
} else if (length(all_buckets)>1) {
  bucket_exists <- any(bucket %in% unlist(lapply(1:length(all_buckets), function(x) all_buckets[[x]][["Name"]])))
}
if(!bucket_exists) return("SNOWMAN BUCKET NOT AVAILABLE")

## get the bucket as an object
snowball_bucket <- get_bucket(bucket)

cat(paste0("bucket exists? ", bucket_exists))
