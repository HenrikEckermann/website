import os
import shutil



#walk through folders and files:
directory = os.getcwd()
for path, folders, files in os.walk(directory):
    print(path)
    print(folders)
    print(files)

#since the remove function in os only work with empty dirs, I use shutil
#os.rmdir('testfolder')   
#os.removedirs('testfolder') 
shutil.rmtree('testfolder')
os.listdir()
#remove single file
#os.remove('file.txt')


#rename files (first I create one that we then rename)
f = open('osjojo.py', 'w+')
f.close()
os.listdir()
os.rename('osjojo.py', 'os.py')

#show file stats (size, last modified etc.)
os.stat('os.py')
#e.g. time modified
os.stat('os.py').st_mtime
from datetime import datetime
print(datetime.fromtimestamp(os.stat('os.py').st_mtime))

#get environment variables like e.g. home
home = os.environ.get('HOME')
home


#os.path module
path = os.path.join(home, 'Documents/workspace/Own/python_os')
path

#get basename and dirname
os.path.basename('/Users/henrikeckermann/Documents/workspace/Own/python_os/hello.py')
os.path.dirname('/Users/henrikeckermann/Documents/workspace/Own/python_os/hello.py')
os.path.split('/Users/henrikeckermann/Documents/workspace/Own/python_os/hello.py')
#does a file exist?
os.path.exists('/Users/henrikeckermann/Documents/workspace/Own/python_os/hello.py')
os.path.isdir('/Users/henrikeckermann/Documents/workspace/Own/python_os/os.py')
os.path.isfile('/Users/henrikeckermann/Documents/workspace/Own/python_os/os.py')
os.path.splitext('/Users/henrikeckermann/Documents/workspace/Own/python_os/os.py')
print(dir(os.path))


os.chdir('week_1')
os.listdir()

os.getcwd()
shutil.move('week_1.md', 'week_1.txt')
os.listdir()

with open('week_1.md', 'r') as f:
    content = f.read()

os.chdir('..')
os.getcwd()

os.getcwd()
os.chdir('mixed_models')
os.listdir()
os.chdir('../..')
with open('hw1.Rmd', 'r') as f:
    content = f.readlines()
content
content[1].replace('1', i)
os.getcwd()


for i in range(2,9):
    os.makedirs('week_{}/hw_{}'.format(i,i))
    os.chdir('week_{}/hw_{}'.format(i,i))
    if i <= 5:
        with open('hw{}.Rmd'.format(i), 'w') as f:
            content[1] = content[1].replace(str(i-1), str(i))
            for line in content:
                f.write(line)
    os.chdir('../..')



str(2+2)