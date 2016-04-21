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
#' startInstance()
#' }
startInstance <- function(ami="ami-1170382b",
                          type="t2.micro",
                          subNet=-1,
                          securityGroup=-1,
                          keyName=-1,
                          userData="",
                          keypair="") {
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
                     keypair=keypair)
  return(i)

}
