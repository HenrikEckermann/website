#print number as stirng with manual digits:
number <- 1.123456
format(number, digits=4) #scientific=T 
formatC(number, format='f', digits=3) #format='e' or 'g' for scientific

#putting strings together 
paste("A", "B", "C")
paste("A", "B", "C", sep="-")
paste(c("A", "B", "C"), "-")
paste(c("A", "B", "C"),c("-", "_", "!"))
paste(c("A", "B", "C"), "jo", "ne", collapse=", ")

#stringr
library(stringr)
#str version of paste has emptry space as default + handles missing values different: Paste treats them as 'NA' and str_c returns NA
str_c("A", "B", "C") #
#str_length
vec <- c('Hello', 'my', 'name', 'is', 'Slim', 'Shady')
str_length(vec) #equivalent of nchar but more intuitive 
#str_sub
str_sub(vec, 1,3) #return index 1 to 3 for each string 

#searching for patterns 
str_detect(vec, pattern=fixed('llo')) #the string can be a regex
str_subset(vec, pattern=fixed('llo')) # used in the same way 
str_count(vec, pattern=fixed('llo'))

#split strings 
ex <- "Tom & Jerry but also Goofy & Pluto & Max"
str_split(string=ex, pattern=' & ')
str_split(string=ex, pattern=' & ', n=2)
str_split(string=ex, pattern=' & ', simplify=T, n=8) # checkout simplify=T
#lapply takes a list, applies a function to each element of the list 
lapply(str_split(string=ex, pattern=' & '), length)

#replace strings
str_replace(string=ex, pattern=' & ',replacement=' and ') #only the first patter occurence
str_replace_all(string=c(ex, vec), pattern=' & ',replacement=' and ')

#regex in R
str_detect(c('Hi my name is, my name is, my name is 9999 slim shady!','cuz sometimes it just seems...'), pattern= '\\d+.slim') #check out rebus for an alternative way
str_view(c('Hi my name is, my name is, my name is 9999 slim shady!','cuz sometimes it just seems...'), pattern= '\\d+.slim') #should show the string but not yet in hydrogen....
str_extract(c('Hi my name is, my name is, my name is 9999 slim shady!','cuz sometimes it just seems...'), pattern= '\\d+.slim')
str_match(c('Hi my name is, my name is, my name is 9999 slim shady!','cuz sometimes it just seems...'), pattern= '\\d+.slim')