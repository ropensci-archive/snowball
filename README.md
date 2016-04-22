
# [snowball](https://github.com/ropenscilabs/snowball)
An R package to do parallel processing on Amazon, (more) easily.
Born 2016, at the [Brisbane ROpenSci Unconference][52d207af]  .

<img align="center" src="misc/CHsnowballs.gif">

  [52d207af]: http://auunconf.ropensci.org "Brisbane Unconference"

Authors:
- [Dan Pagendam](https://github.com/dpagendam)
- [Jonathan Carroll](https://github.com/jonocarroll)
- [Daniel Thomas](https://github.com/daniel-t)
- [Cameron Roach](https://github.com/camroach87?tab=activity)
- [Felix Leung](https://github.com/felixleungsc)
- [Zoé van Havre](https://github.com/zoevanhavre/)
- Suren Rathnayake

> Automatically sets up and starts a cluster of AWS workers, doing parallel processing, and saving the compiled output.

```r
devtools::install_github("ropenscilabs/snowball")
```
# WARNING:  _Check yourself, before you wreck yourself!_  You are the ruler of your own Amazon costs.(AKA: no responsibility taken for your AWS bill...)

<img align="center" src="misc/snowman1.jpg">

`snowball` takes the location of data, a user defined function, and some basic instructions to set up and run  virtual machines in parallel on Amazon, and save results in an S3 bucket.


### Overview

Key Inputs: what do you need to use `snowball`
- An AWS account, with:
  - IAM user with permissions to manage EC2 and S3.
  - API keys for the IM account.
  - an S3 bucket
    - with bucket policy allowing an IAM user full access
- Data location.
- AWS acount _user Data_ and _keypair_
- Number of workers (virtual machines) to run
- RAM of each worker
- Name of __S3 bucket__ to create or find.



What `snowball` does:
1. put job list to S3 and data to S3 (job list is like a job roster, a data table with names of workers and functions and   )
2. Spin Up  all workers start monitoring S3
3. `snowball(function, bucketName, ...)`
  - snowball calls snowpack'
  - this writes the snowpack function that will be run on each worker.


# How to

## 1.  Pack the snowball.
> Start an AWS instance with buckets, while setting up the data/feature split

```r
snowpack(user_function, listItem, bucketname, rdsInput, rdsOut)

```

## 2. Throw the snowball.
> Give data location and user function


```r
throwSnow(...)
```

## 3. Avalanche the outputs.
> combine all results into one file

```r
avalanche(...)
```

```r
snowpack(fn, listItem, bucketNameString, rdsInputObjectString, rdsOutputString)
```


## More help?
<img align="center" src="misc/CHsnowballs.gif">

![http://finaldestination.wikia.com/wiki/File:Olivia_help_me.gif]

#### S3 Bucket..??

We assume you have a (very) basic understanding of  what an S3 Bucket is. (Here it is: it's like dropbox, for data. mind blown aye...) [Click here for info from Amazon.](https://docs.aws.amazon.com/AmazonS3/latest/UG/CreatingaBucket.html). It is super easy to create a bucket. You just click `create bucket`.

Setting up the 'bucket policy allowing an IAM user full access' is harder:
  - In the top left of an AWS window click on `Services`, then `IAM`, then click on the user you want to give access to (you, most likely).
  - copy the User ARN into your clipboard.
  - go to the newly created bucket, click on `Properties`
     - click on `add policy`, which opens a window called "AWS Policy Generator"
       - Select policy type: **S3 Bucket Policy**
       - AWS Services should be **Amazon S3**,
       - Actions: tick `All Actions`.
       - Paste your ARN into principal (I know... logical.)
       - Paste this (with YOUR bucket name) into the ARN box: `arn:aws:s3:::bucketName`
     - Click `Add Statement`, copy the contents to clipboard.
     Go back to bucket page, click "Edit bucket policy" and paste clipboard into this.
