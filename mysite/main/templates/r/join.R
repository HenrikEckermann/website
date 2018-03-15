library(dplyr)
left_join(df_to_keep, df_to_the_left, by='name of col(s) that ensures correct join')

right_join() # same but the second df will be the one that will be kept (so values that are only in the left one are gone)

inner_join() # keeps only rows that are in both df
full_join() # all rows are kept 

semi_join()  # to filter the first df and only keep rows that are also in the second df but without adding them
anti_join() # opposite of semi_join

# If dfs contain the same variables, it can make sense to use set operations like union(), intersect() and setdiff()
union() # returns every row that appears in any df but filters out rows that are double...
intersect() # only returns the rows that are in both dfs 
setdiff() # only returns rows from the left df that are not in the right...

setequal() # to check out if the rows of one df appear exactly also in the second df

identical() # the same but only returns true if rows are exact same order 

bind_cols() # use instead of cbind
bind_rows() # use instead of rbind e.g.:
bind_rows(label1=df1, label2=df2, .id=colanme)  # this will put the rows of the second df under the rows of the first + created a new col called colname that has label1 and label2 as strings that match df1rows and df2rows

# use data_frame and as_data_frame instead of data.frame and as.data.data_frame
data_frame()
as_data_frame()

# to join more than 2 dfs at once, do the following:
library(purrr)
#create list of dfs 
tables <- list(df1, df2, df3)
reduce(tables, left_join, by='keycol')