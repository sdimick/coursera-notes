# Week 1
  
--------------------------------------------------------------------------------
  
## Graphs

### Principles of Analytic Graphics

* Show comparisons
  * Evidence is always relative
  * What's the alternative hypothesis
* Show causality/mechanism/explanation/systematic structure
  * What's the explanation behind the difference in our comparison?
* Show multivariate data
  * We don't live in a 2-variable world
  * A lot of times other variables are confounding
* Integrate multiple modes of evidence
* Describe and document evidence
  * With labels, scales, sources, etc.
* Content it KING
  * Is there any story?

*Edward Tufte (2006): Beautiful Evidence*
  
### Exploratory Graphs

* Why graphs?
  * __understand data properties__
  * __find patterns__
  * __suggest modeling strategies__
  * __"debug" analysis__
  * __present results__
* Exploratory Graphs
  * made quickly
  * make large number
  * goal is personal understanding
  * clean up axes/labels later
* Air quality example: Do any counties exceed the 12pm2.5 standard?

__One Dimensional Summaries__
```
summary(pollution$pm25)
boxplot(pollution$pm25)
# adding a rug is interesting
hist(pollution$pm25, col = "green")
rug(pollution$pm25)
# you can change the breaks
hist(pollution$pm25, col = "green", breaks = 100)
rug(pollution$pm25)
# add measure we're interested in
boxplot(pollution$pm25)
abline(h = 12)
# with hist too
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2)
abline(v = median(pollution$pm25), col = "magenta", lwd = 4)
# barplots
barplot(table(pollution$region), col = "wheat", main = "Number of Conties in Each Region")
```
  
__Two Dimensional Summaries__
*More than 2-D? Use colors, array of plots, etc*
```
# boxplot
boxplot(pm25 ~ region, data = pollution, col = "red")
# histogram
par(mfrow = c(2,1), mar = c(4, 4, 2, 1)) # what the heck is this? graph parms
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")
# scatter plot
with(pollution, plot(latitude, pm25))
albine(h = 12, lwd = 2, lty = 2)
# scatter plot with color
with(pollution, plot(latitude, pm25, col = region))
albine(h = 12, lwd = 2, lty = 2)
# panel of plots
par(mfrow = c(1,2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))
```
  
## Plotting

### Plotting Systems in R

* Base Plotting System
  * came with the original R
  * "artist's palette" - start blank and add layers
  * start with `plot` function
  * add to it with "annotation" functions
* The Lattice System
  * comes through he `lattice` package
  * plot everything with one function: `xyplot`, `bwplot`, etc
  * good for putting many plots on one screen
  * can see how x and y interact across levels of z
  * a lot of the details you have to select in base are calculated automatically
  * difficult to annotate a lattice plot
  * can't add to a plot once it's created
```
library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4, 1))
```
* ggplot2 System!
  * from the "grammar of graphics"
  * mixes ideas of base and lattice
  * has a lot of defaults, but you can always customize them
```
library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)
```
  
### Base Plotting System

1. Initial plot
  * `plot(x, y)` - has many arguments with many defaults
  * `hist(x)`
  * `boxplot()`
  * parameters function to specify things `?par`
  * Useful parameters for initial plot function
```
pch # the plotting symbol/character (Default open circle)
lty # line type
lwd # line width
col # color - specified with string, number, or hex code
xlab # x-axis label
ylab # y-axis label
```
  * Useful parameters for par function
```
las # orientation of axis labels
bg # the background color
mar # the margin size
oma # the outer margin size, useful for plot of plots
mfrow # number of plots per row, column, plots filled row-wise
mfcol # number of plots per row, column, plots filled column-wise
```
  * Can check defaults like `par("bg")`
2. Annotate plot (initialize plot with `type = "n"` to start blank)
  * `lines`
  * `points`
  * `text` adds labels
  * `title`
  * `mtext` add text to margins
  * `axis` specify axis ticks
  * `legend`
  * `abline` (can feed this `lm` output)
  
## Graphic Devices

* What is a graphics device?? Where your plot will appear
* the screen device (you computer screen!)
  * Mac: `quartz()`
  * Windows: `windows()`
  * Unix/Linux: `x11()`
* Vector formats, good for scaling
  * A PDF file - not efficient if plot has many objects/points
  * A scalable vector graphics file (SVG) -potentially useful for web graphics - almost all web-browsers recognize
  * postscript - also very scalable vector format - predecessor to PDF
  * win.metafile - windows metafile format
* Bitmapped formats - don't scale well
  * A PNG - bitmapped, good for line drawings and solid colors
  * JPEG - bitmapped - good for photos, small file size
  * TIFF - bitmapped - older, supports lossless compression
  * BMP - native windows bitmap format
* When you plot in R it has to go to a specific device
* If using file device, you have to CLOSE connection with `dev.off()`
* Can launch multiple graphics devices at once
  * Which one is active? `dev.cur()`
  * Switch to another `dev.set(<integer>)`
  * copy plots from one device to another `dev.copy` or `dev.copy2pdf`
  * Do not need to open device before copying, but need do close it after!
* Use `print(graph)` to save ggplot graph to device
  
--------------------------------------------------------------------------------
  
# Week 2
  
--------------------------------------------------------------------------------
  
## Lattice Plotting

* Built off the `grid` package
* Doesn't have two phase like base plotting, create it all in one function call
* Lattice functions:
  * `xyplot`: this is the main function for creating scatterplots
  * `bwplot`: box-and-whisters plots
  * `histogram`: histograms
  * `stripplot`: like a boxplot but with actual points
  * `dotplot`: plot dots on "violin strings"
  * `splom`: scatterplot matrix; like `pairs` in base
  * `levelplot`, `contourplot`: for plotting "image" data
* Basic scatterplot: `xyplot(y ~ x | f * g, data)`
```
library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data = airquality)

# lets go more complicated
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, data = airquality, layout = c(5, 1))
```
* lattice plotting returns an object of class trellis and then you call print to make it show up on the device
* You can make custom panel functions, the `layout = c(n, m)` part...
```
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...) # First call default panel for 'xyplot'
  panel.abline(h = median(y), lty = 2) # add horizonal line at median
  panel.lmline(x, y, col = 2) # add linear regression line
})
```
  
## ggplot2

* An implemetation of the *Grammar of Graphics* created by Hadley Wickham
* "In brief, the grammar tells us that a statistical graphic is a __mapping__ from data to __aesthetic__ attributes (color, shape, size) of __geometric__ objects (points, lines, bars). The plot may also contain statistical transformations of the data and is drawn on a specific coordinate system"
* `qplot()` is the analogous to the `plot()` function in base
  * data needs to be in a data frame
* Plots are made up of...
  * aesthetics: characteristics of the plot space
  * geoms: stuff that's plotted
* Important to leverage factor variables (as.factor)
* `ggplot()` is the core function that's highly customizable and does a lot that `qplot()` can't do
* __Basic components of ggplots__
  * data frame
  * aesthetic mappings
  * geoms
  * facets
  * stats (binning, quantiles, smoothing)
  * scales
  * coordinate system
* lables: `xlab()`, `ylab()`, `labs()`, `ggtitle()`
* Themes
  * `theme(legend.position = "none")`
  * `theme_gray()`
  * `theme_bw()`
* A note about axis limits
  * base puts outlier outside of the frame, but ggplot puts ALL the data in the frame
  * if you use `ylim(-3,3)` then ggplot __SUBSETS__ the data
  * instead you must use `coord_cartesian(ylim = c(-3, 3))`
* Turn continuous variable into "factor" with the `cut()` function so you can use it for panels/facets or color coding
```
cutpoints <- quantile(data$variable, seq(0, 1 length = 4), na.rm = TRUE)
data$new_var <- cut(data$variable, cutpoints)
# check out levels of new variable
levels(data$new_var)
```
  
--------------------------------------------------------------------------------
  
# Week 3
  
--------------------------------------------------------------------------------
  
## Hierarchical Clustering

* Define distance
* Define merging approach
* How it works
  1. Find closest two things
  2. Put them together
  3. Find next closet
* Common Distance Metrics
  * Euclidean - straight line distance (easily scalable for higher dimensions)
  * Manhattan - like city blocks = |A1-A2|+|B1-B2|+...+|Z1-Z2|
* You choose where to cut the dendrogram
* With different clustering algorithms
  * How to decide where the new center of a merged point is?
  * average linkage vs complete linkage
* Useful function is the `heatmap()` function
  * Clusters for rows AND columns of matrix
  
## K-means Clustering

* Distances
  * Continuous - Euclidean
  * Continuous - Correlation Similarity
  * Binary - Manhattan Distance
* K-means is a partitioning approach, and you have to say how many clusters
* Need:
  * Distance Metric
  * Number of clusters
  * Guess of initial Centroids
* Algorithm:
  * Assign things to closest centroid
  * Moves Centroids to "middle" of cluster
  * Reassign points to clusters
  * Repeat until convergence
* Produces:
  * Locations for Centroids
  * Which centroid each observation belongs to
```
kmeansObj <- kmeans(dataframe, centers = n)
kmeansObj$cluster #returns which cluster each observation is in

# plot your clusters!!
par(mar = rep(0.2, 4))
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeans$centers, col = 1:3, pch = 3, cex = 3, lwd = 3)
```
  
## Dimensional Reduction

### Principle Component Analysis and Singular Value Decomposition

* How do we pick...
  * Fewer, uncorrelated inputs
  * That still explain our output as best as possible
* SVD - Singular Value Decomposition - "matrix decomposition"
  * So if you take the % of each singular value of the sum total of the singular values, it tells you that percentage of variation that is explained. This allows you to see how many impactful components are in the data
  * `svd1 <- svd(scale(matrixOrdered))`
  * `svd1$u[, 1]` is the "First Left Singular Vector"
  * `svd1$v[, 1]` is the "First Right Singular Vector"
  * `svd1$d` is the "Singular Value"
  * `svd1$d^2/sum(svd1$d^2)` is the "Percent of Variance Explained"
* PCA - Principle Component Analysis - normalize variables first
* Cannot run svd on data with missing values
* You can use the `library(impute)` package to implement different methods of imputing, such as  `impute.knn()`
* __SCALE__ of your variables matter
* PCs/SVs may mix real patters (if multiple patterns exist)
* Alternatives
  * Factory Analysis
  * Independent components analysis
  * Latent semantic analysis
  
## Working with Color (in Plots)

* Built in scales
  * heat.colors()
  * topo.colors()
* `libary(grDevices)`
  * `colorRamp`
  * `colorRampPalette`
```
## colorRamp
pal <- colorRamp(c("red", "blue"))
pal(0) #gives you red
pal(1) #gives you blue
pal(0.5) #gives you something in the middle

## colorRampPalette
pal <- colorRampPalette(c("red", "yellow"))
pal(2) #returns list of two hex values (the two you gave)
pal(10) #returns list of ten hex values (two you gave on the ends)
```
* `library(RColorBrewer)`
  * Can get Sequential, Diverging, or Qualitative palettes
```
library(RColorBrewer)
cols <- brewer.pal(3, "BuGn") #select number of colors and palette to select from
cols #show what was picked
pal <- colorRampPalette(cols)
image(volcano, col = pal(20))
```
* `smoothScatter()` also uses the color brewer palettes
* Other helpful tools
  * `rgb()` which you can also use the `alpha` parameter
  * `plot(x, y, col = rgb(0,0,0,0.2), pch = 19)` adds transparency to scatter
  * `library(colorspace)` package
  
--------------------------------------------------------------------------------
  
# Week 4
  
--------------------------------------------------------------------------------
  
## Clustering Case Study

* `?scale` - figure out what this is doing before component analysis
* kmeans works well to find a "center" of highly dimensional space
  
## Air Pollution Case Study

* Are the air pollution levels today lower than 1999?
* A bunch of data munging to get some simple insights
