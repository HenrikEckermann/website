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


