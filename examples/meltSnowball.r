## this code will be sent as UserData to worker nodes.
## it checks the schedule and if this machine is scheduled,
## gathers the requisite parts of the snowball and melts them
## together, runs the code, and outputs

## get/load purrr for purrr::safely
## get/load cloudyr/aws.s3 for in/out on S3
pacman::p_load(purrr, aws.s3)

## bucket name that the schedule will be in
bucket <- Sys.getenv("BUCKET")

## this worker's instance id
instanceID <- Sys.getenv("INSTANCEID")

## verify that the bucket is available
all_buckets <- bucketlist()
if (length(all_buckets)==0) bucket_exists <- FALSE
if (length(all_buckets)==1) {
  bucket_exists <- bucket %in% all_buckets$Name
} else if (length(all_buckets)>1) {
  bucket_exists <- any(bucket %in% unlist(lapply(1:length(all_buckets), function(x) all_buckets[[x]]$Name)))
}
if(!bucket_exists) return("SNOWMAN BUCKET NOT AVAILABLE")

## get the bucket as an object
snowball_bucket <- get_bucket(bucket)

## download the schedule
snowman_schedule <- get_object("snowman.rds", bucket=snowball_bucket)
load(rawConnection(snowman_schedule))

## SNOWMAN IS EXPECTED TO BE A DATA.FRAME OF THE FOLLOWING FORMAT
##
## WORKERID | INSTANCEID | FUNCTION | X | DATA | OUTPUT | DOTS
##

## check the schedule and existence of output, taking the first entry for this worker
my_jobs <- snowman[snowman$INSTANCEID==instanceID, ]

if (nrow(my_jobs)==0) return("NO JOBS REQUESTED") # no work to do, return
if (nrow(my_jobs)>1) my_jobs <- my_jobs[1,] ## only deal with the first job for now

## make sure that this worker's bucket is available
if (length(all_buckets)==0) my_bucket_exists <- FALSE
if (length(all_buckets)==1) {
  my_bucket_exists <- my_jobs$BUCKET %in% all_buckets$Name
} else if (length(all_buckets)>1) {
  my_bucket_exists <- any(my_jobs$BUCKET %in% unlist(lapply(1:length(all_buckets), function(x) all_buckets[[x]]$Name)))
}
if(!my_bucket_exists) return("BUCKET FOR JOB DOES NOT EXIST")

## try to get the results file from S3
my_output_obj <- head_object(paste0(my_jobs$OUTPUT, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)

## if there is no output already, run the calculations
if(is.null(attr(my_output_obj, "etag"))) {

  ## download the function for this worker
  my_function_obj_exists <- get_head(paste0(my_jobs$FUNCTION, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
  if (is.null(attr(my_function_obj_exists, "etag"))) {
    my_function_obj <- get_object(paste0(my_jobs$FUNCTION, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
    load(rawConnection(my_function_obj))
  }

  ## download the data for this worker
  my_data_obj_exists <- get_head(paste0(my_jobs$DATA, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
  if (is.null(attr(my_data_obj_exists, "etag"))) {
    my_data_obj <- get_object(paste0(my_jobs$DATA, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
    load(rawConnection(my_data_obj))
  }

  ## safely evaluate the function
  safefn <- safely(as.function(eval(my_jobs$FUNCTION)))
  return_from_fn <- safefn(my_jobs$DATA, my_jobs$x, my_jobs$DOTS)

  ## write the output to S3 (result if successful, error if not)
  if(is.null(return_from_fn$error)) {
    s3save(return_from_fn$result, object=paste0(my_jobs$OUTPUT, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
  } else {
    s3save(return_from_fn$error, object=paste0(my_jobs$OUTPUT, "_", my_jobs$WORKERID, ".rds"), bucket=my_jobs$BUCKET)
  }

  return("COMPLETED JOB")

}
