s=0
for i in range(0,10):
    for j in range(0,10):
        for k in range(0,10):
            s+=1
print(s)
print('new')
import math
def bin_search(li, element):
    bottom = 0
    top = len(li)-1
    index = -1
    while top>=bottom and index==-1:
        mid = int(math.floor((top+bottom)/2.0))
        if li[mid]==element:
            index = mid
        elif li[mid]>element:
            top = mid-1
        else:
            bottom = mid+1
    return index
# Code by Quantrimang.com
li=[2,5,7,9,11,17,222]
print (bin_search(li,11))
print (bin_search(li,12))


    
    
    
