import cv2 as cv
import numpy as np
import re
binary = open("E:\CE434\RGBtoHSV\modelsim\\binary.txt","w+")


img = cv.imread('C:\\Users\DELL\Desktop\CE434\lena_256.jpg')
rgb = cv.cvtColor(img,cv.COLOR_BGR2RGB)
hsv = cv.cvtColor(rgb,cv.COLOR_RGB2HSV)
print(hsv)
a = np.array2string(rgb)


b = re.sub('\W+',' ',a)
#print (b)

c = b.strip()
#print(c)

d = c.split(' ')

i = 0

while(i< len(d)):
    binary.write("{0:{fill}8b}".format(int(d[i]),fill = '0') + "\n")
    i = i + 1
