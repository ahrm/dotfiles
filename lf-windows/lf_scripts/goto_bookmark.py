import os
import sys
import subprocess

BOOKMARK_DIR = "D:\\lf_scripts\\bookmarks"

def goto_bookmark():
    try:
        output = subprocess.run(['D:\\lf_scripts\\findbookmark.bat'], capture_output=True)
        output = output.stdout.decode('utf8')
        if output:
            selected = output.split('\n')[-2]

            selected = os.path.join(BOOKMARK_DIR, selected)
            with open(selected, 'r') as f:
                file_path = f.read()
                # escape characters
                file_path = file_path.replace('\\', '\\\\')

            subprocess.run(['lf', '-remote', 'send {id} {command} "{selected}"'.format(id=sys.argv[1], selected=file_path, command='cd')])
    except Exception as e:
        pass


if __name__ == '__main__':
    goto_bookmark()
