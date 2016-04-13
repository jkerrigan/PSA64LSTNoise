import numpy as n,pylab as pl, scipy,sys
import matplotlib as mpl
pl.switch_backend('agg')
k = []
d = len(sys.argv[1:])
print d
k3m = n.zeros((9,d))
errm = n.zeros((9,d))
std = n.zeros((9,d))
i = 0
for arg in sys.argv[1:]:
   data = n.load(arg)
   errm[:,i] = data['errm']
   k3m[:,i] = data['k3m']
   k = data['k']
   std[:,i] = data['std']
   del(data)
   i += 1

#days = n.zeros(d)
#for i in range(d):
#   days[i] = 2**(i+1)
#print k,len(k)
days = [2,4,8,16,32,64,128]
print len(k3m[:,0])
for j in range(9):
   pl.clf()
   ax = pl.subplot(211)
   #ax.set_yscale('symlog', nonposy='noclip')
   ax.set_xscale('log',basex=2)
   pl.errorbar(days, k3m[j,:], yerr=errm[j,:], fmt='k.', capsize=0,linewidth=1.2)
   pl.xlabel(r'$Days Binned$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k)\ [{\rm mK}^2]$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k) [{\rm mK}^2]$',fontsize='large')
   pl.plot(days,n.zeros(len(days)),'--')
   ax.set_xlim(2**0,2**8)

   ax1 = pl.subplot(212)
   #ax1.set_yscale('log', nonposy='clip')
   ax1.set_xscale('log',basex=2)                                                                                                                                                        
   pl.errorbar(days, errm[j,:], yerr=std[j,:], fmt='k.', capsize=0,linewidth=1.2)
   pl.xlabel(r'$Days Binned$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k)\ [{\rm mK}^2]$', fontsize='large')
   pl.ylabel(r'$k^3/2\pi^2\ P(k) Error [{\rm mK}^2]$',fontsize='large')
   pl.plot(days,n.zeros(len(days)),'-')
   #ax.set_ylim(-1e5,1e5)
   ax1.set_xlim(2**0, 2**8)
   pl.savefig('pspec_'+str(round(k[j],2))+'.png')

pl.clf()
#pl.plot(days,err[8,:]/err[7,:])
#pl.savefig('ratio.png')
