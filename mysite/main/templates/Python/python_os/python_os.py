import os
import shutil

#get cwd
os.getcwd()
#change cwd to parrent directory
os.chdir(os.pardir)
os.chdir('week_1')
#list files
os.listdir()
#make directory
os.makedirs('testfolder/withsubfolder')
os.listdir()


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

