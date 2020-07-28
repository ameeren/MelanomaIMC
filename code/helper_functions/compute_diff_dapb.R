compute_difference = function(input,i) {
  diff = as.data.table(input[[as.character(i)]] - input[["T6_DapB"]])
  diff[, scaled_diff := scale(V1)]
  diff[, mean_expresson_chemokine := input[[as.character(i)]]]
  diff[, mean_DapB := input[["T6_DapB"]]]
  diff[, p_value := pnorm(-abs(scaled_diff), mean = 0 , sd = 1)]
  diff[, adj_p_value := p.adjust(as.numeric(p_value), method = "BH")]
  colnames(diff) = c("diff", "scaled_diff", "mean_chemokine", "mean_DapB", "p_value", "padj")
  return(diff)
}