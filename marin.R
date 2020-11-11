# Can pick different years from this page

u = "https://www.marinschools.org/Page/5164"
mll = getHTMLLinks(htmlParse(getURLContent(u)))
mll = grep("LCAP.*\\.pdf$", mll, value = TRUE)
urls = paste0("https://www.marinschools.org/", mll)

mapply(download.file, urls, file.path("PDFs", gsub(" ", "_", basename(mll))))
