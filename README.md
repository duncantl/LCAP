
# Reading Data From LCAPs

This is for reading content from LCAP documents.
The code needs a lot of work to be general and robust, but is a start to make concrete
what we discussed today.

## Getting Some LCAPs programmatically
+ [LAcounty.R](LAcounty.R)
+ [marin.R](marin.R)
+ [lcapwatch.R](lcapwatch.R)
   + The Web site has a lot of problems.
   
   
## Extracting the Information
+ [getInfo.R](getInfo.R) function
+ [check.R](check.R) using the function on some XML files.
+ [getEstimated.R](getEstimated.R)  the code the went into getInfo() function as we were developing
  the approach interactively.


# OCR for Scanned Documents

+ [OCR strategies](OCR.md)


# Github Repositories

+ [ReadPDF](https://github.com/dsidavis/ReadPDF)
+ [pdftohtml](https://github.com/dsidavis/pdftohtml)
+ [Rtesseract](https://github.com/duncantl/Rtesseract)
+ [XML](https://github.com/omegahat/XML)
+ [RCurl](https://github.com/omegahat/RCurl)
