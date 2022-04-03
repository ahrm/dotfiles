# -*- coding: utf-8 -*-

# modified version of https://github.com/pmgagne/tkinterdnd2/blob/master/demos/demo_files_and_text.py

import os
import platform
from tkinterdnd2 import *
import sys

try:
    from Tkinter import *
    from ScrolledText import ScrolledText
except ImportError:
    from tkinter import *
    from tkinter.scrolledtext import ScrolledText

root = TkinterDnD.Tk()
root.withdraw()
root.title('Drag')
root.grid_rowconfigure(1, weight=1, minsize=250)
root.grid_columnconfigure(0, weight=1, minsize=300)

Label(root, text='Drag and drop files here:').grid(
                    row=0, column=0, padx=10, pady=5)

##############################################################################
######   Basic demo window: a Listbox to drag & drop files                  ##
######   and a Text widget to drag & drop text                              ##
##############################################################################
listbox = Listbox(root, name='dnd_demo_listbox',
                    selectmode='multiple', width=1, height=1)
listbox.grid(row=1, column=0, padx=5, pady=5, sticky='news')
ONCE = False

if sys.argv[1] == 'once':
    ONCE = True

for path in sys.argv[2:]:
    listbox.insert(END, os.path.abspath(path))
    # make listbox element selected
    listbox.selection_set(END)
# unselect last item
listbox.selection_clear(END)

info = 'TkinterDnD demo\nDetected versions:\n'
info += '    Python: %s\n' % platform.python_version()
info += '    Tk    : %f\n' % TkVersion
info += '    Tkdnd : %s\n' % TkinterDnD.TkdndVersion
info += 'Use mouse button 3 to drag hightlighted text from the text box.\n'

# Drop callbacks can be shared between the Listbox and Text;
# according to the man page these callbacks must return an action type,
# however they also seem to work without

def drop_enter(event):
    event.widget.focus_force()
    print('Entering widget: %s' % event.widget)
    return event.action

def drop_position(event):
    return event.action

def drop_leave(event):
    return event.action

def does_listbox_contain(listbox, path):
    for i in range(listbox.size()):
        if listbox.get(i) == path:
            return True
    return False

def drop(event):
    if event.data:
        print('Dropped data:\n', event.data)
        if event.widget == listbox:
            # event.data is a list of filenames as one string;
            # if one of these filenames contains whitespace characters
            # it is rather difficult to reliably tell where one filename
            # ends and the next begins; the best bet appears to be
            # to count on tkdnd's and tkinter's internal magic to handle
            # such cases correctly; the following seems to work well
            # at least with Windows and Gtk/X11
            files = listbox.tk.splitlist(event.data)
            for f in files:
                if os.path.exists(f):
                    if (not does_listbox_contain(listbox, f)):
                        print('Dropped file: "%s"' % f)
                        listbox.insert('end', f)
                else:
                    print('Not dropping file "%s": file does not exist.' % f)
        else:
            print('Error: reported event.widget not known')
    return event.action

# now make the Listbox and Text drop targets
listbox.drop_target_register(DND_FILES, DND_TEXT)
listbox.dnd_bind('<<DropEnter>>', drop_enter)
listbox.dnd_bind('<<DropPosition>>', drop_position)
listbox.dnd_bind('<<DropLeave>>', drop_leave)
listbox.dnd_bind('<<Drop>>', drop)

# define drag callbacks

def drag_init_listbox(event):
    # use a tuple as file list, this should hopefully be handled gracefully
    # by tkdnd and the drop targets like file managers or text editors
    data = ()
    if listbox.curselection():
        data = tuple([listbox.get(i) for i in listbox.curselection()])
        print('Dragging :', data)
    # tuples can also be used to specify possible alternatives for
    # action type and DnD type:
    # return ((ASK, COPY), (DND_FILES, DND_TEXT), data)
    return ((ASK, COPY), DND_FILES, data)

def drag_init_text(event):
    # use a string if there is only a single text string to be dragged
    data = ''
    sel = text.tag_nextrange(SEL, '1.0')
    if sel:
        data = text.get(*sel)
        print('Dragging :\n', data)
    # if there is only one possible alternative for action and DnD type
    # we can also use strings here
    return (COPY, DND_TEXT, data)

def drag_end(event):
    if ONCE:
        root.quit()

# finally make the widgets a drag source

listbox.drag_source_register(1, DND_TEXT, DND_FILES)
listbox.dnd_bind('<<DragInitCmd>>', drag_init_listbox)
listbox.dnd_bind('<<DragEndCmd>>', drag_end)

root.update_idletasks()
root.deiconify()
root.mainloop()
