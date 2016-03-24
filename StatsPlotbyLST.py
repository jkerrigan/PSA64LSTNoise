import numpy as n,pylab as pl, scipy,sys
import matplotlib as mpl
pl.switch_backend('agg')
k = []
d = 7
k3 = n.zeros((9,d))
err = n.zeros((9,d))
#print sys.argv
i = 0
for arg in sys.argv[1:]:
   print arg,i
   data = n.load(arg)
   if i == 6:
      print data['k3err']
   #err = n.append(err,data['k3err'][2:])
   #k3 = n.append(k3,data['k3pk'][2:])
   err[:,i] = data['k3err'][2:]
   #print len(data['k'][2:]),data['k3err']
   k3[:,i] = data['k3pk'][2:]
   k = data['k'][2:]
   #k = data['k']
   del(data)
   i += 1
print i
print err


days = n.zeros(d)
for i in range(d):
   days[i] = 2**(i+1)

for j in range(9):
   pl.clf()
   ax = pl.subplot(111)
   ax.set_yscale('log', nonposy='clip')
   ax.set_xscale('log',basex=2)
   #pl.errorbar(days, n.abs(k3[j,:]), yerr=err[j,:], fmt='k.', capsize=0,linewidth=1.2)
   pl.scatter(days,err[j,:])
   pl.xlabel(r'$Days Binned$', fontsize='large')
   #pl.ylabel(r'$k^3/2\pi^2\ P(k)\ [{\rm mK}^2]$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k) Error [{\rm mK}^2]$',fontsize='large')
   ax.set_ylim(1e0,1e5)
   ax.set_xlim(2**0, 2**8)

   pl.savefig('pspec_'+str(round(k[j],2))+'.png')

pl.clf()
pl.plot(days,err[8,:]/err[7,:])
pl.savefig('ratio.png')
