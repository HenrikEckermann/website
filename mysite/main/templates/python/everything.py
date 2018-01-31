import numpy as np
import pandas as pd

#50 students will complete exam
students = 50
#50 questions (25 T/F, 25 MC)
n = 50
tfq = np.random.binomial(n/2, 0.5, 50)
mc = np.random.binomial(n/2, 0.25, 50)


l = []
for i in range(10000):
    tfq = np.random.binomial(n/2, 0.5, 50)
    mc = np.random.binomial(n/2, 0.25, 50)
    l.append((tfq+mc)/50)

al = np.array(l)

al.mean()

l = []
for i in range(10000):
    tfq = np.random.binomial(9, 0.5, 50)
    mc = np.random.binomial(1, 0.25, 50)
    l.append((tfq+mc+40)/50)


al = np.array(l)
al.mean()
(al>0.95).mean()

from plotnine import *

df = pd.DataFrame(al)
df = df.transpose()
df['index'] = df.index

coln = ['trial_{}'.format(str(x)) for x in range(10000)]
coln.append('index')
df.columns = coln
df.head()
(ggplot(df, aes(x='trial_0', y='index'))
+ geom_density())

(ggplot(df, aes(x='index', y='trial_0'))
+ geom_density())
