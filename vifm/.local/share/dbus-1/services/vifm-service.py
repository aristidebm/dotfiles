#!/usr/bin/env python

# source: https://gist.github.com/ljb/30a21952158dfe59c8168d7248176e3b

# This program is free software. It comes without any warranty, to the extent
# permitted by applicable law. You can redistribute it and/or modify it under
# the terms of the Do What The Fuck You Want To Public License, Version 2, as
# published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

"""
This is a simple daemon implementing freedesktop.org's file manager interface
https://www.freedesktop.org/wiki/Specifications/file-manager-interface/
"""

import dbus
import os
import subprocess
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib
from urllib.parse import unquote

def open_file_manager(uri, select=False):
    # This uses the vifmrun wrapper from vifmimg (which support image previews).
    # If this is not desired, vifm can be used directly instead.
    args = ['st', '-e', 'vifm']
    # args = ['st', '-e', '/home/aristide/.nix-profile/bin/vifm']
    if select:
        args.append('--select')

    path = unquote(str(uri)).removeprefix('file://')
    args.append(path)

    subprocess.Popen(
        args,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=None,
        start_new_session=True,
    )

class FmObject(dbus.service.Object):

    @dbus.service.method("org.freedesktop.FileManager1", in_signature='ass', out_signature='')
    def ShowFolders(self, uris, startupId):
        open_file_manager(uris[0])

    @dbus.service.method("org.freedesktop.FileManager1",in_signature='ass', out_signature='')
    def ShowItems(self, uris, startupId):
        open_file_manager(uris[0], select=True)

    @dbus.service.method("org.freedesktop.FileManager1",in_signature='ass', out_signature='')
    def ShowItemProperties(self, uris, startupId):
        open_file_manager(uris[0], select=True)

    @dbus.service.method("org.freedesktop.FileManager1",in_signature='', out_signature='')
    def Exit(self):
        mainloop.quit()

def main() -> None:
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    session_bus = dbus.SessionBus()
    dbus.service.BusName("org.freedesktop.FileManager1", session_bus)
    FmObject(session_bus, '/org/freedesktop/FileManager1')
    mainloop = GLib.MainLoop()
    mainloop.run()

if __name__ == '__main__':
    main()

# For debugging
# dbus-send --print-reply --dest=org.freedesktop.FileManager1 --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowItems array:string:"file:///home/" string:""

# grep -R FileManager1 /usr/share/dbus-1/services
# busctl --user status org.freedesktop.FileManager1
# systemctl --user show-environment | grep PATH

