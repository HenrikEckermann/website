#import modules
%pylab inline
import pandas as pd

#import data
df = pd.read_table('/Users/henrikeckermann/Documents/Books/Extra/arm/ARM_Data/arsenic/wells.dat', delimiter=' ')

#plot histogram of predictor
from plotnine import *
(ggplot(df, aes(x='dist'))
 + geom_histogram(color='black', fill='lightgrey', bins=40))


df.head()
import statsmodels.api as sm
logit_model= sm.Logit(df['switch'], df['dist'])
fit_1 = logit_model.fit()
fit_1.summary2()
  
