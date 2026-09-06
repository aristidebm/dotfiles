import QtQuick

ListModel {
    id: root

    property int maxEntries: 50

    function add(notif) {
        root.append({
            appName: notif.appName || "",
            summary: notif.summary || "",
            body: notif.body || "",
            appIcon: notif.appIcon || "",
            urgency: notif.urgency,
            timestamp: Date.now(),
            id: notif.id
        })

        while (root.count > maxEntries) {
            root.remove(root.count - 1)
        }
    }

    function clearAll() {
        root.clear()
    }

    function removeEntry(idx) {
        if (idx >= 0 && idx < root.count) {
            root.remove(idx)
        }
    }
}
