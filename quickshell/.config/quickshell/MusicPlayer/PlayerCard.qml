import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import "../Shared"

Rectangle {
    id: root

    property MprisPlayer player: null

    onPlayerChanged: positionSlider.updatePosition()

    color: theme.colBackground
    radius: theme.cardRadius
    border.color: theme.colBorder
    border.width: 1

    implicitWidth: 400
    implicitHeight: 200

    Theme {
        id: theme
    }

    // Placeholder when no player
    ColumnLayout {
        anchors.centerIn: parent
        visible: root.player === null
        spacing: 4

        Text {
            text: "\u266B"
            color: theme.colMuted
            font.pixelSize: 28
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "No media playing"
            color: theme.colMuted
            font { family: theme.fontFamily; pixelSize: theme.fontSize }
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Timer {
        interval: 1000
        running: root.player !== null && root.player.isPlaying
        repeat: true
        onTriggered: positionSlider.updatePosition()
    }

    // Player UI
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        visible: root.player !== null

        // Top: album art + equalizer
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 80
            radius: 6
            color: theme.colBorder
            clip: true

            property bool hasArt: root.player && root.player.trackArtUrl.toString() !== ""

            Image {
                id: albumArt
                z: 0
                anchors.fill: parent
                source: root.player ? root.player.trackArtUrl : ""
                asynchronous: true
                smooth: true
                fillMode: Image.PreserveAspectCrop
                visible: parent.hasArt
            }

            Rectangle {
                z: 1
                anchors.fill: parent
                color: Qt.alpha(theme.colBackground, 0.6)
                visible: parent.hasArt
            }

            Equalizer {
                z: 2
                anchors.fill: parent
                anchors.margins: 8
                playing: root.player && root.player.isPlaying
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.player && root.player.canRaise)
                        root.player.raise()
                }
            }
        }

        // Bottom: track info + controls
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            spacing: 4

            // Title
            Text {
                text: root.player ? root.player.trackTitle : ""
                color: theme.colForeground
                font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            // Artist
            Text {
                text: root.player ? root.player.trackArtist : ""
                color: theme.colMuted
                font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
                opacity: 0.8
            }

            // Progress bar
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: formatTime(positionSlider.currentPosition)
                    color: theme.colMuted
                    font { family: theme.fontFamily; pixelSize: theme.fontSize - 3 }
                }

                Slider {
                    id: positionSlider
                    Layout.fillWidth: true

                    property real currentPosition: 0
                    property real maxLength: root.player ? root.player.length : 0

                    from: 0
                    to: maxLength > 0 ? maxLength : 1

                    background: Rectangle {
                        x: positionSlider.leftPadding
                        y: positionSlider.topPadding + positionSlider.availableHeight / 2 - height / 2
                        width: positionSlider.availableWidth
                        height: 4
                        radius: 2
                        color: theme.colBorder

                        Rectangle {
                            width: positionSlider.visualPosition * parent.width
                            height: parent.height
                            radius: 2
                            color: theme.colNormal
                        }
                    }

                    handle: Rectangle {
                        x: positionSlider.leftPadding + positionSlider.visualPosition * (positionSlider.availableWidth - width)
                        y: positionSlider.topPadding + positionSlider.availableHeight / 2 - height / 2
                        width: 12
                        height: 12
                        radius: 6
                        color: theme.colNormal
                        visible: positionSlider.pressed
                    }

                    onMoved: {
                        if (root.player)
                            root.player.seek((value - currentPosition) * 1000000)
                        currentPosition = value
                    }

                    function updatePosition() {
                        if (!root.player || pressed)
                            return
                        currentPosition = root.player.position
                        value = currentPosition
                    }

                    Component.onCompleted: updatePosition()
                }

                Text {
                    text: formatTime(positionSlider.maxLength)
                    color: theme.colMuted
                    font { family: theme.fontFamily; pixelSize: theme.fontSize - 3 }
                }
            }

            // Controls
            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    radius: 16
                    color: prevArea.containsMouse ? Qt.alpha(theme.colNormal, 0.2) : "transparent"
                    visible: root.player && root.player.canGoPrevious

                    Text {
                        anchors.centerIn: parent
                        text: "\u25C0"
                        color: theme.colForeground
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: prevArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.player.previous()
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: 18
                    color: playArea.containsMouse ? Qt.alpha(theme.colNormal, 0.3) : Qt.alpha(theme.colNormal, 0.1)
                    visible: root.player && root.player.canTogglePlaying

                    Text {
                        anchors.centerIn: parent
                        text: root.player && root.player.isPlaying ? "\u275A\u275A" : "\u25B6"
                        color: theme.colNormal
                        font.pixelSize: 16
                    }

                    MouseArea {
                        id: playArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.player.togglePlaying()
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    radius: 16
                    color: nextArea.containsMouse ? Qt.alpha(theme.colNormal, 0.2) : "transparent"
                    visible: root.player && root.player.canGoNext

                    Text {
                        anchors.centerIn: parent
                        text: "\u25B6"
                        color: theme.colForeground
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: nextArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.player.next()
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }
    }

    function formatTime(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }
}
