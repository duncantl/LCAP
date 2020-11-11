
library(ReadPDF)
library(XML)

#doc = readPDFXML("PDFs/ABC_Unified.xml")
doc = readPDFXML("PDFs/Acton-Agua_Dulce_Unified.xml")

# or
# doc = xmlParse("PDFs/ABC_Unified.xml")

# Doesn't identify a node, so color must be slightly different.
z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and ./fontspec[@color = '#0000ff']]")

z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')] ]")

z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and text[starts-with(., 'Estimated Supplemental')] and rect]")


bb = getBBox2(z[[1]], TRUE)
rr = getBBox(getNodeSet(z[[1]], "./rect|./line"), TRUE)
k = which.max(abs(rr$y1 - rr$y0))

w = bb$top > rr$y0[k] & bb$top < rr$y1[k]

# Get the text inside the box. Collapse into a single string.
# Won't have paragraph markers/separators.
# Includes the page number although that should be outside of the box. Need to tweak the computations to be more precise.
# Specifically, the page has height 918, and yet the y1 value for the rectangle is 1838, so beyond the page. It is almost exactly twice the page height.
# So this could be due to spanning multiple pages.
textInBox = paste(bb$text[w], collapse = " ")

# Now get the text that is not in this large box  and look for the $ and %
bb = bb[!w,]
i = grep("$", bb$text, fixed = TRUE)
unlist(regmatches(bb$text[i], gregexpr("\\$[0-9,]+", bb$text[i])))

j = grep("%", bb$text, fixed = TRUE)
unlist(regmatches(bb$text[j], gregexpr("[0-9.]+%", bb$text[j])))


# If we want to find these numbers by looking inside the boxes they are supposed to be in
# we can look for the text
#   Concentration Grant Funds
# and
#   Increase or Improve Services
# to get the approximate location of the rectangles

i = grep("Concentration Grant Funds", bb$text)

w2 = bb$top[i] - rr$y0 < 20


# The text in the box goes onto the next page.
# Conveniently, the box starts at the very, very top of the page, i.e. no margin.
# That is a good indication it is a continuation.

nextPage = getSibling(z[[1]])






# Berkeley version is scanned.



f = "PDFs/Bolinas_2017-18_Final_Board_Approved_LCAP.xml"
doc = readPDFXML(f)

z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')] ]")


# There are three instances of this in the document.
#

# If we look for blue text or more precisely a fontspec with color attribute that is blue
# we get 2 matches.
z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and ./fontspec[@color = '#0000ff']]")


# Better to look for all of the text we want.
# Still matches 2 pages
z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and text[starts-with(., 'Estimated Supplemental')]]")

# If we also insist the page have a rect element, we get what we want.
z = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and text[starts-with(., 'Estimated Supplemental')] and rect]")


bb = getBBox2(getNodeSet(z[[1]], ".//text") TRUE)
grep("\\$|%", bb$text)

