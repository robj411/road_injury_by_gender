
rm(list=ls())
## get data
subavc <- readRDS('stats19_data.Rds')
nrow(subavc)
length(unique(subavc$accident_index))
## get summary
genders <- c('M','F')
severities <- c('fatal','serious','slight','none')
totals <- sapply(1:2,function(z) sapply(c(1,2,3,4),function(x)nrow(subset(subavc,casualty_severity==x&sex_of_driver==z))))
rownames(totals) <- severities
colnames(totals) <- genders
## compute ksi
ksi_rate <- c(0.15,0.072)
ksi <<- totals[1,] + totals[2,]
ksi_unbelted <<- ksi*ksi_rate

belt_rate <- totals
belt_rate[2,] <- 0
belt_rate[1,] <- c(0.258,0.148)

## set default values
none_rate_m=0.02
none_rate_f=0.02
slight_rate_m=0.05

# belt rates for none and slight injuries
belt_rate[4,] <- c(none_rate_m,none_rate_f)
belt_rate[3,] <- c(slight_rate_m,(0.04*sum(totals[3,])-slight_rate_m*totals[3,1])/totals[3,2])

unbelted <- totals * belt_rate
belted <- totals - unbelted

## calculate 'serious'
unbelted[2,] <- ksi_unbelted - unbelted[1,]
belted[2,] <- ksi - ksi_unbelted - belted[1,]
belt_rate[2,] <- unbelted[2,]/totals[2,]

belted_probabilities <- apply(belted,2,function(x)x/sum(x))
unbelted_probabilities <- apply(unbelted,2,function(x)x/sum(x))
odds_ratio <- belted_probabilities/unbelted_probabilities
gender_ratio <- odds_ratio[,2]/odds_ratio[,1]
gender_ratio

##########################################################

byspeed <- t(100*sapply(seq(20,70,by=10),
       function(x)sapply(1:2,
            function(y)sum(subavc$speed_limit==x&subavc$sex_of_driver==y&subavc$casualty_severity==2)/sum(subavc$speed_limit==x&subavc$sex_of_driver==y))))

colnames(byspeed) <- genders

rowSums(unbelted)/sum(unbelted)/(rowSums(belted)/sum(belted))

##################################################
get_gender_ratio <- function(belt_rate,
                             totals,
                             none_rate_m=0.02,
                             none_rate_f=0.02,
                             slight_rate_m=0.05,
                             none_m_unreported=0,
                             none_f_unreported=0,
                             slight_m_unreported=0,
                             slight_f_unreported=0){
  ## uncertain
  # numbers of none and slight injuries
  totals[4,1] <- totals[4,1] * (1+none_m_unreported)
  totals[3,1] <- totals[3,1] * (1+slight_m_unreported)
  totals[4,2] <- totals[4,2] * (1+none_f_unreported)
  totals[3,2] <- totals[3,2] * (1+slight_f_unreported)
  # belt rates for none and slight injuries
  belt_rate[4,] <- c(none_rate_m,none_rate_f)
  belt_rate[3,] <- c(slight_rate_m,(0.04*sum(totals[3,])-slight_rate_m*totals[3,1])/totals[3,2])
  
  unbelted <- totals * belt_rate
  belted <- totals - unbelted
  
  ## calculate 'serious'
  unbelted[2,] <- ksi_unbelted - unbelted[1,]
  belted[2,] <- ksi - ksi_unbelted - belted[1,]
  belt_rate[2,] <- unbelted[2,]/totals[2,]
  
  belted_probabilities <- apply(belted,2,function(x)x/sum(x))
  unbelted_probabilities <- apply(unbelted,2,function(x)x/sum(x))
  odds_ratio <- belted_probabilities/unbelted_probabilities
  gender_ratio <- odds_ratio[,2]/odds_ratio[,1]
  gender_ratio
}

get_gender_ratio(belt_rate,totals)

## mixing #################################

acc_in <- subavc$accident_index
dupli <- unique(acc_in[duplicated(acc_in)])
dupavc <- subset(subavc,accident_index%in%dupli&number_of_vehicles==2&(casualty_class==1|is.na(casualty_class)))
dupavc$casualty_severity[is.na(dupavc$casualty_severity)] <- 4
dupavc$sex_of_driver[dupavc$sex_of_driver==-1] <- 3
setDT(dupavc)
dupavc[,cas:=sum(2^(casualty_severity-1)),by='accident_index']
dupavc[,gen:=sum(2^(sex_of_driver-1)),by='accident_index']
cas_sum <- dupavc[,.N,by=c('cas','gen')]
setorder(cas_sum,'cas','gen')
subset(cas_sum,gen%in%c(2,3,4))

collisions <- rbind(
  c(sum(dupavc$gen==2),sum(dupavc$gen==3)/2),
  c(sum(dupavc$gen==3)/2,sum(dupavc$gen==4))
)
chisq.test(collisions)

fatal_events <- rbind(
  sapply(1:2,function(x)sum(dupavc$sex_of_driver==x&dupavc$casualty_severity==1)),
  sapply(1:2,function(x)sum(dupavc$sex_of_driver==x&dupavc$casualty_severity!=1))
)
chisq.test(fatal_events)

fatalities <- rbind(
  sapply(1:2,function(x)sum(dupavc$sex_of_driver==x&dupavc$casualty_severity==1&dupavc$gen%in%2:4)),
  sapply(1:2,function(x)sum(dupavc$sex_of_driver==x&dupavc$gen%in%2:4&dupavc$cas==2^(dupavc$casualty_severity-1)+1))
)
chisq.test(fatalities)

## nov ###################################

nov <- subset(subavc,number_of_vehicles==1)
t(sapply(seq(20,70,by=10),function(z)
  sapply(1:2,function(x) 
    sapply(1,function(y)sum(nov$speed_limit==z&nov$casualty_severity==y&nov$sex_of_driver==x)/sum(nov$speed_limit==z&nov$sex_of_driver==x)*100)))
)

## overturned ###############################

overturn <- subset(subavc,skidding_and_overturning%in%c(2,5))
sapply(1:2,
  function(x)sapply(c(20,30,40,50,60,70),
    function(y)sum(overturn$sex_of_driver==x&overturn$speed_limit==y&overturn$casualty_severity==1)/sum(overturn$sex_of_driver==x&overturn$speed_limit==y)*100))

## sample #########################################################
nsamples <- 10000
none_rate_m <- rbeta(nsamples,10,500)
none_rate_f <- rbeta(nsamples,10,500)
slight_rate_m <- rbeta(nsamples,70,1400)
none_m_unreported <- rgamma(nsamples,shape=10,rate=2)
none_f_unreported <- rgamma(nsamples,shape=10,rate=2)
slight_m_unreported <- rgamma(nsamples,shape=7,rate=2)
slight_f_unreported <- rgamma(nsamples,shape=7,rate=2)
hist(none_rate_m); mean(none_rate_m)

{png('belt_rates.png',width=1500,height=500); par(mar=c(4.5,4.5,0.5,0.5),mfrow=c(1,3),cex=1.5,lwd=3,cex.lab=1.3,cex.axis=1.3)
  plot(density(none_rate_m),col='navyblue',frame=F,xlab='Unbelted rate, no injury (M)',main='')
  plot(density(none_rate_f),col='navyblue',frame=F,xlab='Unbelted rate, no injury (F)',main='')
  plot(density(slight_rate_m),col='navyblue',frame=F,xlab='Unbelted rate, slight injury (M)',main='')
  dev.off()
}

{png('unreported.png',width=1000,height=1000); par(mar=c(4.5,4.5,0.5,0.5),mfrow=c(2,2),cex=1.5,lwd=3,cex.lab=1.3,cex.axis=1.3)
  plot(density(none_m_unreported),col='navyblue',frame=F,xlab='Unreported, no injury (M)',main='')
  plot(density(none_f_unreported),col='navyblue',frame=F,xlab='Unreported, no injury (F)',main='')
  plot(density(slight_m_unreported),col='navyblue',frame=F,xlab='Unreported, slight injury (M)',main='')
  plot(density(slight_f_unreported),col='navyblue',frame=F,xlab='Unreported, slight injury (F)',main='')
  dev.off()
}

results <- matrix(0,ncol=4,nrow=nsamples)
for(i in 1:nsamples) results[i,] <- get_gender_ratio(belt_rate,totals,none_rate_m[i],
                                                     none_rate_f[i],
                                                     slight_rate_m[i],
                                                     none_m_unreported[i],
                                                     none_f_unreported[i],
                                                     slight_m_unreported[i],
                                                     slight_f_unreported[i])

hist(results[,1])
hist(results[,2])


compute_evppi <- function(jj,sources,outcome,nscen=1,all=F,multi_city_outcome=T){
  # initialise vector
  voi <- rep(0,length(outcome)*nscen)
  # extract one source
  sourcesj <- sources[[jj]]
  max_degree <- ifelse(is.vector(sourcesj),1,ncol(sourcesj))
  # compute number of cities in outcome
  ncities <- length(outcome) - as.numeric(multi_city_outcome)
  # if computing for all outcomes, include all indices
  indices <- jj
  if(all==T) indices <- 1:ncities
  # if there is a multi-city outcome, include in indices
  if(multi_city_outcome==T) indices <- c(indices,length(outcome))
  # loop over included indices
  for(j in indices){
    # extract one outcome
    case <- outcome[[j]]
    # loop over all scenarios
    for(k in 1:nscen){
      # extract scenario values and sum
      y <- case[,seq(k,ncol(case),by=nscen)]
      # compute outcome variance
      vary <- var(y)
      # model outcome as a function of input(s)
      model <- earth(y ~ sourcesj, degree=min(4,max_degree))
      # compute evppi as percentage
      voi[(j-1)*nscen + k] <- (vary - mean((y - model$fitted) ^ 2)) / vary * 100
    }
  }
  voi
}
lapply(1:7,compute_evppi,sources=list(none_rate_m,
                                      none_rate_f,
                                      slight_rate_m,
                                      none_m_unreported,
                                      none_f_unreported,
                                      slight_m_unreported,
                                      slight_f_unreported),
       outcome=list(as.matrix(results[,1]),as.matrix(results[,2])),nscen=1,all=T,multi_city_outcome=F)
