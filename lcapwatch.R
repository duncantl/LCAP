# Unfortunately, the lcapwatch page doesn't work in Firefox.
# In Chrome, I can't get to the second or subsequent page of results. There is a server side error.


library(RCurl)
library(XML)


# Using the Developer Tools to watch all the network requests based on loading
#   http://lcapwatch.org/lcap-listing/
# we page through all the requests and we find
# http://comova-new.simplesend.com/Lcap/BrowseByCounty.aspx?frameId=frameCounties
# returns an HTML document that seems to have the basic structure.
# So my guess about the data being in a JSON document was incorrect. That means we have to programmatically go through
# page by page to get the links on each page.  However, in Chrome, I get an error when I click on page 2 
# 
tt = getURLContent("http://comova-new.simplesend.com/Lcap/BrowseByCounty.aspx?frameId=frameCounties", followlocation = TRUE, verbose = TRUE)

doc = htmlParse(tt)

lnks = getHTMLLinks(doc)

pdfs = grep("pdf$", lnks, value = TRUE)

ok = mapply(function(u, to) try(download.file(u, to)),
             pdfs, file.path("PDFs", basename(pdfs)))


