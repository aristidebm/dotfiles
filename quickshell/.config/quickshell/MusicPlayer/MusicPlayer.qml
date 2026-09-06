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

    property MprisPlayer activePlayer: null
    property var _lastPlayer: null

    visible: false
    title: "MusicPlayer"
    color: theme.colBackground
    width: 400
    height: 220

    IpcHandler {
        target: "MusicPlayer"

        function toggle() {
            if (window.visible) {
                window.hide()
            } else {
                window.show()
                window.raise()
                keyHandler.forceActiveFocus()
            }
        }

        function open() {
            window.show()
            window.raise()
            keyHandler.forceActiveFocus()
        }

        function close() {
            window.hide()
        }
    }

    // Re-run selection whenever the player list changes, or any player's
    // playback state changes. No polling: both of these have real change
    // notifications in Quickshell.
    Connections {
        target: Mpris.players
        function onValuesChanged() { updateActive() }
    }

    Repeater {
        model: Mpris.players
        delegate: Item {
            required property MprisPlayer modelData

            Connections {
                target: modelData
                function onIsPlayingChanged() { updateActive() }
                function onPlaybackStateChanged() { updateActive() }
            }
        }
    }

    Component.onCompleted: updateActive()

    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true
        Keys.enabled: true

        Keys.onPressed: event => {
            if (!window.activePlayer) return
            var t = event.text
            if (t === ">") {
                window.activePlayer.next()
                event.accepted = true
            } else if (t === "<") {
                window.activePlayer.previous()
                event.accepted = true
            } else if (event.key === Qt.Key_Space || t === "p") {
                window.activePlayer.togglePlaying()
                event.accepted = true
            }
        }

        PlayerCard {
            anchors.fill: parent
            player: window.activePlayer
        }
    }

    function updateActive() {
        var vals = Mpris.players.values
        if (!vals || vals.length === 0) {
            activePlayer = null
            _lastPlayer = null
            return
        }

        // Prefer isPlaying player
        for (var i = 0; i < vals.length; i++) {
            if (vals[i].isPlaying) {
                _lastPlayer = vals[i]
                activePlayer = vals[i]
                return
            }
        }

        // Keep last active if still in list
        if (_lastPlayer) {
            for (var j = 0; j < vals.length; j++) {
                if (vals[j] === _lastPlayer) {
                    activePlayer = _lastPlayer
                    return
                }
            }
            _lastPlayer = null
        }

        // Fallback to first available
        activePlayer = vals[0]
    }
}
