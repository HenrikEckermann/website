import pandas as pd
import numpy as np
from plotnine import *

#import data
bdf = pd.read_csv('http://www.stat.columbia.edu/~gelman/arm/examples/beauty/ProfEvaltnsBeautyPublic.csv')
#Rename btystdave to beauty for convenience
bdf.columns = ['beauty' if x=='btystdave' else x for x in bdf.columns]
bdf.info()

#Make categorical vars 
for col in ['female', 'tenured' ,'blkandwhite']:
  bdf[col] = pd.Categorical(bdf[col]) 
  
#long format 
bdf_cat_l = pd.melt(bdf[['tenured', 'courseevaluation', 'female', 'blkandwhite']], id_vars = 'courseevaluation')


#How are the differences in courseevaluation between the categoricals
(ggplot(bdf_cat_l, aes(x='value', y='courseevaluation')) 
+ geom_jitter(alpha=0.5, width=0.2, color = 'grey')
+ stat_summary(fun_data = 'mean_sdl', fun_args = {'mult':1}, geom = 'errorbar')
+ stat_summary(fun_y = np.mean, geom = 'point', fill = 'red')
+ facet_wrap('~variable'))

(ggplot(bdf_cat_l, aes(x='value', y='courseevaluation')) 
+ geom_violin(trim=True)
+ geom_boxplot(width=0.2, outlier_color= 'red')
+ stat_summary(fun_y = np.mean, geom = 'point', color = 'blue')
+ facet_wrap('~variable'))