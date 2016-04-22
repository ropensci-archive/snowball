devtools::install_github("ropenscilabs/snowball")
library(snowball)

snowball_setup()

tmpinst <- startInstance()

describe_instances(tmpinst$item$instanceId[[1]])

instance_status(tmpinst$item$instanceId[[1]])

stop_instances(tmpinst$item$instanceId[[1]])
