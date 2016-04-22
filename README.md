# [snowball](https://github.com/ropenscilabs/snowball)
An R package to do parallel processing on Amazon, (more) easily.
Born 2016, at the [Brisbane ROpenSci Unconference][52d207af]  .

  [52d207af]: http://auunconf.ropensci.org "Brisbane Unconference"

Authors:
- [Dan Pagendam](https://github.com/dpagendam)
- [Jonathan Carroll](https://github.com/JonoCarroll)
- [Daniel Thomas](https://github.com/daniel-t)
- [Cameron Roach](https://github.com/camroach87)
- [Felix Leung](https://github.com/felixleungsc)
- [Zoé van Havre](https://github.com/zoevanhavre/)
- Suren Rathnayake

> Automatically sets up and starts a cluster of AWS workers, doing parallel processing, and saving the compiled output.

```r
devtools::install_github("ropenscilabs/snowball")
```

`snowball` takes the location of data, a user defined function, and some basic instructions to set up and run  virtual machines in parallel on Amazon, and save results in an S3 bucket.


### Overview

Key Inputs: what do you need to use `snowball`
- An AWS account, with:
  - IM user with permissions to manage EC2 and S3.
  - API keys for the IM account.
  - an S3 bucket
- Data location.
- AWS acount _user Data_ and _keypair_
- Number of workers (virtual machines) to run
- RAM of each worker
- Name of __S3 bucket__ to create or find.

