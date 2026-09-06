import Quickshell

import "AppLauncher"
import "ActivateLinux"
import "NotificationServer"
import "MusicPlayer"

ShellRoot {
    id: self
    AppLauncher {}
    // ActivateLinux {}
    NotificationServer {}
    MusicPlayer {}
}
