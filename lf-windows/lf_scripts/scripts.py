import os
import sys
import shutil

def backup_files(paths):
    for path in paths:
        new_path = path + '.bk'
        shutil.copy(path, new_path)

def debackup_files(paths):
    for path in paths:
        if len(path) > 3:
            if path[-3:] == '.bk':
                new_path = path[:-3]
                shutil.copy(path, new_path)

def remove_files(paths):
    for path in paths:
        if os.path.isdir(path):
            shutil.rmtree(path)
        else:
            os.remove(path)

def log_files(paths):
    path = 'D:\\lf_scripts\\log.txt'
    with open(path, 'w') as f:
        f.write(str(len(paths)) + '\n')
        for path in paths:
            f.write(path + '\n')
