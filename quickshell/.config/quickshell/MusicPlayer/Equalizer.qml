import QtQuick
import "../Shared"

Item {
    id: root

    property bool playing: false
    property int barCount: 20
    property real minBarHeight: 4
    property real barSpacing: 2
    property int minInterval: 150
    property int maxInterval: 400

    Theme {
        id: theme
    }

    Row {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: root.barSpacing

        Repeater {
            model: root.barCount

            Rectangle {
                id: bar

                width: (root.width - (root.barCount - 1) * root.barSpacing) / root.barCount
                height: root.minBarHeight
                radius: width / 2
                color: theme.colNormal
                opacity: 0.8

                anchors.bottom: parent.bottom

                Behavior on height {
                    NumberAnimation {
                        duration: 220
                        easing.type: Easing.InOutQuad
                    }
                }

                Timer {
                    // Stagger each bar's own interval so the row doesn't pulse in lockstep.
                    interval: root.minInterval + Math.random() * (root.maxInterval - root.minInterval)
                    running: root.playing
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: bar.height = root.minBarHeight + Math.random() * (root.height - root.minBarHeight)
                }

                Connections {
                    target: root
                    function onPlayingChanged() {
                        if (!root.playing) bar.height = root.minBarHeight
                    }
                }
            }
        }
    }
}
