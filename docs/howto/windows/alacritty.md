# Alacritty

[Alacritty terminal](https://alacritty.org/) is a GPU accelerated terminal which has some nice quirks.

## Enable Mouse events in Windows

After installing Alacritty in Windows 10 it does not support mouse events out of the box, to cure that you need to replace `conhost.exe`.

How to replace `conhost.exe`:

1. Open a Windows terminal as Administrator.

   (Optional): start `explorer.exe` by typing `explorer.exe` in Windows terminal if you are new to the terminal
               and do the the manipulation following Rename and Copy steps through file explorer.

2. Rename `C:\Windows\System32\conhost.exe` to `C:\Windows\System32\conhost.bak`.
3. Copy `C:\Program Files\WindowsApps\Microsoft.WindowsTerminal{CURRNET_VERSION}\OpenConsole.exe` to `C:\Windows\System32`.
4. Rename `C:\Windows\System32\OpenConsole.exe` to `C:\Windows\System32\conhost.exe`.
5. Close Windows Terminal.
6. Start Alacritty,
7. Verify Alacritty sub process in Task manager Process tab has now `OpenConsole.exe` started.
8. Now your Alacritty terminal should be able to recieve mouse events,
