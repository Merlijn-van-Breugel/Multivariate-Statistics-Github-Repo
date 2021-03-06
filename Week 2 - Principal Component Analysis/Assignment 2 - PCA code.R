# Raw data
load("Week 2 - Principal Component Analysis/drug_use.RData") #MvB: Note that you give the correct folder of the project. Preferably use Git repository
#Inspect raw data, by means of simply looking at averages and correlations
colMeans(drug_use)
cor(drug_use)
#Perform PCA on raw data
res.raw <- princomp(drug_use, cor = TRUE)
summary(res.raw)
screeplot(res.raw, ylabs='Eigenvalue')
biplot(res.raw, asp = 1,xlabs=rep("·", nrow(drug_use)))
screeplot(res.raw)

# Compute proportion of drug use proportionally per individual (divide by row sums)
drug_use_share <- drug_use / matrix(rowSums(drug_use), nrow = nrow(drug_use), ncol = ncol(drug_use))
res.share <- princomp(drug_use_share, cor = T)
summary(res.share)

screeplot(res.share)
dev.print(png,"C:\\Users\\Merlijn\\Documents\\GitHub\\Multivariate-Statistics-Github-Repo\\Week 2 - Principal Component Analysis\\Screeplot_druguse_raw.png",width=400, height=350) #directly save to disk
biplot(res.share, asp = 1,xlabs=rep("·", nrow(drug_use)))
dev.print(png,"C:\\Users\\Merlijn\\Documents\\GitHub\\Multivariate-Statistics-Github-Repo\\Week 2 - Principal Component Analysis\\Biplot_druguse_raw.png",width=400, height=350) #directly save to disk

# Do a bootstrap on eigenvalues to see how stable the eigenvalues are.
library("boot")                                     # Use the boot package
boot.pca.fn <- function(data, index){               # Make a function that returns the 
  res <- princomp(drug_use_share[index,], cor = TRUE)    # pca singular values for data selected
  return(res$sdev)                                  # by the vector index
}
res.boot <- boot(drug_use_share, boot.pca.fn, R = 1000)  # Run 1000 bootstraps
print(res.boot, digits = 3)                         # Print bootstrap results
plot(res.boot, index =  1)                          # Histogram of 1st singular value of the bootstraps
dev.print(png,"C:\\Users\\Merlijn\\Documents\\GitHub\\Multivariate-Statistics-Github-Repo\\Week 2 - Principal Component Analysis\\Bootstrap_druguse_first_singular_value.png",width=400, height=350) #directly save to disk
plot(res.boot, index =  2)                          # Histogram of 2nd singular value of the bootstraps
dev.print(png,"C:\\Users\\Merlijn\\Documents\\GitHub\\Multivariate-Statistics-Github-Repo\\Week 2 - Principal Component Analysis\\Bootstrap_druguse_second_singular_value.png",width=400, height=350) #directly save to disk
boot.ci(res.boot, index = 1, type = "perc")[4]      # Show show 95% confidence interval 

