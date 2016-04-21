# process end to end

#' Execute cloud script
#'
#' @param script R script to be uploaded to workers
#' @param S3_BUCKET name of bucket
#' @param S3_SCRIPT name of script to run on workers
#' @param S3_DATA_OUT
#' @param S3_LOG_OUT
#' @param ...
#'
#' @return NULL
#' @export
#'
execCloudAWS<-function(script,
                    S3_BUCKET="auunconfdt",
                    S3_SCRIPT="script.R",
                    S3_DATA_OUT="data.Rdata",
                    S3_LOG_OUT="out.txt", ...){

  KEY_ID=Sys.getenv("AWS_ACCESS_KEY_ID")
  KEY_SECRET=Sys.getenv("AWS_SECRET_ACCESS_KEY")
  REGION=Sys.getenv("AWS_DEFAULT_REGION")

  userData<-paste0('#!/bin/sh

                   touch /tmp/I_AM_ALIVE

                   apt-get update
                   apt-get install -y awscli

                   mkdir /root/.aws
                   echo "
                   [default]
                   region = ',REGION,'
                   aws_secret_access_key = ',KEY_SECRET,'
                   aws_access_key_id = ',KEY_ID,'
                   " > /root/.aws/config

                   cp -r /root/.aws/ /home/ubuntu/.aws/

                   touch /tmp/I_AM_ALIVE2

                   aws s3 cp s3://',S3_BUCKET,'/',S3_SCRIPT,' /tmp/local.R --region ',REGION,'

                   touch /tmp/I_AM_ALIVE3

                   R BATCH --no-save < /tmp/local.R > /tmp/out.txt

                   aws s3 cp /tmp/data.Rdata s3://',S3_BUCKET,'/',S3_DATA_OUT,'
                   aws s3 cp /tmp/out.txt s3://',S3_BUCKET,'/',S3_LOG_OUT,'

                   ');

  put_object(file=script, bucket = S3_BUCKET, object = S3_SCRIPT)


  instance <- startInstance(userData = userData, ...)

  #wait until finished
  #terminate_instances
  #get data

}
