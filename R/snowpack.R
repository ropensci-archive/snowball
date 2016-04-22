# Snowpack is for wrapping a basic user function in all the other stuff
# that it needs to work with an S3 bucket and also implements some error checks
# The output of snowpack is a new function that actually gets run on the worker

# Create a tbl data_frame for the workerJobRoster
# instanceId
# functionName_RDS
# x
# dataName_RDS

snowpack <- function(fn, listItem, bucketNameString, rdsInputObjectString, rdsOutputString)
{

  snowpackFunction <- function()
  {
    # tryCatch statement
    {
      # Gets the input object from the S3 as RDS file
      my_bucket <- get_bucket(bucketNameString)
      y <- get_object(rdsInputObjectString, bucket=my_bucket)
      load(rawConnection(y))
    }

    # tryCatch statement
    {
      # run function fn with a list
      fn(listItem)
    }

    # tryCatch statement
    {
      # Puts the output object into the S3 bucket as RDS File
    }
  }
  s3save(snowpackFunction, object = snowpackFunction, bucket=my_bucket)
  (snowpackFunction)

}
