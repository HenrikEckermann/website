#Go to http://www.pythonchallenge.com/ and get going

#######################################################
#### Webscrapint maybe for later
#store string in a file
url = 'view-source:http://www.pythonchallenge.com/pc/def/ocr.html'
#import bs4
from bs4 import BeautifulSoup, Comment
import requests
#open the html file 
with open('2/ocr.html') as html_file:
    soup = BeautifulSoup(html_file, 'lxml')
soup.findAll(text=lambda text:isinstance(text, Comment))
match = soup.find_all(strin= lambda text:isinstance(text,Comment))
print(match)
#####################################################

import os
os.getcwd()
os.chdir('/Users/henrikeckermann/Documents/workspace/website/mysite/main/templates/python/python_riddle')

### -1- ###
#store string in variable
s = 'g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr\'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj.'

#create empty string to later store solution
solution = ''
#create string that contains all 26 characters
import string
base = string.ascii_lowercase*2

#recode using a loop
for i in range(len(s)):
    if s[i] not in base:
        solution += s[i]
    else:
        solution += base[base.find(s[i])+2]
print(solution)

### -2- ###
#store string in s
with open('2/source.txt', 'r') as source:
    s = source.read()

d = {}
for i in range(len(s)):
    if s[i] not in d:
        d[s[i]] = s.count(s[i])

solution = ''
for key in d.keys():
    if d[key] == 1:
        solution += key

print(solution)


### -3- ###
from urllib.request import urlopen
#store hmtl code in a file
url = 'http://www.pythonchallenge.com/pc/def/equality.html'
f = urlopen(url).read()
s = str(f)

#extract comment 
import re
pattern = re.compile(r'(<!--)(.*)(-->)')
match = pattern.findall(str(f))
print(match)
temp = match[0][1]
temp = temp.strip('\\n')
s = temp.replace('\\n','')



solution = ''
for i in range(3,len(s)-3):
    if s[i].islower() & s[i-3:i].isupper() & s[i+1:i+4].isupper():
        if sum([1 for c in s[i-4:i+5] if c.isupper()])==6:
            solution += s[i]
print(solution)


### -4- ###
from urllib.request import urlopen
#store hmtl code in a file
url = 'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing='
nothing = '63579'
counter = 0
#the solution was printen unter nothing = 66831 and is: 'peak.html'
while counter < 100:
    f = urlopen(url+nothing).read()
    s = str(f)
    print(s)
    #solution += s[0]
    nothing = s.split()[-1][:-1]
    counter += 1


### -5- ###
#pickle...
import os
import pickle

#os.chdir('python_riddle')
pickle_in = open('5/banner.p', 'rb')
code = pickle.load(pickle_in)
pickle_in.close()
for l in code:
    s = ''
    for t in l:
        s += t[1]*t[0]
    print(s)

    
### -6- ###
import os
os.getcwd()
os.chdir('/Users/henrikeckermann/Documents/workspace/website/mysite/main/templates/Python/python_riddle/6/')
os.listdir()
import zipfile

counter = 0
f_name = '90052.txt'
solution = []
with zipfile.ZipFile('channel.zip', 'r') as myzip:
    r = len(myzip.namelist())
    while counter < r:
        with myzip.open(f_name) as f:
            s = f.read().decode()
            comment = myzip.getinfo(f_name).comment.decode()
            solution.append(comment)
            f_name = s.split()[-1] + '.txt'
            counter += 1
            
solution
s = ''
for i in solution:
    s += i
print(s)
solution = 'oxygen'

### -7- ###
from PIL import Image
os.chdir('/Users/henrikeckermann/Documents/workspace/website/mysite/main/templates/Python/python_riddle/7')
im = Image.open('oxygen.png')
im.size
im
print(im.format, im.size, im.mode)

bb = im.crop((0,44, 629, 51))
bb.save('bb.png')
bb
bb2 = bb.copy()
bb2
code = []
width, length = bb.size
for w in range(width):
    for l in range(length):
        code.append(bb.getpixel((w,l)))


solution = ''
old = ''
for e in code:
    solution += chr(e[0])

solution


nl = [105, 110, 116, 101, 103, 114, 105, 116, 121]
print([chr(x) for x in nl])

### -8- ###
#I use bs4 to get some practice in using this useful tool (it will be more pythonic to use urlib)
from bs4 import Comment, BeautifulSoup as bs 
import requests
#specify url level 8
url = 'http://www.pythonchallenge.com/pc/def/integrity.html'
#load the html file and store in r
r = requests.get(url)
soup = bs(r.text, 'lxml')
#store comment in result
result = soup.findAll(text=lambda text:isinstance(text, Comment))
s = result[0][6:]
#extract un and pw
import re
pattern = re.compile(r'(.*)(\spw:)(.*)')
un, nothing, pw = pattern.findall(s)[0]
#decompress bytes (here I had some trouble finding out about bz2 and how to decompress the file that I originally had (because of '\\'))
import bz2
nun = "'{}".format(un)
npw = pw[1:]
import ast
username = ast.literal_eval('b%s' % nun)
password = ast.literal_eval('b%s' % npw)
print(bz2.decompress(username),bz2.decompress(password))


### -9- ###