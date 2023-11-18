getInfo =
function(doc)
{
    if(is.character(doc))
        doc = readPDFXML(doc)

    pgs = getNodeSet(doc, "//page[ text[starts-with(., 'Demonstration of Increased')]  and text[starts-with(., 'Estimated Supplemental')] and rect]")
    if(length(pgs) == 0)
        stop("Didn't find the text")

    if(length(pgs) > 1)
        warning("found multiple pages")

    page = pgs[[1]]

    bb = getBBox2(page, TRUE)
    rr = getBBox(getNodeSet(page, "./rect|./line"), TRUE, color = TRUE)

    
#    k = which.max(abs(rr$y1 - rr$y0))
    lw = rr$x0 < min(bb$left)

    if(!any(lw)) # happens in Acton-Agua Dulce Unified.  Page is rotated 90 degrees which may have something to do with this.
                 # So go back to considering all of the rows in rr
        lw = rep(TRUE, nrow(rr))
    
    k = which.max(abs(rr$y1[lw] - rr$y0[lw]))
    ex = sort(c(rr$y0[lw][k], rr$y1[lw][k]))
    w = bb$top > ex[1] & bb$top < ex[2]
    
    if(!any(w))
        browser()

    textInBox = paste(bb$text[w], collapse = " ")

    #XXX  Get the text from the next page(s) if it is part of this box.

    bb = bb[!w,]
    i = grep("$", bb$text, fixed = TRUE)
    amt = unlist(regmatches(bb$text[i], gregexpr("\\$[0-9,]+", bb$text[i])))

    j = grep("%", bb$text, fixed = TRUE)
    pct = unlist(regmatches(bb$text[j], gregexpr("[0-9.]+%", bb$text[j])))

    # If we didn't find the values via grep(), then we have to identify the boxes in which they are located.

    list(amount = amt, percent = pct, text = textInBox)
}
