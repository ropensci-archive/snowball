#' Start an AWS instance
#'
#' @param ami
#' @param type
#' @param subNet
#' @param securityGroup
#' @param keyName
#' @param userData
#'
#' @return NULL
#' @export
#'
#' @examples
#'
#' \dontrun{
#' my_instance <- startInstance()
#' instance_status(my_instance$item$instanceId[[1]])
#' }
# startInstance <- function(ami="ami-1170382b",
startInstance <- function(ami="ami-36290455",
                          type="t2.micro",
                          subNet=-1,
                          securityGroup=-1,
                          userData="",
                          keypair=NULL) {
  # library(aws.ec2)

  #describe_images(ami)

  if (subNet==-1) {
    subNet <- describe_subnets()[[1]]
  }

  if (securityGroup==-1) {
    securityGroup <- describe_sgroups()[[1]]
  }

  if (userData!=""){
    userData=base64enc::base64encode(charToRaw(userData))
  }

  i <- run_instances(image    = ami,
                     type     = type,
                     subnet   = subNet,
                     sgroup   = securityGroup,
                     userdata = userData,
                     IAMInstanceProfile = profile,
                     keypair  = keypair)

  message(paste0("Starting a ",i$item$instanceType[[1]]," instance, id ",i$item$instanceId[[1]]))

  return(i)

}


#' List contents of a S3 bucket
#'
#' @param bucket
#'
#' @return vector of data.frame contents
#' @export
#'
#' @examples
#' \dontrun{
#' my_bucket <- get_bucket("bucketName")
#' bucket_contents(my_bucket)
#' }
bucket_contents <- function(bucket) {

  lapply(my_bucket, function(x) x[["Key"]]) %>% unlist %>% unname

}

## save_to_s3

# s3save(x, object="x", bucket=my_bucket)

#' Load an object from S3
#'
#' @param object_name name of object to be retrieved
#' @param bucket a s3_bucket object or character string of such
#'
#' @return NULL
#' @export
#'
load_from_s3 <- function(object_name, bucket) {
  y <- get_object(object_name, bucket=bucket)
  load(rawConnection(y))
  return(NULL)
}

#' Perform snowball setup
#'
#' @param config_file location of the configuration file, default ~/.snowball
#'
#' @return NULL if echo=FALSE, otherwise prints config details
#' @export
#'
#' @examples
#' \dontrun{
#' snowball_setup()
#' }
snowball_setup <- function(config_file="~/.snowball", echo=TRUE) {

  # Sys.setenv("AWS_ACCESS_KEY_ID" = "AKIAJLWGSIXBG27YXL5Q",
  #            "AWS_SECRET_ACCESS_KEY" = "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",
  #            "AWS_DEFAULT_REGION" = "ap-southeast-2")

  if(file.exists(config_file)) {
    config <- read.dcf(config_file, fields=c("AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION"))
    Sys.setenv(AWS_ACCESS_KEY_ID = config[, "AWS_ACCESS_KEY_ID"])
    Sys.setenv(AWS_SECRET_ACCESS_KEY = config[, "AWS_SECRET_ACCESS_KEY"])
    Sys.setenv(AWS_DEFAULT_REGION = config[, "AWS_DEFAULT_REGION"])
  } else {
    warning("PLEASE ADD A ~/.snowball FILE WITH CONFIGURATION\n
            AWS_ACCESS_KEY_ID: <YOURACCESSSKEYID>\n
            AWS_SECRET_ACCESS_KEY: <YOURSECRETACCESSKEY>\n
            AWS_DEFAULT_REGION: <YOURDEFAULTREGION>")
  }

  if (echo) {
    print(toJSON(as.list(Sys.getenv(c("AWS_ACCESS_KEY_ID",
                                      "AWS_SECRET_ACCESS_KEY",
                                      "AWS_DEFAULT_REGION"))), pretty = TRUE))
  }

  return(NULL)

}
