#!/usr/bin/env Rscript
library("rmarkdown" )

args<-commandArgs(TRUE)
sub <- args[1]
time <- args[2]
logfile <- NA

if ( length(args) > 2 ) {
  logfile <- args[3]
  print( paste( "Saving results to", logfile))
}

test.location = paste(sep="", "../data/output/", sub, "/", time, "/")
gold.location = paste(sep="", "../data/reference/", sub, "/", time, "/")
outfile = paste( sep="", "../docs/", sub, "_", time, ".pdf" )

print( test.location )
print( gold.location )
print( outfile )

logdata = data.frame( LogTime=as.character(Sys.time()), Machine=Sys.info()[4][[1]], User=Sys.info()[8][[1]], Platform=sessionInfo()[[1]][1] )

render("comparison.Rmd", output_file=outfile )

outdata = logdata

if ( !is.na(logfile) ) {

  if( file.exists(logfile) ) {

    archived = read.csv(logfile)
    print(dim(archived))
    print(dim(outdata))
    outdata = rbind(archived, outdata )
    }

  write.csv(outdata, logfile, row.names=F)

}
