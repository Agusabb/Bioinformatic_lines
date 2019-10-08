#!/usr/bin/env python
# coding: utf-8

# In[1]:


chain = str(input("Enter your sequence: "))

a = 0
t = 0
g = 0
c = 0
u = 0

for letter in chain:
    if letter == "a" or letter == "A":
        a += 1
    if letter == "t" or letter == "T":
        t += 1
    if letter == "g" or letter == "G":
        g += 1
    if letter == "c" or letter == "C":
        c += 1
    if letter == "u" or letter == "U":
        u += 1   
        
temp = (a+t)*2+(g+c)*4 or (a+u)*2+(g+c)*4
length = len(chain)

print(f"Your primer has {length} bp. Melting temperature is {temp}")


# In[ ]:




