# this utility download the share price. 
# using wget command it is easy 
import urllib


# urllib.urlretrieve("http://google.com/index.html", filename="local/index.html")
# urllib.urlretrieve(http://ichart.finance.yahoo.com/table.csv?s=BRK-B&ignore=.csv)
# this format would work.
# http://ichart.finance.yahoo.com/table.csv?s=BRK-B&ignore=.csv
#wget format is this http://ichart.finance.yahoo.com/table.csv?s=BRK-B&d=3&e=5&f=2014&g=d&a=4&b=9&c=1996&ignore=.csv

names2 = {'TYX','GSPC'}
names = {'VOO','BND','GOOGL','YHOO','MSFT','AMZN','NFLX','CMCSA','TWTR','WFC','NSANY','WFM','HD','EL',
'BRK-A','BRK-B','DIS','TWX','TWC','LGF','LOGI','SBUX','DNKN','PNRA','CAG','FB'}
prefix = 'http://ichart.finance.yahoo.com/table.csv?s='
for i in names:
    fullname = prefix + i + '&ignore=.csv'
    print(fullname)
    localname = "data/" + i + ".csv"
    print(localname)
    urllib.urlretrieve(fullname,localname)





'''
import threading
import urllib
from Queue import Queue
import logging

class Downloader(threading.Thread):
    def __init__(self, queue):
        super(Downloader, self).__init__()
        self.queue = queue
    
    def run(self):
        while True:
            download_url, save_as = queue.get()
            # sentinal
            if not download_url:
                return
            try:
                urllib.urlretrieve(download_url, filename=save_as)
            except Exception, e:
                logging.warn("error downloading %s: %s" % (download_url, e))

if __name__ == '__main__':
    queue = Queue()
    threads = []
    for i in xrange(5):
        threads.append(Downloader(queue))
        threads[-1].start()
    
    for line in sys.stdin:
        url = line.strip()
        filename = url.split('/')[-1]
        print "Download %s as %s" % (url, filename)
        queue.put((url, filename))
    
    # if we get here, stdin has gotten the ^D
    print "Finishing current downloads"
    for i in xrange(5):
        queue.put((None, None))

'''
