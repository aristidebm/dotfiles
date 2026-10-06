import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Io
import "../Shared"

Window {
    id: window

    Theme {
        id: theme
    }

    title: "MprisPlayer"
    visible: false
    color: theme.colBackground
    width: 460
    height: 260

    // Preview selection (Tab cycling / setActive IPC). Wins over autoActive
    // while the player is still alive; never sends MPRIS commands by itself.
    property MprisPlayer manualActive: null
    // Last observed playing player, fallback for autoActive.
    property MprisPlayer _lastPlaying: null
    // Automatically chosen player: playing > last playing > first > null.
    property MprisPlayer autoActive: null

    readonly property var players: Mpris.players.values
    readonly property MprisPlayer activePlayer: (manualActive !== null && players.indexOf(manualActive) !== -1)
        ? manualActive
        : autoActive

    // ---------------------------------------------------------------- IPC

    IpcHandler {
        target: "mpris"

        function toggle() {
            if (window.visible) {
                window.hide()
            } else {
                window.open()
            }
        }

        function open() {
            window.open()
        }

        function close() {
            window.hide()
        }

        function list(): string {
            return window.players.map(p => p.identity).join("\n")
        }

        function setActive(identity: string): string {
            var vals = Mpris.players.values
            for (var i = 0; i < vals.length; i++) {
                if (vals[i].identity === identity || vals[i].desktopEntry === identity) {
                    window.manualActive = vals[i]
                    return "active: " + vals[i].identity
                }
            }
            for (var j = 0; j < vals.length; j++) {
                if (vals[j].identity.toLowerCase() === identity.toLowerCase()) {
                    window.manualActive = vals[j]
                    return "active: " + vals[j].identity
                }
            }
            return "no such player: " + identity
        }

        function getActive(prop: string): string {
            var p = window.activePlayer
            if (!p)
                return "No active player"
            var v = p[prop]
            if (v === undefined || v === null)
                return "Invalid property"
            return String(v)
        }

        function play(): void {
            window.play()
        }

        function pause(): void {
            window.pause()
        }

        function playPause(): void {
            window.playPause()
        }

        function previous(): void {
            window.previous()
        }

        function next(): void {
            window.next()
        }

        function stop(): void {
            window.stop()
        }
    }

    // ------------------------------------------------- auto selection

    Connections {
        target: Mpris.players
        function onValuesChanged() { window.updateAuto() }
    }

    Repeater {
        model: window.players

        delegate: Item {
            required property MprisPlayer modelData

            Connections {
                target: modelData
                function onIsPlayingChanged() { window.updateAuto() }
            }
        }
    }

    Component.onCompleted: updateAuto()

    function updateAuto() {
        var vals = Mpris.players.values
        if (!vals || vals.length === 0) {
            _lastPlaying = null
            autoActive = null
            return
        }

        for (var i = 0; i < vals.length; i++) {
            if (vals[i].isPlaying) {
                _lastPlaying = vals[i]
                autoActive = vals[i]
                return
            }
        }

        if (_lastPlaying && vals.indexOf(_lastPlaying) !== -1) {
            autoActive = _lastPlaying
            return
        }

        _lastPlaying = null
        autoActive = vals[0]
    }

    // ------------------------------------------------------ transport

    function pauseOthers(except) {
        var vals = Mpris.players.values
        for (var i = 0; i < vals.length; i++) {
            var p = vals[i]
            if (p !== except && p.isPlaying && p.canPause)
                p.pause()
        }
    }

    function playPause() {
        var p = activePlayer
        if (!p)
            return
        if (p.isPlaying) {
            if (p.canPause)
                p.pause()
            return
        }
        pauseOthers(p)
        if (p.canTogglePlaying)
            p.togglePlaying()
        else if (p.canPlay)
            p.play()
    }

    function play() {
        var p = activePlayer
        if (!p || !p.canPlay || p.isPlaying)
            return
        pauseOthers(p)
        p.play()
    }

    function pause() {
        var p = activePlayer
        if (p && p.canPause)
            p.pause()
    }

    function previous() {
        var p = activePlayer
        if (p && p.canGoPrevious)
            p.previous()
    }

    function next() {
        var p = activePlayer
        if (p && p.canGoNext)
            p.next()
    }

    function stop() {
        var p = activePlayer
        if (p)
            p.stop()
    }

    // ------------------------------------------------------- cycling

    function cycle(dir) {
        var vals = Mpris.players.values
        if (!vals.length)
            return
        var idx = vals.indexOf(activePlayer)
        if (idx < 0) {
            manualActive = dir > 0 ? vals[0] : vals[vals.length - 1]
            return
        }
        manualActive = vals[(idx + dir + vals.length) % vals.length]
    }

    function open() {
        show()
        raise()
        keyHandler.forceActiveFocus()
    }

    // ----------------------------------------------------- key input

    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true
        Keys.enabled: true

        Keys.onPressed: event => {
            var t = event.text
            var shift = (event.modifiers & Qt.ShiftModifier) !== 0

            if (t === ">") {
                window.next()
                event.accepted = true
            } else if (t === "<") {
                window.previous()
                event.accepted = true
            } else if (t === "p" || event.key === Qt.Key_Space) {
                window.playPause()
                event.accepted = true
            } else if (event.key === Qt.Key_Tab) {
                window.cycle(shift ? -1 : 1)
                event.accepted = true
            } else if (event.key === Qt.Key_Backtab) {
                window.cycle(-1)
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                window.hide()
                event.accepted = true
            }
        }

        // ------------------------------------------------ placeholder UI

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            // Source chips
            Flow {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: window.players

                    delegate: Rectangle {
                        required property MprisPlayer modelData

                        readonly property bool isActive: modelData === window.activePlayer

                        radius: 6
                        implicitWidth: chipLabel.implicitWidth + (modelData.isPlaying ? 37 : 24)
                        implicitHeight: 24
                        color: isActive ? Qt.alpha(theme.colNormal, 0.25) : theme.colBorder

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Text {
                                id: chipLabel
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.identity
                                color: isActive ? theme.colForeground : theme.colMuted
                                font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "\u25CF"
                                visible: modelData.isPlaying
                                color: theme.colNormal
                                font.pixelSize: 8
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: window.manualActive = modelData
                        }
                    }
                }
            }

            // Track info / placeholder
            Text {
                Layout.fillWidth: true
                text: window.activePlayer
                    ? (window.activePlayer.trackTitle || "Unknown title")
                    : "No media playing"
                color: theme.colForeground
                font { family: theme.fontFamily; pixelSize: theme.fontSize + 3; bold: true }
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Text {
                Layout.fillWidth: true
                text: window.activePlayer ? window.activePlayer.trackArtist : ""
                visible: text.length > 0
                color: theme.colMuted
                font { family: theme.fontFamily; pixelSize: theme.fontSize }
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Item { Layout.fillHeight: true }

            // Transport controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 12

                Rectangle {
                    readonly property bool can: window.activePlayer && window.activePlayer.canGoPrevious
                    implicitWidth: 36
                    implicitHeight: 36
                    radius: 18
                    opacity: can ? 1 : 0.35
                    color: prevArea.containsMouse ? Qt.alpha(theme.colNormal, 0.25) : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "\u25C0"
                        color: theme.colForeground
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: prevArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: parent.can
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.previous()
                    }
                }

                Rectangle {
                    readonly property bool can: window.activePlayer && window.activePlayer.canTogglePlaying
                    implicitWidth: 44
                    implicitHeight: 44
                    radius: 22
                    opacity: can ? 1 : 0.35
                    color: playArea.containsMouse ? Qt.alpha(theme.colNormal, 0.35) : Qt.alpha(theme.colNormal, 0.15)

                    Text {
                        anchors.centerIn: parent
                        text: window.activePlayer && window.activePlayer.isPlaying ? "\u275A\u275A" : "\u25B6"
                        color: theme.colNormal
                        font.pixelSize: 16
                    }

                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: parent.can
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.playPause()
                    }
                }

                Rectangle {
                    readonly property bool can: window.activePlayer && window.activePlayer.canGoNext
                    implicitWidth: 36
                    implicitHeight: 36
                    radius: 18
                    opacity: can ? 1 : 0.35
                    color: nextArea.containsMouse ? Qt.alpha(theme.colNormal, 0.25) : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "\u25B6"
                        color: theme.colForeground
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: nextArea
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: parent.can
                        cursorShape: Qt.PointingHandCursor
                        onClicked: window.next()
                    }
                }
            }

            // Key hints
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "tab: source   p: play   <: prev   >: next"
                color: theme.colMuted
                opacity: 0.7
                font { family: theme.fontFamily; pixelSize: theme.fontSize - 3 }
            }
        }
    }
}
