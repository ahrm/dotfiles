import sys
from scripts import backup_files

if __name__ == '__main__':
    backup_files(sys.argv[1:])
