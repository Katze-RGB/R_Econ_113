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


#TBD: More dataframe manipulation, t-testing, cool libraries, visualization
