import numpy as n,pylab as pl, scipy,sys
import matplotlib as mpl
from tempfile import TemporaryFile
pl.switch_backend('agg')
##### Reads in an LST binned day intervals .npz file and combines it into one large .npz file with all sub-intervals
k = []
arglen = len(sys.argv[2:])
k3 = n.zeros((9,arglen))
err = n.zeros((9,arglen))
print sys.argv[2:]
d = {}
d['0'] = 'Day'+str(sys.argv[1])
print d['0']
i = 0
day = sys.argv[1]
print 'This is the day.',day
for arg in sys.argv[2:]:
   print arg,i
   data = n.load(arg)
   err[:,i] = data['k3err'][2:]
   k3[:,i] = data['k3pk'][2:]
   print data['k']
   k = data['k'][2:]
   del(data)
   i += 1
k3m = n.mean(k3,1)

n.savez(d['0'],k=k,errm=n.mean(err,1),std=n.std(err,1),k3m=k3m,k3=k3,k3err=err)
#print n.mean(err,1)
#print n.std(err,1)
#print n.mean(k3,1)

