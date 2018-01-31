import os
import shutil
import re

os.getcwd()
os.chdir('/Users/henrikeckermann/Downloads')

os.listdir()

pattern = re.compile(r'.*[(R)(pptx?)(docx?)(pdf)]$')

for s in os.listdir():
    if pattern.search(s) is not None:
        shutil.move(os.path.join(os.getcwd(), s), '/Users/henrikeckermann/Documents/workspace/research_master/block_2/analyzing_in_r/exam')
os.listdir()    



for i in range(2,8):
    os.chdir('week_{}'.format(i))
    #write header
    with open('week_{}.md'.format(i), 'r') as f:
        s = f.read()
    s = s.replace('Week 1', 'Week {}'.format(i))
    with open('week_{}.md'.format(i), 'w') as f:
        f.write(s)
    #go back
    os.chdir('..')


os.getcwd()
os.chdir('block_3/psychobiology_of_behavior')

os.chdir('week_1')
with open('week_1.md', 'r') as f:
    content = f.read()
os.chdir('..')

for i in range(1,8):
    os.chdir('week_{}'.format(i))
    shutil.move('week_{}.md'.format(i), 'week_{}.Rmd'.format(i))
    #with open('week_{}.md'.format(i), 'w') as f:
        #f.write(content)
    os.chdir('..')



