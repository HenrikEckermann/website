# Go to http://www.pythonchallenge.com/ and get going

# Preparation
import os
# set working directory
directory = os.path.expanduser(
    "~/Documents/workspace/website/mysite/main/templates/python/python_riddle")


#######################################################
# Webscrapint maybe for later
# store string in a file
url = 'view-source:http://www.pythonchallenge.com/pc/def/ocr.html'
#import bs4
from bs4 import BeautifulSoup, Comment
import requests
# open the html file
with open(f"{directory}/2/ocr.html") as html_file:
    soup = BeautifulSoup(html_file, 'lxml')
soup.findAll(text=lambda text: isinstance(text, Comment))
match = soup.find_all(strin=lambda text: isinstance(text, Comment))
print(match)
#####################################################

### -0- ###
2**38
change_the_url_to = 'http://www.pythonchallenge.com/pc/def/274877906944.html'

### -1- ###
# store string in variable
s = 'g fmnc wms bgblr rpylqjyrc gr zw fylb. rfyrq ufyr amknsrcpq ypc dmp. bmgle gr gl zw fylb gq glcddgagclr ylb rfyr\'q ufw rfgq rcvr gq qm jmle. sqgle qrpgle.kyicrpylq() gq pcamkkclbcb. lmu ynnjw ml rfc spj.'

# create empty string to later store solution
solution = ''
# create string that contains all 26 characters
import string
base = string.ascii_lowercase * 2

# recode using a loop
for i in range(len(s)):
    if s[i] not in base:
        solution += s[i]
    else:
        solution += base[base.find(s[i]) + 2]
print(solution)

### -2- ###
# store string in s
with open(f"{directory}/2/source.txt", 'r') as source:
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
# store hmtl code in a file
url = 'http://www.pythonchallenge.com/pc/def/equality.html'
f = urlopen(url).read()
s = str(f)
# extract comment
import re
pattern = re.compile(r'(<!--)(.*)(-->)')
match = pattern.findall(str(f))
print(match)
temp = match[0][1]
temp = temp.strip('\\n')
s = temp.replace('\\n', '')
solution = ''
for i in range(3, len(s) - 3):
    if s[i].islower() & s[i - 3:i].isupper() & s[i + 1:i + 4].isupper():
        if sum([1 for c in s[i - 4:i + 5] if c.isupper()]) == 6:
            solution += s[i]
print(solution)


### -4- ###
from urllib.request import urlopen
# store hmtl code in a file
url = 'http://www.pythonchallenge.com/pc/def/linkedlist.php?nothing='
nothing = '63579'
counter = 0
# the solution was printen unter nothing = 66831 and is: 'peak.html'
while counter < 100:
    f = urlopen(url + nothing).read()
    s = str(f)
    print(s)
    #solution += s[0]
    nothing = s.split()[-1][:-1]
    counter += 1


### -5- ###
# pickle...
import pickle
pickle_in = open(f"{directory}/5/banner.p", 'rb')
code = pickle.load(pickle_in)
pickle_in.close()
for l in code:
    s = ''
    for t in l:
        s += t[1] * t[0]
    print(s)


### -6- ###
os.chdir(f"{directory}/6/")
os.listdir()
import zipfile

counter = 0
f_name = '90052.txt'
solution = []
with zipfile.ZipFile('channel.zip', 'r') as myzip:
    r = len(myzip.namelist())
    while f_name in myzip.namelist():
        with myzip.open(f_name) as f:
            s = f.read().decode()
            comment = myzip.getinfo(f_name).comment.decode()
            solution.append(comment)
            f_name = s.split()[-1] + '.txt'


solution_final = []
for i in solution:
    if i.isalpha() and i not in solution_final:
        solution_final.append(i)
solution_final

### -7- ###
from PIL import Image
im = Image.open(f"{directory}/7/oxygen.png")
im.size
im
print(im.format, im.size, im.mode)

bb = im.crop((0, 44, 629, 51))
bb.save('bb.png')
bb
bb2 = bb.copy()
bb2
code = []
width, length = bb.size
for w in range(width):
    for l in range(length):
        code.append(bb.getpixel((w, l)))


solution = ''
old = ''
for e in code:
    solution += chr(e[0])

solution


nl = [105, 110, 116, 101, 103, 114, 105, 116, 121]
print([chr(x) for x in nl])

### -8- ###
# I use bs4 to get some practice in using this useful tool (it will be more pythonic to use urlib)
from bs4 import Comment, BeautifulSoup as bs
import requests
import ast
# specify url level 8
url = 'http://www.pythonchallenge.com/pc/def/integrity.html'
# load the html file and store in r
r = requests.get(url)
soup = bs(r.text, 'lxml')
# store comment in result
result = soup.findAll(text=lambda text: isinstance(text, Comment))
s = result[0][6:]
# extract un and pw
import re
pattern = re.compile(r'(.*)(\spw:)(.*)')
un, nothing, pw = pattern.findall(s)[0]
# decompress bytes (here I had some trouble finding out about bz2 and how to decompress the file that I originally had (because of '\\'))
import bz2
nun = "'{}".format(un)
npw = pw[1:]
username = ast.literal_eval('b%s' % nun)
password = ast.literal_eval('b%s' % npw)
print(bz2.decompress(username), bz2.decompress(password))


### -9- ###
import re
from bs4 import Comment, BeautifulSoup as bs
from PIL import Image, ImageDraw


with open(f"{directory}/9/source.html") as html_file:
    soup = bs(html_file, 'lxml')
# grab comment
c = soup.findAll(text=lambda text: isinstance(text, Comment))[0][24:]
c = c.replace('\n', '')
pattern = re.compile(r'(.*)(second:)(.*)')
sfirst, nothing, ssecond = pattern.findall(c)[0]
first = [int(i) for i in sfirst.split(",")]
second = [int(i) for i in ssecond.split(",")]
first_coord = [(first[x], first[x + 1]) for x in range(0, 442, 2)]
second_coord = [(second[x], second[x + 1]) for x in range(0, 112, 2)]
final_coord = first_coord + second_coord
im = Image.open(f"{directory}/9/good.jpg")
im_c = im.copy()
draw = ImageDraw.Draw(im)
for i in range(276):
    draw.line(final_coord[i] + final_coord[i + 1], fill=(255, 0, 0), width=4)

im
# The solution is bull.


### -10- ###

# If you click on the picture you get a list: a = [1, 11, 21, 1211, 111221...
# Find a[30]: The algorithm to create the next element is: For each digit in 
# previous list element count how often it appears in a row: 1 --> 1 x 1 --> 
# 11. Or 21 --> 1 x 2 + 1 x 1 -> 1211 etc...

a = ["1"]
while len(a) != 31:
    new = ""
    skip = 1
    # for the last element of a, iterate over the digits:
    for n, i in enumerate(a[-1]):
        # skip: to be able to skip digit if it was already counted
        if skip != 1:
            skip -= 1
            continue
        # counter: to count how often a digit comes in a row
        counter = 1
        # ind: to compare with next digit
        ind = n + 1
        # count how often i comes in a row and add that to "new":
        while ind <= len(a[-1]):
            # if we reach the last element of the string a[-1], 
            # we need to add what was counted up before
            if ind == len(a[-1]):
                new += f"{str(counter)}{i}"
                skip = counter
                break
            if a[-1][ind] == i:
                counter += 1
                ind += 1
            else:
                new += f"{str(counter)}{i}"
                skip = counter
                break
    a.append(new)


# the solution is:
len(a[30])

### -11- ###
# extract html code
url = "http://www.pythonchallenge.com/pc/return/5808.html"
soup = bs(requests.get(url, auth=('huge', 'file')).text, 'lxml')
print(soup.prettify())
# extract image link to open it 
img_link = soup.find("img")
img_url = url.replace("5808.html", img_link["src"])
img = Image.open(requests.get(img_url, stream = True, auth=('huge', 'file')).raw)
img
width, height = img.size
pixel = []
for w in range(width):
    for h in range(height):
        pixel.append(img.getpixel((w, h)))

pixel 