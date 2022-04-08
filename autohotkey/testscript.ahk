
 #SPACE::  Winset, Alwaysontop, , A
return

#Insert::
run C:\Users\Lion\AppData\Local\Programs\Python\Python37\python.exe D:\labs\hexomancer-sioyek\sioyek\deploy.py
return

GetSelectedText(){
    prevclipboard = %Clipboard%
    Clipboard=
    Send, ^c
    ClipWait, 1
    selected = %Clipboard%
    Clipboard = %prevclipboard%
    return selected
}


#IfWinActive ahk_class Notepad
#f::
    Send, {Alt down}{Alt up}fa^l
    path := GetSelectedText()
    Send, !{f4}
    run wt lf "%path%"
    return

#IfWinActive ahk_class CabinetWClass
#f::
    prevclip = %Clipboard%
    Clipboard=
    Send, +{AppsKey}a
    ClipWait, 0.25
    if %ErrorLevel% {
        Send, {Esc}^lwt lf{Enter}
        return
    } else {
        pth = %Clipboard%
        Clipboard = prevclip
        run wt lf "%pth%"
        return
    }
    return

#IfWinActive ahk_exe vlc.exe
#f::
    Send, ^l{Tab}{AppsKey}{Down}{Down}{Down}{Down}{Enter}
    Sleep, 0.5
    Send, +{Tab 2}
    pth := GetSelectedText()
    Send, !{f4}
    Sleep, 0.25
    Send, ^l
    run wt lf "%pth%"
    return

#IfWinActive ahk_exe chrome.exe
#f::
    Send, ^j
    Sleep, 500
    Send, {Click 770 290}
    Sleep, 500
    Clipboard=
    Send, +{AppsKey}a
    ClipWait, 1
    if %ErrorLevel% {
        run wt lf
        return
    } else{
        pth = %Clipboard%
        Send, !{f4}
        Sleep, 500
        Send, ^w
        run wt lf %pth%
        return
    }

#IfWinActive ahk_exe IDMan.exe
#f::
    Send, {AppsKey}{Up}{Enter}
    pth := GetSelectedText()
    Send, !{f4}!{f4}
    run wt lf "%pth%"
    return

#IfWinActive ahk_exe nvim-qt.exe
#f::
    percent := Chr(37)
    Send, :{!} wt lf %percent%{Enter}
    return

#IfWinActive ahk_exe Code.exe
#f::
    Clipboard=
    Send, ^+pCopy path of active file{Enter}
    ClipWait, 1
    run wt lf "%Clipboard%"
    return

#IfWinActive ahk_exe devenv.exe
#f::
    Clipboard=
    Send, ^!c ; requires to bind control+alt+c to File.CopyFullPath in Visual Studio
    ClipWait, 1
    run wt lf "%Clipboard%"
    return

#IfWinActive ahk_exe sioyek.exe
#f::
    Clipboard=
    Send, ^+o^a^c{Esc} ; requires to bind control+alt+c to File.CopyFullPath in Visual Studio
    ClipWait, 1
    run wt lf "%Clipboard%"
    return


#IfWinActive
#f::
    run wt lf
    return
