import QtQuick
import Quickshell.Io

QtObject {
    id: root

    property string configPath: Qt.resolvedUrl("../../config.json")

    // Popup settings
    property int popupWidth: 380
    property int popupMargin: 12
    property int popupMaxVisible: 3
    property bool popupShowWhenCenterOpen: true
    property string popupPosition: "top-right"

    // Center settings
    property int centerWidth: 1500
    property int centerMaxNotifications: 50

    // Timeouts (ms)
    property int timeoutLow: 5000
    property int timeoutNormal: 10000
    property int timeoutCritical: 0

    // DND
    property bool dnd: false

    // Sound
    property bool soundEnabled: true
    property string soundCriticalPath: "/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"

    // Theme colors
    property color colBackground: "#1a1b26"
    property color colForeground: "#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCritical: "#f7768e"
    property color colNormal: "#7aa2f7"
    property color colLow: "#444b6a"
    property color colBorder: "#292e42"
    property int cardRadius: 12
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 13

    property var _configData: ({})

    Component.onCompleted: reload()

    function reload() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", root.configPath, true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    root._configData = JSON.parse(xhr.responseText)
                    root._applyConfig()
                }
            }
        }
        xhr.send()
    }

    function _applyConfig() {
        var c = _configData

        if (c.popup) {
            if (c.popup.width !== undefined) popupWidth = c.popup.width
            if (c.popup.margin !== undefined) popupMargin = c.popup.margin
            if (c.popup.maxVisible !== undefined) popupMaxVisible = c.popup.maxVisible
            if (c.popup.showWhenCenterOpen !== undefined) popupShowWhenCenterOpen = c.popup.showWhenCenterOpen
            if (c.popup.position !== undefined) popupPosition = c.popup.position
        }

        if (c.center) {
            if (c.center.width !== undefined) centerWidth = c.center.width
            if (c.center.maxNotifications !== undefined) centerMaxNotifications = c.center.maxNotifications
        }

        if (c.timeouts) {
            if (c.timeouts.low !== undefined) timeoutLow = c.timeouts.low
            if (c.timeouts.normal !== undefined) timeoutNormal = c.timeouts.normal
            if (c.timeouts.critical !== undefined) timeoutCritical = c.timeouts.critical
        }

        if (c.dnd !== undefined) dnd = c.dnd

        if (c.sound) {
            if (c.sound.enabled !== undefined) soundEnabled = c.sound.enabled
            if (c.sound.criticalPath !== undefined) soundCriticalPath = c.sound.criticalPath
        }

        if (c.theme) {
            var t = c.theme
            if (t.background) colBackground = t.background
            if (t.foreground) colForeground = t.foreground
            if (t.muted) colMuted = t.muted
            if (t.critical) colCritical = t.critical
            if (t.normal) colNormal = t.normal
            if (t.low) colLow = t.low
            if (t.border) colBorder = t.border
            if (t.cardRadius !== undefined) cardRadius = t.cardRadius
            if (t.fontFamily) fontFamily = t.fontFamily
            if (t.fontSize !== undefined) fontSize = t.fontSize
        }
    }
}
