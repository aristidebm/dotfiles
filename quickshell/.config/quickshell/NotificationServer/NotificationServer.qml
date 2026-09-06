import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "../Shared"

Scope {
    id: root

    Theme {
        id: theme
    }

    NotificationHistory {
        id: history
        maxEntries: theme.centerMaxNotifications
    }

    Process {
        id: soundProcess
    }

    NotificationServer {
        id: server

        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        bodyImagesSupported: true
        bodyHyperlinksSupported: true
        actionIconsSupported: true
        inlineReplySupported: true
        persistenceSupported: true

        onNotification: (notif) => {
            notif.tracked = true
            history.add(notif)

            if (theme.soundEnabled && notif.urgency === NotificationUrgency.Critical) {
                soundProcess.running = false
                soundProcess.command = ["paplay", theme.soundCriticalPath]
                soundProcess.running = true
            }
        }
    }

    NotificationPopup {
        id: popup
        theme: theme
        server: server
        centerVisible: center.visible
    }

    NotificationCenter {
        id: center
        theme: theme
        history: history
    }

    IpcHandler {
        target: "NotificationServer"

        function toggleCenter(): bool {
            if (center.visible) {
                center.hide()
            } else {
                center.show()
            }
            return center.visible
        }

        function toggleDnd(): bool {
            theme.dnd = !theme.dnd
            return theme.dnd
        }

        function clearAll(): bool {
            history.clearAll()
            return true
        }
    }
}
