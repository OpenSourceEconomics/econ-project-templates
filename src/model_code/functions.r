'

summaryw -> Return Heteroskedastic robust standard errors for "model".
clx -> Return clustered-standard errors for "fm".
waldki -> Return Wald Confidenceintervall for second "coef" of "reg"
anderson.rubin.ci -> Return "Anderson Rubin CI" for "ivmodel" with sig. niveau 
                     "conflevel". Default is "conflevel=.95"

'




summaryw = function(model) {        
                   '
			 Return Heteroskedastic robust standard errors for "model"
 
			 '			
                   
                   s = summary(model)
                   X = model.matrix(model)
                   u2 = residuals(model)^2
                   XDX = 0
            
                   ## Here one needs to calculate X'DX. But due to the fact that
                   ## D is huge (NxN), it is better to do it with a cycle.
                   for(i in 1:nrow(X)) {
                                        XDX = XDX + u2[i] * X[i,] %*% t(X[i,])
                   }
            
                   # inverse(X'X)
                   XX1 = solve(t(X)%*%X)
            
                   # Variance calculation (Bread x meat x Bread)
                   varcovar = XX1 %*% XDX %*% XX1
            
                   # degrees of freedom adjustment
                   dfc = sqrt(nrow(X)) / sqrt(nrow(X) - ncol(X))
            
                   # Standard errors of the coefficient estimates are the
                   # square roots of the diagonal elements
                   stdh = dfc*sqrt(diag(varcovar))
            
                   t = model$coefficients / stdh
                   p = 2 * pt(
                              -abs(t),nrow(X)-ncol(X)
                           )
                   results = cbind(
                                   model$coefficients, stdh, t, p
                             )
                   dimnames(results) = dimnames(s$coefficients)
                   list(results, dfc^2 * varcovar)
            }

clx = function(fm, dfcw, cluster){
                 # Return clustered-standard errors for "fm". 
                 # Mahmood Arai, Jan 26, 2008.
             
                 # The arguments of the function are:
                 # fitted model, cluster1 and cluster2
                 # You need to install libraries `sandwich' and `lmtest'
             
                 # reweighting the var-cov matrix for the within model
                 library(sandwich)
                 library(lmtest)
                 M = length(
                            unique(cluster)
                     )   
                 N = length(cluster)           
                 K = fm$rank                        
                 dfc = ( M / (M-1) ) * ( (N-1) / (N-K) )  
                 uj  = apply(
                             estfun(fm),2, function(x) tapply(x, cluster, sum) 
                       )
                 vcovCL = dfc * sandwich(fm, meat=crossprod(uj) / N) * dfcw
                 list(
                      coeftest(fm, vcovCL), vcovCL
                ) 
        }

waldki = function (reg , alpha, cluster){
                                         
                  # Return Wald Confidenceintervall for second "coef" of
                  # "reg" 
                  df = summary(reg)$df[2]
                  c = summary(reg)$df[1]
                  h = clx(fm = reg, dfcw = 1, cluster = cluster)[[1]][c + 2] * qt(1 - alpha/2,df)
                  est = reg$coef[2]
                  paste(
                        "$","[", round(est - h,2) , 
                        "," , round(est + h,2), "]", "$",
                        sep=""
                  )
}

anderson.rubin.ci = function(ivmodel, conflevel=.95){
                ## Return "Anderson Rubin CI" for "ivmodel" with sig. niveau 
                ## "conflevel". Default is "conflevel=.95"
                                                    
                y = ivmodel$y
                n = length(y)
                
                if( is.null(ivmodel$x)==TRUE ){
                                               print("Refit ivmodel with x=TRUE option in the ivreg function.")
                                               stop()
                }
                                                    
                regressors = ivmodel$x$regressors
                instruments = ivmodel$x$instruments
                
                # Use notation in Davidson and MacKinnon, 2011
                # Figure out based on ivmodel fit from ivreg, the elements in Davidson and MacKinnon 
                W = instruments;
                # Figure out which columns in regressors and instruments are the same
                regressors.same.vec = rep(0,ncol(regressors))
                instruments.columns.same = rep(0,ncol(regressors)-1)
                count = 1
                for(i in 1:ncol(regressors)){
                                             tempmat = regressors[,i] - instruments
                                             tempsum = apply(abs(tempmat),2,sum)
                                             regressors.same.vec[i] = sum(tempsum==0) > 0
                                             
                                             if(sum(tempsum==0)>0){
                                                                   instruments.columns.same[count] = i
                                                                   count = count + 1
                                             } 
                }
                
                y2column = which(regressors.same.vec==0)
                y2 = regressors[,y2column]
                Z = regressors[,-y2column]
                W2 = instruments[,-instruments.columns.same]
                
                l = ncol(W)
                
                if ( is.null(ncol(Z)) ){
                                        Z = matrix(Z)
                                        k = ncol(Z)
                }else{
                      k = ncol(Z)
                }
                                                    
                q = qf( conflevel, l-k, n-l )
                cval = q * (l-k) / (n-l)
                y1 = matrix(y, ncol=1)
                
                y2hat.given.W = fitted( lm(y2 ~ W - 1) )
                y2hat.given.Z = fitted( lm(y2 ~ Z) )
                y1hat.given.W = fitted( lm(y1 ~ W-1) )
                y1hat.given.Z = fitted( lm(y1 ~ Z) )
                
                coef.beta0sq = cval * sum(y2^2) - (cval+1) * sum(y2 * y2hat.given.W) + sum(y2 * y2hat.given.Z)
                           
				a = sum( y1 * y2hat.given.Z)
                coef.beta0 = -2 * cval * sum(y1*y2) + 2 * (cval+1) * sum(y1 * y2hat.given.W) - 2 * a
                              
                coef.constant = cval * sum(y1^2) - (cval + 1) * sum(y1 * y1hat.given.W) + sum(y1 * y1hat.given.Z)
                  
                D = coef.beta0^2 - 4 * coef.constant * coef.beta0sq
                
                if(coef.beta0sq==0){
                                    if(coef.beta0>0){
                                                     ci=c(
                                                          "[",
                                                          round(-coef.constant / coef.beta0, 2),
                                                          ",Infinity)"
                                                        )
                                    }
                                    if(coef.beta0<0){
                                                     ci=c(
                                                          "(-Infinity,",
                                                          round(-coef.constant / coef.beta0, 2),
                                                          "]"
                                                         )
                                     }
                                    if(coef.beta0==0){
                                                      
                                            if(coef.constant>=0){
                                                                 ci="Whole Real Line"
                                            }
                                            if(coef.constant<0){
                                                                ci="Empty Set"
                                            }
                                     }
                } 
                                                    
                if(coef.beta0sq!=0){
                                    if(D<0){
                                            if(coef.beta0sq>0){
                                                               ci="Whole Real Line"
                                            }
                                            if(coef.beta0sq<0){
                                                               ci="Empty Set"
                                            }
                                     }
                                    if(D>0){
                                            # Roots of quadratic equation
                                            # Roots of quadratic equation
                                            root1 = ( -coef.beta0 + sqrt(D) ) / (2 * coef.beta0sq)
                                            root2=( -coef.beta0 - sqrt(D) ) / (2 * coef.beta0sq)
                                            upper.root = round( max(root1,root2), 2)
                                            lower.root = round( min(root1,root2), 2)
                                            
                                            if(coef.beta0sq<0){
                                                        
                                                        ci = paste("[",
                                                                   lower.root,",",
                                                                   upper.root,"]",
                                                                   sep=""
                                                              )
                                            }
                                            if(coef.beta0sq>0){
                                                        
                                                        ci= c(
                                                              paste(
                                                                    "($-\\infty$,",
                                                                    "$",lower.root,
                                                                    "$]U",sep=""
                                                               ),
                                                              paste(
                                                                    "[$",
                                                                    upper.root,"$",
                                                                    ",$\\infty$)",
                                                                    sep=""
                                                               )
                                                            )
                                            }
                                     }
                                     if(D==0){
                                              ci="Whole Real Line"
                                    }
                }
        return(confidence.interval = ci)
}
        
        
        
bracket = function(x, sep="") {
                    ## Return "x" with round brackets
                    ## Default "sep="" "
                    paste( 
                          "(", x , ")" , 
                          sep=sep
                    )
}

bracket_cur = function(x, sep=""){
                    ## Return "x" with curly brackets
                    ## Default "sep="" "
                    paste(
                          "\\{", x, "\\}", 
                          sep=sep
                    )
}
