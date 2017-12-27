#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 26 20:07:33 2017

@author: henrikeckermann
"""

import scipy.stats as stats
import pandas as pd


def skk(df,columnlist, nan='propagate'):
    '''
    Return dataframe with with skew values and kurtosis values
    nan_policy: {'propagate', 'raise', 'omit'}--> see help from e.g. scipy.stats.skew
    '''
    skew_kurt = pd.DataFrame(index=['skew','skewtest','kurtosis', 'kurtosistest'])
    for col in columnlist:
        skew_kurt[col] = [stats.skew(df[col], nan_policy=nan),stats.skewtest(df[col],nan_policy=nan),
                      stats.kurtosis(df[col],nan_policy=nan), stats.kurtosistest(df[col],nan_policy=nan)]
    print('Skew')
    display(skew_kurt.loc[['skew','skewtest'],:])
    print('Kurtosis')
    display(skew_kurt.loc[['kurtosis', 'kurtosistest'],:])
    
def zscore(df, columnlist):
    '''
    Return df with z-values
    '''
    for c in columnlist:
        df['{}_z'.format(c)] = (df[c]-df[c].mean())/df[c].std()
    return df
 