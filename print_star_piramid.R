###########################################
###    print a pyramid of stars  ##########
###########################################

# determine the depth of pyramid
n <- 2

for (i in seq(1,n)){
  if(n < 1) {
    print('')
  }else {
    print(c(rep('', n-i),rep(c('*',''), i)))
      }
    
  
}
