#Hello, and Welcome to R! Today, we're gonna go over some basic commands/general useful small tricks
#This isn't intended as an exhaustive tutorial, and I am by no means an expert, but this should give you a springboard to jump off of. If you have questions, feel free to contact me at riklewis@ucsc.edu, or use the help() function with the relevant function in parenthesis.

#fisrt off, starting a line with a "#" symbol will turn it into a comment. This line won't run as code, and it's useful for explaining/documenting the code you've written. 
#now, let's try opening a dataset. You'll do this by clicking file, then import dataset, then import for STATA for .dta datasets. 
#In the window, you'll see a browse button. Click that, then navigate to your dataset, which is probably in the downloads folder, or something like that.
#Once you've done that, you'll see a preview of the code used to load the dataset into R, and a preview of the dataset itself. 

#A cool trick that I like is copying that code preview into your R script file. It makes sure you don't have to reopen the dataset next time you open R!
#For our example dataset, wage1.dta, here's some code that will let you load it into R

library(haven) #loads the haven library, which is a tool that lets us import and read stata datasets. You only have to load a library one time in your code, so if you put this at the top, you can import multiple datasets without calling it more than once
wage1 <- read_dta("C:/Users/MiniThinkpad/Downloads/wage1.DTA") #The symbol "<-" is pretty similar to an equals sign, it basically defines wage1 as the name for that datset
View(wage1)#opens another tab to the right of your R script that's basically a table, or dataframe, of the dataset. 

#Now, let's try some basic commands to learn more about our dataset.
#summary gives us some basic information about each variable inside our dataframe. It outputs in the console window below your R script window
summary(wage1)
#If you want to dive deeper into one element of your data do so in this format: dataset$variable
summary(wage1$wage)
#This works for most operations for picking out a specific element of a dataset in R

#Next, let's look at some basic data analysis functions, like correllation, scatter plots, that kind of thing
#To create a scatter plot, we'll use scatter.smooth(). We're going to try to scatter wage and education, and it will output a plot in the bottom right window of r-studio
scatter.smooth(wage1$wage,wage1$educ) #scatter.smooth(y-axis,x-axis) There's other options, which you can find by googling the package
#notice how it places points for each individual piece of data, but also automatically generates a trend line. Pretty cool!

#next, let's try a correlation. We'll use the cor() function. 
cor(wage1,use="complete.obs") #the use option here deletes null values. Good to do this, as cor() assumes a complete dataset and will throw an error if there's missing sections
#the output in console generates a correlation of every variable in the dataset. It's Massive! Let's try picking out a specific one instead
cor(wage1$wage, wage1$educ, use="complete.obs")
#now we only get the correlation between wage and education. However, we're not sure of the significance, because this package doesn't handle that. To do basic significance testing, we'll use cor.test()
cor.test(wage1$wage, wage1$educ)
#The output is in the console window below. you can see the t, degrees of freedom, and p value. All in a pretty friendly format.

#Regression stuff
#The lm() command in R is pretty similar to the reg command in STATA. We're gonna futz around with it for a bit.
lm(wage ~ educ+exper, data=wage1,)
#The first part is basically the equation for the regression you wish to run, with the "=" replaced with a ~. The second specifies where you're getting those variables. it makes it quicker to write. 
summary(lm(wage ~ educ+exper, data=wage1,))

#Data manipulation
#Unlike Stata, R is rarely unhappy with lots of datasets loaded into dynamic memory at once. It makes it easy to chop, slice, and compare datasets in a quick and relatively freeform fashion. 
#My personal strategy for working with datasets is to avoid editing the source one, and instead initalize new dataframes with the components I want. 
#let's try creating a new dataframe, based on wage1, but only including wage, education, and experience
wagepartial <- data.frame(wage1$wage, wage1$educ, wage1$exper)
#the previous line of code creates a fresh dataframe that includes only wage, education, and experience. You can now freely manipulate that new, limited dataframe while leaving the main one alone

#Let's roll back to our earlier regression to keep experimenting with data manipulation.
#if you define an object as that summary, you can then pull useful specific coefficients out of it for later use!
testsummary <- summary(lm(wage ~ educ+exper, data=wage1,))
#you now have another data table generated from the summary of that linear model over in your regression window. Try pulling particular cells of that array by using testsummary[], with the term you want in the brackets
testsummary[["adj.r.squared"]]
testsummary[["coefficients"]]
#as you can see, each of these outputs generates a small table, which you can then define as another variable as well!
testcoefficients <-testsummary[["coefficients"]]
#you can then write any of these into a new .csv file by using the command "write.csv"
write.csv(testcoefficients,'testsummary.csv')
#the new CSV file will appear in wherever your default documents folder is. For me, on windows, it's in documents, while on linux it's in home. Dunno about OSX, sorry mac users.
#outputting your results into a neat little csv is super useful for a lot of stuff, including writing research papers. It's much less work than laboriously transferring figures by hand into a spreadsheet or table. Work smarter, not harder.
#you can also output directly to a .xls file, using the library writexl. Google it!

#Visualization
#Tables and numbers and coefficients are cool and all, but executives and nonspecialists, similarly to small children, like simple shapes and bright colors. 
#We're going to go over how to produce those in R, using our handy, very powerful friend, ggplot2. ggplot2 is pretty complex, and can definitely be intimidating at first. 
library(ggplot2)
ggplot(data= wage1, mapping =aes(educ,wage))+ geom_point()
#the function, ggplot, lets us define a dataset, our axis using the aes option, and then how to graph. we're using the default geom_point, but what happens when we change style or something?
ggplot(data= wage1, mapping =aes(educ,wage))+ geom_point(size=5, shape=4)
#neat, right? but we've got more powerful options available. What if we wanted to change the size of the point based on years of experience?
ggplot(data= wage1, mapping =aes(educ,wage))+ geom_point(aes(size=exper), shape=6)
#Neat!
#How about adding a regression line?
ggplot(data= wage1, mapping =aes(educ,wage))+ geom_point(aes(size=exper), shape=6)+geom_smooth(method=lm)
#literally that easy. 

#what if we wanted to make a pi or bar chart to represent something like job demographics of our data
#First, we'd need to get a count of how many people working in each industry. We can use the sum command for that, and initialize a new data frame specifically for this purpose
SkilledTrades <- sum(wage1$trade)
Construction <- sum(wage1$construc)
NondurableManufacturing <- sum(wage1$ndurman)
TransportAndMisc <- sum(wage1$trcommpu)
Services <- sum(wage1$services)
#next, we create a dataframe and just throw all these variables into it
jobdemographics <- data.frame(SkilledTrades,Construction,NondurableManufacturing,TransportAndMisc,Services)
#so, now we've got this cool data frame, but we can't use it for our next task. We need to refactor it. The key columns and rows aren't very usable to create a bar chart. 
#we could do this by hand, but I'm lazy. We're going to use a library called "tidyr" handle it. 
install.packages("tidyverse") #installing the library and loading it into the R script
library(tidyr)
#We're going to take our current data, and use the gather tool to take our column titles and convert them into a key column
jobdemographics <- gather(jobdemographics,'SkilledTrades','Construction','NondurableManufacturing','TransportAndMisc','Services', key="jobsector",value="jobcount")
#take a look at the difference now. Our data is now in a usable format, with actual, named key columns and row titles. Huzzah!
#Now, we're actually gonna make that bar chart. 
jobdemochart <- ggplot(data=jobdemographics, aes(x=jobsector,y=jobcount))+geom_bar(stat="identity")
jobdemochart
#take a look at the output in your plot window. Looks pretty boring, yeah? 
#time to add colors. 
jobdemochart <- ggplot(data=jobdemographics, aes(x=jobsector,y=jobcount, color=jobsector, fill=jobsector))+geom_bar(stat="identity")
jobdemochart
#Wow! Pretty!
#For those of you who did well in trig, what happens when you convert cartesian coordinates to polar?
jobdemochart <- ggplot(data=jobdemographics, aes(x=jobsector,y=jobcount, color=jobsector, fill=jobsector))+geom_bar(stat="identity")+coord_polar("y",start=0)
jobdemochart
#neat, but not a pie chart in the conventional sense. What if we made a single "bar" and used the polar conversion?
jobdemochart <- ggplot(data=jobdemographics, aes(x="",y=jobcount, color=jobsector, fill=jobsector))+geom_bar(stat="identity")
jobdemochart
#neat. One bar, but still seperated by color. What happens if we convert this new updated single bar into polar?
jobdemochart <-(jobdemochart+coord_polar("y",start=0))
jobdemochart
#neat! Shapes and colors are present. Still too many numbers for small children/executives though, and that grey background could go away.
jobdemochart <- jobdemochart+theme_void()
jobdemochart
#No scary numbers, no ugly background. Just soft shapes and pleasant colors!

