a,b=map(int,input().split())

for i in range(1,a//2 + 1):
    print(('.|.'*(2*i-1)).center(b,'-'))
print('WELCOME'.center(b,'-'))
for i in range(a//2  ,0,-1):
    print(('.|.'*(2*i-1)).center(b,'-'))
print('thank u')

        
    
