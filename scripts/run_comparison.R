#!/usr/bin/env Rscript
library("rmarkdown" )

args<-commandArgs(TRUE)
sub <- args[1]
time <- args[2]

test.location = paste(sep="", "../data/output/", sub, "/", time, "/")
gold.location = paste(sep="", "../data/reference/", sub, "/", time, "/")
outfile = paste( sep="", "../docs/", sub, "_", time, ".pdf" )

print( test.location )
print( gold.location )
print( outfile )

render("comparison.Rmd", output_file=outfile )
