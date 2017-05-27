# pylab Numpy matplot makes python like matlab. 

# QSTK has a dataAccess class designed to quickly read data into 
# pandas DataFrame object. 
import QSTK.qstkutil.qsdateutil as du
import QSTK.qstkutil.tsutil as tsu
import QSTK.qstkutil.DataAccess as da

import datetime as dt
import matplotlib.pyplot as plt
import pandas as pd

# define the mix of shares. say only AAPL 1.00 0 0 0 to .7 .1 .1 .1


# symbols we are interested in 
ls_symbols = ["AAPL", "GLD", "GOOG", "XOM",  "$SPX"]
DT_START = dt.datetime(2011, 1, 1) # start day
dt_end = dt.datetime(2011, 12, 31) # end day 
dt_timeofday = dt.timedelta(hours=16) # 16 hr (closing price)
ldt_timestamps = du.getNYSEdays(dt_start, dt_end, dt_timeofday)

# read the data in
c_dataobj = da.DataAccess('Yahoo') # creates an object
ls_keys = ['open', 'high', 'low', 'close', 'volume', 'actual_close'] # data types you want to use. 
ldf_data = c_dataobj.get_data(ldt_timestamps, ls_symbols, ls_keys) # creates list of dataframe objects 
d_data = dict(zip(ls_keys, ldf_data)) # converts list into dictionary

# compute portfolio value everyday 
# value = val*na_price; % gives daily value for the portfolio 
# you apply the same formula to get sharp ratio
# or create 10* 10 9 8 7 

'''
# draw the figure. 
na_price = d_data['close'].values
plt.clf() # erase prev graph
plt.plot(ldt_timestamps, na_price) # plot data
plt.legend(ls_symbols) # legend
plt.ylabel('Adjusted Close') 
plt.xlabel('Date')
plt.savefig('adjustedclose.pdf', format='pdf')

# normalize
na_normalized_price = na_price / na_price[0, :]

# return by individual day 
na_rets = na_normalized_price.copy()
tsu.returnize0(na_rets)

'''

# select 4 shares and try to find the one with lowest sharp ratio. 

# not sure if we need to normalize 
# sharp ratio for each stock
rets = na_price.copy()
tsu.returnize0(rets)

av_ret = rets.mean(axis=0)
std1   = rets.std(axis=0)
shp_ratio = sqrt(250)* av_ret/std1


