#' Perform snowball setup. Read AWS key pair from file.
#'
#' @param config_file location of the configuration file, default ~/.snowball
#'
#' @param echo if TRUE print the credentials read from the file to the console.
#'
#' @return TRUE if config sucessfully read and set. False if file could not be found.
#' @export
#'
#' @examples
#' \dontrun{
#' snowball_setup()
#' }
snowball_setup <- function(config_file="~/.snowball", echo=FALSE) {

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

  if(echo) {
    print(toJSON(as.list(Sys.getenv(c("AWS_ACCESS_KEY_ID",
                                      "AWS_SECRET_ACCESS_KEY",
                                      "AWS_DEFAULT_REGION"))), pretty = TRUE))
  }

  return(NULL)

}
