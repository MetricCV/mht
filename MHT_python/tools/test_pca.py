import _pickle as pk
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

ob = open('vgg','rb')
data = pk.load(ob)
print(type(data))

# data = data - data[0,:]

cm.coolwarm
plt.imshow(data,cmap=cm.coolwarm, interpolation='nearest',vmin=-1,vmax=1)
plt.show()

data = data - data[0,:]
print(data)
plt.imshow(data,cmap=cm.coolwarm, interpolation='nearest',vmin=-1,vmax=1)
plt.show()