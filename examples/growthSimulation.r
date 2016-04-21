# simulation example where the problem is easy to split up
# Growth model simulation using gompertz equations


simmulate<-function(scenario,ndays,nunits,pars,vars){
  gm<-data.frame(scenario=c(),unit=c(),day=c(),gth=c())
  for (i in 1:nunits){
    growth <- gompertz(0:mxday, 400+rnorm(1,0,vars[1]), 6+rnorm(1,0,vars[2]), 0.0061+rnorm(1,0,vars[3])) 
    gm<-rbind(gm,data.frame(rep=rep(scenario,length(growth)),unit=i,day=0:mxday,gth=growth))
  }
  
    return(gm)
}

#print (simmulate)
#install.packages('growthmodels')
#library(growthmodels)
mxday<-1000
nUnits<-10
pars<-c(400,6,0.0061)
sds<-pars/10


tmp<-data.frame(scenario=c(),unit=c(),day=c(),gth=c())
scenarios<-c('a','b','c')
for (scenario in scenarios){
  print (scenario)
  results<-simmulate(scenario,mxday,nUnits,pars,sds)
  tmp<-rbind(tmp,results)
    
}

#ggplot(tmp,aes(y=gth,x=day,col=unit))+geom_point()+facet_wrap(~rep)
#ggplot(tmp,aes(y=gth,x=day,col=unit))+geom_smooth(se=TRUE)+facet_wrap(~rep)
