import Quickshell

import "AppLauncher"
import "ActivateLinux"
import "NotificationServer"
import "MprisPlayer"

ShellRoot {
    id: self
    AppLauncher {}
    // ActivateLinux {}
    NotificationServer {}
    MprisPlayer {}
}
