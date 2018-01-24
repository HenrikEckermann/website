import os

#Make files unix friendly
def rename_files():
    '''
     Replace ' ' with '_' and replace upper case letters by lower case in all files and folders in the cwd.
     
     directory -> string
    ''' 
      
    import os
    base = os.getcwd()
    #change ' ' to '_' and uppder to lower for paths
    for path, dirnames, files in os.walk(base):
        os.rename(path, path.replace(' ', '_').lower())
    #change ' ' to '_' and uppder to lower for files  
    for path, dirnames, files in os.walk(base):
        for s in files:
            os.rename('{}/{}'.format(path,s), '{}/{}'.format(path,s.replace(' ', '_').lower()))
    print('done')


os.getcwd()

