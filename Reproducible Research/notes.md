# Reproducible Research

--------------------------------------------------------------------------------

## Week 1

* How is it that we can replay a complex piece of music over and over with different people and different conductors and it sounds the same?
  * There's a __score__. There's instructions! There's a tried and true way to document how to reproduce the piece of music
  * This is still a little murky for data analysis

### Concepts and Ideas

* Reproduction by independent people is great to make sure the outcome or theory is read
* What's wrong with it?
  * It's just hard to do
  * No time/money/etc
* Even if there's no time/money to reproduce, at least make it possible to run your exact study by providing data and code. __REPRODUCIBLE__.
* "The combination of inherently small small signal, large impacts, and complex statistical methods almost require that the research we do be reproducible."
* IOM report
  * Data/metadata be made available
  * All process/code be explicit
  * Instruction encompass whole study from beginning to end
* So what do we need?
  * Analytic data are available
  * Analytic code are abailable
  * Documentation of code and data
  * Standard means of distribution
* Who are the players?
  * Authors - want to have research reproducible
  * Readers - want to reproduce!
* What's happening now?
  * Authors through what they can on the web
  * Readers pull data, try to piece together the software and code
* __Literate (Statistical) Programming__
  * Make a human and machine readable code base
  * R started out with `Sweave`
    * Based on LaTeX
  * Now we have `knitr`
    * Combines R, markdown, latex, html

### Scripting Your Analysis

First... __DEFINE YOUR QUESTION__.  

Roger's understanding of the process:  
A. Science  
B. Data  
C. Applied Statistics  
D. Theoretical Statistics  

A-B-C: Proper data analysis  
B-C: Danger Zone!
C-D: Statistical methods development  

So....
1. Define your question: Can I identify SPAM emails?
2. Define the ideal data set
  * Descriptive: whole population
  * Exploratory: random sample with many variables
  * Inferential: the right population, randomly sampled
  * Predictive: training and test data set
  * Causal: data from randomized study
  * Mechanistic: data about all components of the system
3. Determine what data you can access
  * Free? Buy? Terms of use? Does it exist?
4. Obtain the data (and reference the source)
  * `library(kernlab)`
  * `data(spam)`
5. Clean the data
  * Understand where it comes from
  * Reformat for your purposes: training and testing
  * `set.seed(3435)`
  * `trainMarker <- rbinom(4601, size = 1, prob = 0.5)`
  * Determine if the data are good enough - in not, quit or change data
6. Exploratory data analysis
7. Statistical prediction/modeling
8. Interpret results
  * Use appropriate language - don't misrepresent
9. Challenge results
  * Challenge steps
  * Challenge measures of uncertainty
  * Challenge choices of terms to include in the model
  * Think of potential alternatives
10. Synthesize/write up results
  * Lead with the question
  * summarize analyses into the story
  * order analyses according to story and not chronology
  * include "pretty" figures that contribute to the story
11. Create reproducible code
  * Document as you go - Rmarkdown and knitr!

### Organizing a Data Analysis

* What will you have?
  * Data - raw and processed
  * Figures - exploratory and final
  * R Code - raw, final, and markdown
  * Text - readme and reports

--------------------------------------------------------------------------------

## Week 2

### R Coding Standard

* Use text files and text editors
* Use indenting
* Limit the width (80 columns)
* Limit the length of functions

### Markdown, R Markdown, and knitr

* Markdown created by __John Gruber__
* Basic idea for R markdown is __Literate Statistical Programming__
* You can set global options for chunks
```
opts_chunk$set(echo = FALSE, results = "hide")
```
* Another great option: `cache=TRUE` to save output
  
  
--------------------------------------------------------------------------------
  
## Week 3

### Communicating Results

* Need to present work in a Hierarchy of information; top level down to details
* People need top level results and ability to drill down as they need
* Email Example
  * title
  * body: 1-2 paragraph summary
  * attachments: rmarkdown or something
  * links: repo etc (all deets)
* Plug for rpubs.com - you can publish here for free right from the html preview in rstudio

### Reproducible Research Checklist

* __DO__: Start With Good Science
  * Garbage in, garbage out
  * Coherent, focused question
  * Good collaborators reinforce best practices
* __DON'T__: Do Things By Hand/Point and Click
  * Ends up ruining reproducibility
  * Unless you can document EXACTLY what you do
  * Common things.. downloading data, editing spreadsheet, moving files, etc
* __DO__: Teach a computer
  * Almost guarantees reproducibility, requires concrete instructions
  * May be less convenient up front, but helpful later
* __DO__: Use Some Version Control
  * Git
  * Slow things down
  * Add changes in small chunks
* __DO__: Keep Track of Your Software Environment
  * Computing environment can be critical for reproducing your analysis
  * Operating system?
  * Software toolchain - database backends, shell, programming language
  * Supporting software: libraries, r packages, dependencies
  * External dependencies: web sites, etc
  * Version numbers: ideally for everything - in R `sessionInfo()`
* __DON'T__: Save Output
  * Stray output is not reproducible
  * Save the data and code that produces the out instead
  * (sometimes save for efficiency purposes)
  * Intermediate files are okay as long as you have code and documentation
* __DO__: Set Your Seed
  * In R - `set.seed()`
  * Allow reproducibility for simulations when random numbers are generated
* __DO__: Think About the Entire Pipeline
  * Raw data -> processed data -> analysis -> report
  * How you got the end is just as important as the end itself
  * The more reproducible the better for everyone
* __SUMMARY__
  * Are we doing good science?
  * Was any part done by hand? - precisely documented?
  * Have we taught the computer to do as much as possible?
  * Are we using version control?
  * Have we documented the software environment?
  * Have we saved any output we cannot reconstruct from the original data + code?
  * How far back in the analysis pipeline can we go before the results are no longer (automatically) reproducible?

### Evidence-based Data Analysis

* Replication vs Reproducibility
  * Replication: is it true?
  * Reproducibility: can we trust this analysis?
* A lot of studies (especially in epidemiology) just can't be replicated
* What problems does reproducibility solve?
  * Transparency
  * Data Availability
  * Software/Methods are available
  * Improved transfer of knowledge
* Problems with Reproducibility:
  * Assumes everyone plays by the same rules, wants to achieve the same goals
  * Only addresses the most "downstream" aspect of the research process
* Tackle the upstream with Evidence-based Analysis?
  * We should use thoroughly studied, mutually agreed upon methods to analyze data whenever possible
  * There should be evidence to justify the application of a given method
  * If we have a pipeline of methods to use for specific situations then we could have a "Deterministic Statistical Machine"
  * Probably need different machines for different areas of study, a library of machines
  
--------------------------------------------------------------------------------
  
## Week 4

### Caching Computations

* `library(casher)` package for storing results
* Stores all your data results and you can save it in a "*package*"
* `cachepackage()` function stores...
  * Source file
  * cached data objects
  * metadata
* Stores a zip file and can be unzipped and examined with the `cacher` package
```
library(cacher)
clonecache(id = "somehashvalue")
showfiles()
# returns some sourcefile.R
sourcefile("sourcefile.R")
code() #look at the code
graphcode() #make a graph of the code
# interested in objectA?
objectcode("objectA")
# can execute code with lazy load of results
runcode()

# stores signatures for when code and objects were changed
checkcode()
checkobjects()
loadcache()
```
  
* *^^^Was this necessary???^^^*

### Case Studies
  
--------------------------------------------------------------------------------
