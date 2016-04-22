## A SIMPLE SNOWMAN
## SNOWMAN IS EXPECTED TO BE A DATA.FRAME OF THE FOLLOWING FORMAT
## WORKERID | INSTANCEID | BUCKET | FUNCTION | X | DATA | OUTPUT | DOTS
n_workers <- 3
snowman <- data.frame("WORKERID" = 1:n_workers,
                      "INSTANCEID" = NA,
                      "BUCKET" = NA,
                      "FUNCTION" = NA,
                      "X" = NA,
                      "DATA" = NA,
                      "OUTPUT" = NA,
                      "DOTS" = NA)
myf <- function(x) paste0(tolower(names(snowman))[x], "_", snowman$WORKERID, ".rds")
snowman[, 3:length(snowman)] <- sapply(3:length(snowman), myf)

# start some instances
n_instances <- 3
instances <- run_instances("ami-36290455", type = "t2.micro", min = n_instances, keypair = "MY_KEY_PAIR")
for (i in 1:n_instances ) {
    start_instances(instances[[i]])
}
snowman$INSTANCEID <- sapply(1:n_instances, function(x) instances[x]$item$instanceId) %>% unlist


# get bucket; move snowman to bucket
my_bucket <- get_bucket("MY_BUCKET")
s3save(snowman, bucket = "MY_BUCKET", object = "snowman.rds")
