import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

Rectangle {
    id: root

    required property var theme
    required property var notifData
    required property bool inPopup

    property var notif: null
    property bool _dismissHandled: false

    signal dismissed()
    signal expired()
    signal closedExternally()

    readonly property bool canReply: notifData && notifData.hasInlineReply

    function urgencyColor() {
        if (!notifData) return theme.colMuted
        switch (notifData.urgency) {
            case NotificationUrgency.Critical: return theme.colCritical
            case NotificationUrgency.Normal: return theme.colNormal
            case NotificationUrgency.Low: return theme.colLow
            default: return theme.colMuted
        }
    }

    function urgencyTimeout() {
        if (!notifData) return 10000
        switch (notifData.urgency) {
            case NotificationUrgency.Critical: return 0
            case NotificationUrgency.Normal: return theme.timeoutNormal
            case NotificationUrgency.Low: return theme.timeoutLow
            default: return 10000
        }
    }

    function sendReply() {
        if (root.notif && replyInput.text !== "") {
            root.notif.sendInlineReply(replyInput.text)
            root.dismissed()
        }
    }

    function _armExpire() {
        expireTimer.stop()
        if (inPopup && notifData && notifData.urgency !== NotificationUrgency.Critical) {
            var timeout = urgencyTimeout()
            if (timeout > 0) {
                expireTimer.interval = timeout
                expireTimer.start()
            }
        }
    }

    width: parent ? parent.width : theme.popupWidth
    height: cardLayout.implicitHeight + 24
    radius: theme.cardRadius
    color: theme.colBackground
    border.color: urgencyColor()
    border.width: notifData && notifData.urgency === NotificationUrgency.Critical ? 2 : 1

    implicitWidth: theme.popupWidth
    implicitHeight: cardLayout.implicitHeight + 24

    ColumnLayout {
        id: cardLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // App icon
            Image {
                source: notifData ? notifData.appIcon : ""
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                visible: source.toString() !== ""
                asynchronous: true
                smooth: true
            }

            // App name
            Text {
                text: notifData ? notifData.appName : ""
                color: theme.colMuted
                font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                Layout.fillWidth: true
                elide: Text.ElideRight
                visible: text !== ""
            }

            // Urgency badge
            Rectangle {
                Layout.preferredWidth: 8
                Layout.preferredHeight: 8
                radius: 4
                color: urgencyColor()
                visible: notifData && notifData.urgency === NotificationUrgency.Critical
            }

            // Dismiss button
            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                radius: 10
                color: dismissArea.containsMouse ? Qt.alpha(theme.colCritical, 0.3) : "transparent"
                visible: true

                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: theme.colMuted
                    font { family: theme.fontFamily; pixelSize: theme.fontSize + 2 }
                }

                MouseArea {
                    id: dismissArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root.dismissed()
                }
            }
        }

        // Summary
        Text {
            text: notifData ? notifData.summary : ""
            color: theme.colForeground
            font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            visible: text !== ""
        }

        // Body
        Text {
            text: notifData ? notifData.body : ""
            color: theme.colForeground
            font { family: theme.fontFamily; pixelSize: theme.fontSize - 1 }
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            maximumLineCount: 3
            elide: Text.ElideRight
            opacity: 0.8
            visible: text !== ""
        }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: notifData && notifData.actions && notifData.actions.length > 0

            Repeater {
                model: notifData ? notifData.actions : []

                Rectangle {
                    required property var modelData
                    required property int index

                    Layout.fillWidth: true
                    Layout.preferredHeight: 28
                    radius: 6
                    color: Qt.alpha(urgencyColor(), 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: modelData.text
                        color: theme.colForeground
                        font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.invoke()
                            root.dismissed()
                        }
                    }
                }
            }
        }

        // Inline reply
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: notifData && notifData.hasInlineReply

            property alias replyField: replyInput

            TextInput {
                id: replyInput
                Layout.fillWidth: true
                Layout.preferredHeight: 28
                color: theme.colForeground
                font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                verticalAlignment: Text.AlignVCenter
                clip: true

                onAccepted: root.sendReply()
                onActiveFocusChanged: {
                    if (activeFocus) expireTimer.stop()
                    else root._armExpire()
                }
                Keys.onEscapePressed: replyInput.focus = false

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: Qt.alpha(theme.colBorder, 0.5)
                    z: -1
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    text: notifData && notifData.inlineReplyPlaceholder ? notifData.inlineReplyPlaceholder : "Reply..."
                    color: theme.colMuted
                    font: replyInput.font
                    verticalAlignment: Text.AlignVCenter
                    visible: replyInput.text === "" && !replyInput.activeFocus
                }
            }

            Rectangle {
                Layout.preferredWidth: 50
                Layout.preferredHeight: 28
                radius: 6
                color: Qt.alpha(urgencyColor(), 0.3)

                Text {
                    anchors.centerIn: parent
                    text: "Send"
                    color: theme.colForeground
                    font { family: theme.fontFamily; pixelSize: theme.fontSize - 2 }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.sendReply()
                }
            }
        }
    }

    Component.onCompleted: {
        if (notif && notif.closed) {
            notif.closed.connect(function() { closedExternally() })
        }
        root._armExpire()
    }

    Timer {
        id: expireTimer
        repeat: false
        onTriggered: root.expired()
    }
}
