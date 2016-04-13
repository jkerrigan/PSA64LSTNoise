import numpy as n,pylab as pl, scipy,sys
import matplotlib as mpl
pl.switch_backend('agg')
### Usage: python PlotSingleLST.py #LSTInterval '#LSTInterval statistics .npz'

k = []
d = 7
k3 = []
err = []
std = []
i = 0
day = sys.argv[1]
for arg in sys.argv[2:]:
   print arg
   data = n.load(arg)
#   print arg
   err = data['k3err']
   k3 = data['k3']
   k = data['k']
   #std = data['std']
   #k = data['k']
   del(data)
   i += 1

print n.shape(k3)
days = n.zeros(len(k3[0,:]))
for i in range(len(k3[0,:])):
   days[i] = i*int(day)
print len(days)
for j in range(9):
   pl.clf()
   ax = pl.subplot(111)
   ax.set_yscale('log', nonposy='clip')
   #ax.set_xscale('log',basex=2)
   pl.errorbar(days, k3[j,:], yerr=err[j,:], fmt='k.', capsize=0,linewidth=1.2)
   #pl.scatter(days,err[j,:])
   pl.xlabel(r'$Days Binned$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k)\ [{\rm mK}^2]$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k) [{\rm mK}^2]$',fontsize='large')
   print days[k3[j,:]-err[j,:]>0]
   #ax.set_ylim(-1e5,1e5)
   #ax.set_xlim(2**0, 2**8)
   pl.savefig('LSTpspec_'+str(round(k[j],2))+'Day'+str(day)+'.png')

#pl.clf()
#pl.plot(days,err[8,:]/err[7,:])
#pl.savefig('ratio.png')
