censor_dat = function(x, quant = 0.999, symmetric=F){
  if (symmetric){
    lower_quant = (1-quant)/2
    quant = quant+lower_quant
  }
  q = stats::quantile(x,quant)
  x[x>q] = q
  
  if(symmetric){
    q = stats::quantile(x, lower_quant)
    x[x < q] = q
  }
  return(x)
}