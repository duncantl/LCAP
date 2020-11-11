url = "https://willard.lacoe.edu/lcap2017/plan_status.pl"
tmp = postForm(url, year = 2017, style = "post")
doc2 = htmlParse(tmp)
a = getNodeSet(doc2, "//a")
links = sapply(a, xmlGetAttr, "href")
names(links) = sapply(a, xmlValue)
b = links[ grep("^view", links) ]
urls = getRelativeURL(b, url)

mapply(function(u, to) try(download.file(u, to)),
       urls, file.path("PDFs", paste0(gsub(" ", "_", names(urls)), ".pdf")))

