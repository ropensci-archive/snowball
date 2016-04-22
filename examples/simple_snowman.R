## A SIMPLE SNOWMAN
## SNOWMAN IS EXPECTED TO BE A DATA.FRAME OF THE FOLLOWING FORMAT
## WORKERID | INSTANCEID | BUCKET | FUNCTION | X | DATA | OUTPUT | DOTS
n_workers <- 3
snowman <- data.frame("WORKERID" = 1:n_workers,
                      "INSTANCEID" = NA,
                      "BUCKET" = NA,
                      "FUNCTION" = "function.rds",
                      "X" = "x.rds",
                      "DATA" = "data.rds",
                      "OUTPUT" = "output.rds",
                      "DOTS" = "dots.rds")
## things that are the same across workers
things_that_vary <- c("X", "OUTPUT")
rds_vary <- function(things_that_vary) paste0(tolower(things_that_vary), "_", snowman$WORKERID, ".rds")
snowman[, things_that_vary] <- sapply(things_that_vary, rds_vary)

# start some instances, then put the INSTANCEID's in the snowman$INSTANCEID
n_instances <- 3
instances <- run_instances("ami-36290455", type = "t2.micro", min = n_instances, keypair = "auunconf")
for (i in 1:n_instances ) {
    start_instances(instances[[i]])
}
snowman$INSTANCEID <- sapply(1:n_instances, function(x) instances[x]$item$instanceId) %>% unlist

## stop the instances
#for (i in 1:n_instances ) {
#    stop_instances(instances[[i]])
#}

# put everything the workers need to S3
my_function <- function(data, X) {
    mean(data[X, 1])
}
x_1 <- 1:50
x_2 <- 51:100
x_3 <- 101:150
snowman$BUCKET <- "auunconf-test-bucket"
s3save(my_function, bucket = "auunconf-test-bucket", object = "function.rds")
s3save(x_1, bucket = "auunconf-test-bucket", object = "x_1.rds")
s3save(x_2, bucket = "auunconf-test-bucket", object = "x_2.rds")
s3save(x_3, bucket = "auunconf-test-bucket", object = "x_3.rds")
s3save(iris, bucket = "auunconf-test-bucket", object = "data.rds")
s3save(snowman, bucket = "auunconf-test-bucket", object = "snowman.rds")

# get bucket to check
my_bucket <- get_bucket("auunconf-test-bucket")
snowball::bucket_contents(my_bucket) # check local bucket only
