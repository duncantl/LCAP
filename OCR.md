# OCR for LCAP

Some of the LCAP documents are scanned so the text is not directly accessible as with a regular PDF
document. Each page is essentially an image with pixels rather than text.

We can use a similar approach as we did for regular PDF documents, i.e.,
the location of the text and lines and rectangles.

We'll use the Rtesseract package which is an interface
to tesseract, the open source OCR library.
There is also the tesseract package, but that does not provide information about the location
of the text, but rather the text itself.
Similarly, we could use the tesseract command line application to get the text.



+ Convert the PDF file into a separate image for each page
  + bin/pdf2png from the Rtesseract package provides a wrapper to do this.
  + Or we can call convert from Imagemagick directly since we only want one page.


+ For BerkeleyUnified_Alameda__1_FinalLCAPApprovedbyCountySuperintendent_2018.pdf, the information
  we want is on page 163.  
  
+ To extract this page, we use  
```
convert -density 300 -quality 100 'PDFs/BerkeleyUnified_Alameda__1_FinalLCAPApprovedbyCountySuperintendent_2018.pdf[162]' berkeley163.png
```
Note we specified 162 since convert starts the page count at 0.  

Also note that convert rotated the page for us.
  
```
library(Rteseract)
```

```
p = tesseract("berkeley163.png")
bb = GetBoxes(p)
```
This takes about 10 seconds on my laptop. 

<!--
We rotate the page by reading it as a Pix object and using `pixRotate()`:
```
pix = pixRead("PDFs/BerkeleyUnified_Alameda__1_FinalLCAPApprovedbyCountySuperintendent_2018_p0162.png")
rpix = pixRotate(pix, pi/2)
plot(rpix)
```
Now we can pass this to `tesseract()` with
```
p = tesseract(rpix)
bb = GetBoxes(p)
```
The resulting text is much more sensible, but still with some issues.
-->

If we are lucky, we can find the dollar amount with grep()
```
grep("\\$", bb$text, value = TRUE)
[1] "$5,593,409"
```
We were lucky!


For the %, we are also fortunate
```
grep("%", bb$text, value = TRUE)
[1] "712%"
```
Curiously, the value from the OCR is incorrect. It should be 7.12%.
We can look at the confidence for this "word"
```
bb[grep("%", bb$text), ]
   left bottom right  top text confidence
43 1291    988  1438 1064 712%   77.02309
```
86% of the confidence values are higher than this, so tesseract has low confidence on this:
```
sum(bb$conf > bb[grep("%", bb$text), "confidence"])/nrow(bb)
```

Fortunately, we can adjust this from the context as the value is likely to be between 0 and 100% (?)


## Text in the Box
To get the text in the box below these values, we could 
1. take all text below these two values, or
1. look for the horizontal and vertial lines that make up the rectangle,
1. find the region that has the "blue" background.

1 is clearly wrong as there is additional text between the blue boxes and we don't want that.


We can try to get the horizontal lines by reading the image and using getLines():
```
pix  = pixRead("berkeley163.png")
h = getLines(pix)
```
Unfortunately, with the default values, it only finds the grey line at the top of the image and this
appears to be a remnant from scanning the page, i.e., the interface between the page and the surface
on which it was scanned.



## Rectangle by Color 

We can assume that the rectangle (almost) spans the width of all the text.
We only need to find where it starts and end vertically.

Having read the image as a Pix object, let's bring the values for each pixel
into R as a 2-D matrix
```
a = pix[,]
dim(a)
```
Keep in mind the origin is the top-left corner.
So the bottom of the page is row 2550

We'll assume the top-left corner has the background color:
```
bg = a[1,1]
```

For each row, find the first pixel that does not have this background color:
```
tmp = apply(a, 1, function(x) which(x != bg)[1])
```
We can visualize this
```
plot(tmp, rev(seq_len(length(tmp))))
```
(Note we are plotting this in reverse vertical order to match the image and the origin being
top-left.)
The longest sequence at horizontal value 197  identifies our blue rectangle.
```
r = rle(tmp)
i = which.max(r$lengths)
start = sum(r$lengths[1:(i-1)])
end = start + r$lengths[i]
```
And the text in this box is 
```
bb$text[ bb$top > start & bb$bottom < end]
```
We can see that the OCR was far from perfect in recognizing some of the words, especially 
near the top of this box.



