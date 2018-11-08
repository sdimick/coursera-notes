
# __Developing Data Products__

--------------------------------------------------------------------------------

## Week 1

### Shiny 1

* Shiny uses Bootstrap to create HTML, CSS, Javascript and looks nice on mobile platforms
* Need two files `ui.R` and `server.R` __OR__ one file `app.R`
* All standard html tags are available as Shiny functions
  * `?builder`
  * `h1()`
  * `p()`
  * `a()`
  * `div()`
  * `span()`
* Inputs - buttons, checkboxes, text boxes, etc.
* UI:
  * `sliderInput()`
  * `textOutput()`
* Server:
  * `output$text1 = renderText(input$slider2 + 10)`
* Plots!! - `plotOutput()` in UI and `renderPlot()` in Server

### Shiny 2 - Reactive expressions

* Reactive Expressions
  * Expressions wrapped by `reactive()`
  * `calc_sum <- reactive({input$box1 + input$box2})`
  * Then reference `calc_sum()`
* Delayed Reactivity (don't recalculate automatically on input changes)
  * In UI `submitButton("Submit")`
* Other UI layouts
  * `tabsetPanel()` and `tabPanel()`
* Custom HTML??
  * directory next to server.R file called `www`
  * file in there called `index.html`
* Interactive Graphics
  * `brush` arg in `plotOutput()` in ui file
  * `brushedPoints()` in server file

### Shiny Gadgets

* Basically a replacement for the `manipulate` package
* `miniUI` package for small shiny app in RStudio viewer pane
* Can create interactive plots, output to the console, save output from UI selection, etc.
  

--------------------------------------------------------------------------------

## Week 2

### R Markdown

* Focus here on how to make presentations
* RStudio > New File > R Markdown > Presentation
* Chunk Opts:
  * `comment = ""` change the comment in front of output
  * `echo = TRUE` to show code
  * `eval = FALSE` code only, no output
  * `fig.align='center'`
  * `fig.cap='figure caption'`
* Can "publish" html with a gh-pages branch in git

### Leaflet

* Javascript library for interactive maps!
* Checkout GoogleVis too.
* Examples:
```
library(dplyr)
library(leaflet)
my_map <- leaflet() %>%
  addTiles()
my_map
```
```
# Adding markers
my_map <- my_map %>%
  addMarkers(lat=39.2980803, lng=-76.5898801,
             popup="Jeff Leek's Office")
my_map
```
```
# A bunch of points
set.seed(2016-04-25)
df <- data.frame(lat = runif(20, min=39.2, max=39.3),
  lng = runif(20, min=-76.6, max=-76.5))
df %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers()
```
* Custom popup icon
```
hopkinsIcon <- makeIcon(
  iconUrl = "http://brand.jhu.edu/content/uploads/2014/06/university.shield.small_.blue_.png",
  iconWidth = 31*215/230, iconHeight = 31,
  iconAnchorX = 31*215/230/2, iconAnchorY = 16
)
```
* Can put html in popup
* Can cluster points with zoom
* draw circles/rectangles
* add legends

### GVIS

`library(googleVis)`  
Cool javascript plots from google

### Plotly

* Interactive plots
* the 3D scatter plots are really cool
* 3D surface cool


--------------------------------------------------------------------------------

## Week 3

### R Packages

* Packages: Extend basic functionality of R
* Collection of functions or objects with documentation
* Development Process:
  * Write some code in R script
  * Want to make it available to others
  * Incorporate R script file into R package structure
  * Write documentation for user functions
  * Include examples, demos, tutorials
  * Package it up!
  * Submit to CRAN, Bioconductor, Github
* Then what?
  * People find problems
  * you fix it or they fix it
  * release new version
* R Package Essentials
  * Create directory with name of the package
  * A DESCRIPTION file with has info about the package
  * R Code in `R/` sub-directory
  * Documentations in `man/` sub-directory
  * NAMESPACE (optional, but do it)
  * Full requirements in Writing R Extensions
* Once your files are together
```
R CMD build [packagename]
R CMD check [packagename]
```
* If you wand to put a package on CRAN it much pass the check without any errors or warnings
* `package.skeleton()` function sets up file structure template
* Create a project in rstudio that __IS__ and r package and you'll get a build tab - under "more" in that tab you can create with Roxogen and pull documentation right out of the r code file

### R Classes and Methods

* A system for doing object oriented programming
* Represent new data types
* S3 classed/methods
  * Included with version 3 of the S language
  * Informal, a little kludgey
  * Sometimes called the old-style classes/methods
* S4 classed/methods
  * Included with S-PLUS 6 and R 1.4.0 (December 2001)
  * More formal and rigorous
  * Also called new-style classes/methods
* Class: desicription of some thing `setClass()`
* Object: an instance of a class, can be created with `new()`
* Method: function that only operates on a certain class of objects
* Generic Function: dispatches methods
* Things to look up:
```
?Classes
?Methods
?setClass
?setMethod
?setGeneric
```
* Want to check out methods?
  * `getMethod()` for S4
  * `getS3Method()` for S3
* You can call S3 methods directly, but you shouldn't...

--------------------------------------------------------------------------------

## Week 4

### Swirl

* Go back to lecture if you want to do it, but surprising easy to create a swirl course

--------------------------------------------------------------------------------
