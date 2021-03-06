library(pander)
library(glue)



### --- for LME --- ###

# returns apa p value as a string 
report_p <- function(p) {
  ifelse(p < 0.001, paste('_p_ <', '.001'),  paste('_p_ =', substring(as.character(p), 2,5)))
}

# same as above but returns *, ** or ***
report_star <- function(p) {
  ifelse(p < 0.001, return('***'), ifelse(p < 0.01, return('**'), ifelse(p < 0.05, return('*'), ' ')))
}



#I use this function not for the analysis but only for reporting the estimates or test statistics.
print_estimates <- function(model, name, complete=TRUE, method='PB', fes='none', conf=95) {
  
  #determine the ci print 
  ci <- ifelse(conf==95, '95% CI', ifelse(conf==99, '99% CI', '99.9% CI'))
  #assign ci if delivered
  if(fes=='none') {
    lower <- ''
    upper <- ''
  } else {
    lower <- round(fes[fes$coefficient==name,'lower'], digits=2)
    upper <- round(fes[fes$coefficient==name,'upper'], digits=2)
  }

  #assign method printversion 
  df_sig <- ifelse(method=='PB', '_PBtest_', ifelse(method=='KR', '_F_', '$\\chi^2$'))
  
  # which string to return. 
  ifelse(method=='PB', ifelse(!complete, glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))})'), glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))}), {df_sig} = {format(model$anova_table[name,1], digits=ifelse(model$anova_table[name,1]<1, 2, ifelse(model$anova_table[name,1]<10, 3, ifelse(model$anova_table[name,1]<100, 4, 5))))},  {report_p(model$anova_table[name,4])})')), ifelse(method=='KR', ifelse(!complete, glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))})'), glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))}), {df_sig}({model$anova_table[name,1]},{format(model$anova_table[name,2], digits=ifelse(model$anova_table[name,2]<1, 2, ifelse(model$anova_table[name,2]<10, 3, ifelse(model$anova_table[name,2]<100, 4, 5))))}) = {format(model$anova_table[name,3], digits=ifelse(model$anova_table[name,3]<1, 2, ifelse(model$anova_table[name,3]<10, 3, ifelse(model$anova_table[name,3]<100, 4, 5))))}, {report_p(model$anova_table[name,4])}, {ci} [{lower}, {upper}])')), ifelse(!complete, glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))})'), glue::glue('Estimate = {format(summary(model)$coefficients[name,1], digits=ifelse(summary(model)$coefficients[name,1]<1, 2, ifelse(summary(model)$coefficients[name,1]<10, 3, ifelse(summary(model)$coefficients[name,1]<100, 4, 5))))}({format(summary(model)$coefficients[name,2], digits=ifelse(summary(model)$coefficients[name,2]<1, 2, ifelse(summary(model)$coefficients[name,2]<10, 3, ifelse(summary(model)$coefficients[name,2]<100, 4, 5))))}), {df_sig}({format(model$anova_table[name,3], digits=ifelse(model$anova_table[name,3]<1, 2, ifelse(model$anova_table[name,3]<10, 3, ifelse(model$anova_table[name,3]<100, 4, 5))))}) = {format(model$anova_table[name,2], digits=ifelse(model$anova_table[name,2]<1, 2, ifelse(model$anova_table[name,2]<10, 3, ifelse(model$anova_table[name,2]<100, 4, 5))))}, {report_p(model$anova_table[name,4])})'))))
  
}

#report only model comparison stats from the anova table (required for factors with more than 2 levels)
print_comp <- function(model, name, method='PB') {
  
  df_sig <- ifelse(method=='PB', '_PBtest_', ifelse(method=='KR', '_F_', '$\\chi^2$'))
  
  ifelse(method=='PB', glue::glue('{df_sig} = {format(model$anova_table[name,1], digits=ifelse(model$anova_table[name,1]<1, 2, ifelse(model$anova_table[name,1]<10, 3, ifelse(model$anova_table[name,1]<100, 4, 5))))},  {report_p(model$anova_table[name,4])})'), ifelse(method=='KR',  glue::glue('{df_sig}({model$anova_table[name,1]},{format(model$anova_table[name,2], digits=ifelse(model$anova_table[name,2]<1, 2, ifelse(model$anova_table[name,2]<10, 3, ifelse(model$anova_table[name,2]<100, 4, 5))))}) = {format(model$anova_table[name,3], digits=ifelse(model$anova_table[name,3]<1, 2, ifelse(model$anova_table[name,3]<10, 3, ifelse(model$anova_table[name,3]<100, 4, 5))))}, {report_p(model$anova_table[name,4])})'), glue::glue('{df_sig}({format(model$anova_table[name,3], digits=ifelse(model$anova_table[name,3]<1, 2, ifelse(model$anova_table[name,3]<10, 3, ifelse(model$anova_table[name,3]<100, 4, 5))))}) = {format(model$anova_table[name,2], digits=ifelse(model$anova_table[name,2]<1, 2, ifelse(model$anova_table[name,2]<10, 3, ifelse(model$anova_table[name,2]<100, 4, 5))))}, {report_p(model$anova_table[name,4])})')))
  
}



### --- for PCA --- ###

make_bold <- function(x, cut = 0.4) {
  ifelse(x>=cut, glue("**{round(x, digits = 2)}**"), glue("{round(x, digits = 2)}"))
}

attr(make_bold, "comment") <- "make_bold adds markdown syntax such that significant values will be printed bold"

# returns rmarkdown pca table 
pca_table <- function(pca_object, cut = 0.4, caption = 'Component loadings', cr_alpha = "none") {
  pca_tab <- as.data.frame(unclass(pca_object$loadings))
  fac_names <- rownames(pca_tab)
  # format loadings
  pca_tab <- mutate_all(pca_tab, funs(make_bold))
  rownames(pca_tab) <- fac_names
  # optional: Implement cronbach's in table
  if (class(cr_alpha) == "list") {
    pca_tab["**Cronbach's Alpha**",] <- NA
    for (i in 1:5) {
      value <- round(cr_alpha[[i]]$total[1,1], digits = 2)
      pca_tab["**Cronbach's Alpha**", i] <- value
    }
  }
  # eigenvalues and explained variance
  eigen_and_var <- as_data_frame(pca_object$Vaccounted[1:2,])
  rownames(eigen_and_var) <- c("**Eigenvalues**", "**Variance explained (%)**")
  eigen_and_var[2,] <-  eigen_and_var[2,] * 100 
  eigen_and_var <- round(eigen_and_var, digits = 2)
  pca_tab <- rbind(pca_tab, eigen_and_var)
  panderOptions("table.emphasize.rownames", FALSE)
  pander(pca_tab, caption = caption)
}


attr(pca_table, "comment") <- "pca_table returns table in markdown syntax for reporting a principal component analysis"

report_chi <- function(chi, df, p) {
  return(glue("$\\chi^2$({df}) = {round(chi, digits = 2)}, {report_p(p)}"))
}
